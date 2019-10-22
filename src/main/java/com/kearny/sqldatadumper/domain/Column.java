package com.kearny.sqldatadumper.domain;

import jdk.jshell.spi.ExecutionControl;
import lombok.Data;
import lombok.NonNull;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@Data
public class Column {

    @NonNull
    private String name;

    private String value;

    @NonNull
    private String type;

    public String getValueToString() throws ExecutionControl.NotImplementedException {
        if (value == null || value.equalsIgnoreCase("NULL")) {
            return "NULL";
        }

        switch (type) {
            case "bpchar":
            case "varchar":
            case "text":
            case "timestamp":
                return String.format("'%s'", value);
            case "bool":
                if (value.equalsIgnoreCase("T")) {
                    return "TRUE";
                } else {
                    return "FALSE";
                }
            default:
                return value;
        }
    }
}
