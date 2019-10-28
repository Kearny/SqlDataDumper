package com.kearny.sqldatadumper.domain;

import lombok.Data;
import lombok.experimental.SuperBuilder;

import java.util.HashMap;
import java.util.List;

@SuperBuilder
@Data
public class Table {

    private String schemaName;
    private String name;
    private String select;
    private String insert;
    private List<Column> columns;
    private HashMap<Integer, String[]> rows;
    private List<Table> foreignTables;

    public String getValueToString(int rowIndex, int ordinal) {

        String value = getValue(rowIndex, ordinal);
        if (value == null || value.equalsIgnoreCase("NULL")) {
            return "NULL";
        }

        var type = columns.get(ordinal - 1).getType();

        switch (type) {
            case "bpchar":
            case "varchar":
            case "text":
            case "character varying":
            case "character":
            case "timestamp":
            case "timestamp without time zone":
                return String.format("'%s'", value);
            case "boolean":
                if (value.equalsIgnoreCase("T")) {
                    return "TRUE";
                } else {
                    return "FALSE";
                }
            default:
                return value;
        }
    }

    public String getValue(int rowIndex, int ordinal) {
        final var values = rows.get(rowIndex);
        return values[ordinal - 1];
    }

    public void setValue(int rowNumber, int dataOrdinal, String value) {
        rows.get(rowNumber)[dataOrdinal] = value;
    }
}
