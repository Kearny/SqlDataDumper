package com.kearny.sqldatadumper.service;

import com.kearny.sqldatadumper.domain.Column;
import com.kearny.sqldatadumper.domain.Table;
import jdk.jshell.spi.ExecutionControl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class TableService {

    private final ConnectionService connectionService;

    void hydrateTable(Table table) throws SQLException, ExecutionControl.NotImplementedException {

        buildSelect(table);

        findColumnNames(table);

        buildInsert(table);

        findForeignTables(table);
    }

    void buildSelect(Table table) throws ExecutionControl.NotImplementedException {

        table.setSelect(
                String.format(
                        "SELECT * FROM %s.%s WHERE %s = '%s';",
                        table.getSchemaName(),
                        table.getName(),
                        table.getPrimaryKeyColumn().getName(),
                        table.getPrimaryKeyColumn().getValueToString()
                )
        );
    }

    private void findColumnNames(Table table) throws SQLException {
        var query = String.format("SELECT column_name" +
                        " FROM information_schema.columns" +
                        " WHERE table_schema = '%s'" +
                        " AND table_name   = '%s';",
                table.getSchemaName(),
                table.getName());
        var resultSet = connectionService.runSqlQuery(query);
        var columns = new ArrayList<Column>();
        while (resultSet.next()) {
            columns.add(Column.builder()
                    .name(resultSet.getString(1))
                    .build());
        }

        table.setColumns(columns);
    }

    private void buildInsert(Table table) throws SQLException {

        var values = new ArrayList<String>();

        final var resultSet = connectionService.runSqlQuery(table.getSelect());
        final var metaData = resultSet.getMetaData();

        while (resultSet.next()) {
            for (int i = 1; i <= metaData.getColumnCount(); i++) {
                final var resultSetValue = resultSet.getString(i);
                final var column = table.getColumns().get(i - 1);
                column.setValue(resultSetValue);
                column.setType(metaData.getColumnTypeName(i));
                values.add(resultSetValue);
            }
        }

        List<String> columnNames = table.getColumns().stream()
                .map(Column::getName)
                .collect(Collectors.toList());
        table.setInsert(
                String.format(
                        "INSERT INTO %s.%s (%s) VALUES (%s);",
                        table.getSchemaName(),
                        table.getName(),
                        String.join(", ", columnNames),
                        String.join(", ", values)
                )
        );
    }

    private void findForeignTables(Table table) throws SQLException, ExecutionControl.NotImplementedException {
        listForeignTables(table);
    }

    private void listForeignTables(Table sourceTable) throws SQLException, ExecutionControl.NotImplementedException {
        var query = String.format("SELECT ccu.table_schema AS foreign_table_schema," +
                        " ccu.table_name AS foreign_table_name," +
                        " ccu.column_name AS foreign_column_name," +
                        " kcu.column_name AS source_column_name" +
                        " FROM information_schema.table_constraints AS tc" +
                        " JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name" +
                        " AND tc.table_schema = kcu.table_schema" +
                        " JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name" +
                        " AND ccu.table_schema = tc.table_schema" +
                        " WHERE tc.constraint_type = 'FOREIGN KEY'" +
                        " AND kcu.table_schema = '%s'" +
                        " AND kcu.table_name = '%s'" +
                        " GROUP BY foreign_table_schema, foreign_table_name, source_column_name, foreign_column_name;",
                sourceTable.getSchemaName(),
                sourceTable.getName());

        final var resultSet = connectionService.runSqlQuery(query);
        var foreignTables = new ArrayList<Table>();
        while (resultSet.next()) {
            var foreignTableSchema = resultSet.getString(1);
            var foreignTableName = resultSet.getString(2);
            var foreignColumnName = resultSet.getString(3);
            var sourceColumnName = resultSet.getString(4);

            final var sourceColumn = sourceTable.getColumns().stream()
                    .filter(column -> Objects.equals(column.getName(), sourceColumnName))
                    .findFirst().orElseThrow(NullPointerException::new);

            final var foreignTable = Table.builder()
                    .schemaName(foreignTableSchema)
                    .name(foreignTableName)
                    .primaryKeyColumn(Column.builder()
                            .name(foreignColumnName)
                            .value(sourceColumn.getValue())
                            .type(sourceColumn.getType())
                            .build())
                    .build();

            hydrateTable(foreignTable);

            foreignTables.add(foreignTable);
        }

        sourceTable.setForeignTables(foreignTables);

    }
}
