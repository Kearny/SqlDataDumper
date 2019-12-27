package com.kearny.sqldatadumper.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

import lombok.Data;
import lombok.experimental.SuperBuilder;
import lombok.val;

@Data
@SuperBuilder
public class Table {

    @NonNull
    private String schemaName;

    @NonNull
    private String name;

    private List<Column> columns;

    private HashMap<Integer, String[]> rows;

    private String select;

    private String insert;

    @Nullable
    private List<Table> foreignTables;

    public String getValueToString(final int rowIndex, final String columnName) {

        final var foundColumnOptional = columns.stream()
                                               .filter(column -> Objects.equals(column.getName(), columnName))
                                               .findFirst();

        return foundColumnOptional.map(column -> getValueToString(rowIndex, column.getOrdinal()))
                                  .orElse(null);
    }

    public String getValueToString(final int rowIndex, final int ordinal) {

        val value = getValue(rowIndex, ordinal);
        if (value == null || value.equalsIgnoreCase("NULL")) {
            return "NULL";
        }

        val type = columns.get(ordinal - 1).getType();

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

        val values = rows.get(rowIndex);

        return values[ordinal - 1];
    }

    public List<String> getRowValuesToString(final int rowIndex) {

        val rowValuesToString = new ArrayList<String>();

        for (int i = 1; i <= rows.get(rowIndex).length; i++) {
            rowValuesToString.add(getValueToString(rowIndex, i));
        }

        return rowValuesToString;
    }
}

