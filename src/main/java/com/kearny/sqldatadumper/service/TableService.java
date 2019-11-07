package com.kearny.sqldatadumper.service;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kearny.sqldatadumper.domain.Column;
import com.kearny.sqldatadumper.domain.ForeignTable;
import com.kearny.sqldatadumper.domain.Table;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Slf4j
@Service
public class TableService {

    private final ConnectionService connectionService;
    private Set<String> exportedTables = new HashSet<>();

    void hydrateTable(final Table table)
            throws SQLException, IOException {

        // We don't want to parse twice the same table, maybe ?
        if (exportedTables.contains(table.getName())) {
            return;
        }

        if (table.getSelect() == null) {
            return;
        }

        exportedTables.add(table.getName());

        findColumnsProperties(table);

        findAllRowsData(table);

        buildInsert(table);

        findForeignTables(table);

        hydrateForeignTables(table);
    }

    void findColumnsProperties(final Table table)
            throws SQLException {

        final var query = String.format("SELECT column_name, data_type, ordinal_position" +
                                                " FROM information_schema.columns" +
                                                " WHERE table_schema = '%s'" +
                                                " AND table_name = '%s'" +
                                                " ORDER BY ordinal_position;",
                                        table.getSchemaName(),
                                        table.getName());

        final var resultSet = connectionService.runSqlQuery(query);

        final var columns = new ArrayList<Column>();
        while (resultSet.next()) {
            columns.add(Column.builder()
                              .name(resultSet.getString(1))
                              .type(resultSet.getString(2))
                              .ordinal(Integer.valueOf(resultSet.getString(3)))
                              .build());
        }

        table.setColumns(columns);
    }

    void findAllRowsData(final Table table)
            throws SQLException {

        final var resultSet = connectionService.runSqlQuery(table.getSelect());

        final var rows = new HashMap<Integer, String[]>();
        var nbRows = 0;
        while (resultSet.next()) {
            final var columnsSize = table.getColumns().size();
            final var row = new String[columnsSize];
            for (int i = 0; i < columnsSize; i++) {
                row[i] = resultSet.getString(i + 1);
            }
            rows.put(nbRows, row);
            nbRows++;
        }

        table.setRows(rows);
    }

    void buildInsert(final Table table) {

        final StringBuilder insert = new StringBuilder();

        final var columnNames = table.getColumns().stream()
                                     .map(Column::getName)
                                     .collect(Collectors.toList());

        for (final Map.Entry<Integer, String[]> entry : table.getRows().entrySet()) {
            final Integer i = entry.getKey();
            final var stringRowValues = table.getRowValuesToString(i);

            insert.append(String.format(
                    "INSERT INTO %s.%s (%s) VALUES (%s);",
                    table.getSchemaName(),
                    table.getName(),
                    String.join(", ", columnNames),
                    String.join(", ", stringRowValues)
            ));
        }

        table.setInsert(insert.toString());
    }

    void hydrateForeignTables(final Table table)
            throws SQLException, IOException {

        for (final Table foreignTable : table.getForeignTables()) {
            hydrateTable(foreignTable);
        }
    }

    void findForeignTables(final Table table)
            throws SQLException {

        final var query = String.format("SELECT pg_catalog.pg_get_constraintdef(r.oid, TRUE) AS condef" +
                                                " FROM pg_catalog.pg_constraint r" +
                                                " WHERE r.conrelid = '%s.%s'::regclass" +
                                                "   AND r.contype = 'f'" +
                                                " ORDER BY 1;",
                                        table.getSchemaName(),
                                        table.getName());

        final var resultSet = connectionService.runSqlQuery(query);
        final var foreignTables = new ArrayList<Table>();
        while (resultSet.next()) {
            final var foreignTable = buildForeignTableFromDefinition(resultSet.getString(1));

            // TODO : Prendre en compte toutes les lignes pas juste la première
            buildForeignTableSelect(foreignTable, table.getValueToString(0, foreignTable.getLinkParentColumn()));

            foreignTables.add(foreignTable);
        }

        table.setForeignTables(foreignTables);
    }

    private void buildForeignTableSelect(final ForeignTable foreignTable, final String linkValue) {

        if (linkValue == null || linkValue.equalsIgnoreCase("NULL")) {
            return;
        }

        var select = MessageFormat.format(
                "SELECT * FROM {0}.{1}"
                        + " WHERE {2} = {3}",
                foreignTable.getSchemaName(),
                foreignTable.getName(),
                foreignTable.getLinkChildrenColumn(),
                linkValue
        );

        foreignTable.setSelect(select);
    }

    ForeignTable buildForeignTableFromDefinition(final String string) {

        var inputString = string.replace("FOREIGN KEY (", "");
        inputString = inputString.replace(") REFERENCES ", " ");
        inputString = inputString.replace(".", " ");
        inputString = inputString.replace("(", " ");
        inputString = inputString.replace(")", "");
        final var s = inputString.split(" ");

        final var linkParentColumn = s[0];
        final var schemaName = s[1];
        final var name = s[2];
        final var linkChildrenColumn = s[3];

        return ForeignTable.builder()
                           .name(name)
                           .schemaName(schemaName)
                           .linkParentColumn(linkParentColumn)
                           .linkChildrenColumn(linkChildrenColumn)
                           .build();
    }
}
