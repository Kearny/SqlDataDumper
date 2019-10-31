package com.kearny.sqldatadumper.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import lombok.Data;
import lombok.experimental.SuperBuilder;

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

    public String getValueToString(final int rowIndex, final int ordinal) {

        final String value = getValue(rowIndex, ordinal);
        if (value == null || value.equalsIgnoreCase("NULL")) {
            return "NULL";
        }

        final var type = columns.get(ordinal - 1).getType();

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

    public String getValue(final int rowIndex, final int ordinal) {

        final var values = rows.get(rowIndex);
        return values[ordinal - 1];
    }

    public List<String> getRowValuesToString(final int rowIndex) {

        final var rowValuesToString = new ArrayList<String>();

        for (int i = 1; i <= rows.get(rowIndex).length; i++) {
            rowValuesToString.add(getValueToString(rowIndex, i));
        }

        return rowValuesToString;
    }
}
