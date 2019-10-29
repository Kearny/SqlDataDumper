package com.kearny.sqldatadumper.service;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.logging.log4j.util.Strings;
import org.springframework.stereotype.Service;

import com.kearny.sqldatadumper.domain.Column;
import com.kearny.sqldatadumper.domain.Table;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TableService {

    private final ConnectionService connectionService;
    private BufferedWriter writer;
    private Set<String> exportedTables = new HashSet<>();

    public TableService(ConnectionService connectionService) {

        this.connectionService = connectionService;
        try {
            writer = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream("export.sql"), StandardCharsets.UTF_8
            ));
            writer.write("-- Generated File --");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    void hydrateTable(Table table)
            throws SQLException, IOException {

        // We don't want to parse twice the same table, maybe ?
        if (exportedTables.contains(table.getName())) {
            return;
        }

        exportedTables.add(table.getName());

        if (Strings.isBlank(table.getSelect())) {
            buildSelect(table);
        }

        findColumnsProperties(table);

        findAllRowsData(table);

        buildInsert(table);

        //        hydrateForeignTables(table);

        writeData(table);
        writer.flush();
    }

    void buildSelect(Table table) {

        table.setSelect(
                String.format(
                        "SELECT * FROM %s.%s WHERE %s = %s;",
                        table.getSchemaName(),
                        table.getName(),
                        table.getColumns().get(0).getName(),
                        table.getValueToString(0, 1)
                )
        );
    }

    void findColumnsProperties(Table table)
            throws SQLException {

        var query = String.format("SELECT column_name, data_type, ordinal_position" +
                                          " FROM information_schema.columns" +
                                          " WHERE table_schema = '%s'" +
                                          " AND table_name = '%s'" +
                                          " ORDER BY ordinal_position;",
                                  table.getSchemaName(),
                                  table.getName());

        var resultSet = connectionService.runSqlQuery(query);

        var columns = new ArrayList<Column>();
        while (resultSet.next()) {
            columns.add(Column.builder()
                              .name(resultSet.getString(1))
                              .type(resultSet.getString(2))
                              .ordinal(Integer.valueOf(resultSet.getString(3)))
                              .build());
        }

        table.setColumns(columns);
    }

    void findAllRowsData(Table table)
            throws SQLException {

        var resultSet = connectionService.runSqlQuery(table.getSelect());

        var rows = new HashMap<Integer, String[]>();
        var nbRows = 0;
        while (resultSet.next()) {
            final var columnsSize = table.getColumns().size();
            var row = new String[columnsSize];
            for (int i = 0; i < columnsSize; i++) {
                row[i] = resultSet.getString(i + 1);
            }
            rows.put(nbRows, row);
            nbRows++;
        }

        table.setRows(rows);
    }

    void buildInsert(Table table) {

        StringBuilder insert = new StringBuilder();

        final var columnNames = table.getColumns().stream()
                                     .map(Column::getName)
                                     .collect(Collectors.toList());

        for (Map.Entry<Integer, String[]> entry : table.getRows().entrySet()) {
            Integer i = entry.getKey();
            String[] values = entry.getValue();
            var stringRowValues = table.getRowValuesToString(i);

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

    //    private void hydrateForeignTables(Table table) throws SQLException, ExecutionControl.NotImplementedException, IOException {
    //        ArrayList<Table> foreignTables = findForeignTables(table);
    //
    //        for (Table foreignTable : foreignTables) {
    //            hydrateTable(foreignTable);
    //
    //            foreignTables.add(foreignTable);
    //        }
    //
    //        table.setForeignTables(foreignTables);
    //    }
    //
    //    private ArrayList<Table> findForeignTables(Table table) throws SQLException {
    //        var query = String.format("SELECT ccu.table_schema AS foreign_table_schema," +
    //                        " ccu.table_name AS foreign_table_name," +
    //                        " ccu.column_name AS foreign_column_name," +
    //                        " kcu.column_name AS source_column_name" +
    //                        " FROM information_schema.table_constraints AS tc" +
    //                        " JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name" +
    //                        " AND tc.table_schema = kcu.table_schema" +
    //                        " JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name" +
    //                        " AND ccu.table_schema = tc.table_schema" +
    //                        " WHERE tc.constraint_type = 'FOREIGN KEY'" +
    //                        " AND kcu.table_schema = '%s'" +
    //                        " AND kcu.table_name = '%s'" +
    //                        " GROUP BY foreign_table_schema, foreign_table_name, source_column_name, foreign_column_name;",
    //                table.getSchemaName(),
    //                table.getName());
    //
    //        final var resultSet = connectionService.runSqlQuery(query);
    //        var foreignTables = new ArrayList<Table>();
    //        while (resultSet.next()) {
    //            var foreignTableSchema = resultSet.getString(1);
    //            var foreignTableName = resultSet.getString(2);
    //            var foreignColumnName = resultSet.getString(3);
    //            var sourceColumnName = resultSet.getString(4);
    //
    //            final var rows = new HashMap<Integer, String[]>();
    //            final var rowData = null;
    //            rowData.add(table.getValue(sourceColumnName));
    //            rows.put(0, rowData);
    //
    //            final var foreignTable = Table.builder()
    //                    .schemaName(foreignTableSchema)
    //                    .name(foreignTableName)
    //                    .rows(rows)
    //                    .build();
    //
    //
    //            foreignTables.add(foreignTable);
    //        }
    //        return foreignTables;
    //    }

    private void writeData(Table table) {

        if (table.getForeignTables() != null && !table.getForeignTables().isEmpty()) {
            table.getForeignTables().forEach(this::writeData);
        }

        if (table.getInsert() != null) {
            try {
                writer.newLine();
                writer.append(table.getInsert());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
