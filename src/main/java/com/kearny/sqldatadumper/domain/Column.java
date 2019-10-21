package com.kearny.sqldatadumper.domain;

import jdk.jshell.spi.ExecutionControl;
import lombok.Data;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@Data
public class Column {

    private String name;
    private String value;
    private String type;

    public String getValueToString() throws ExecutionControl.NotImplementedException {
        if (value == null) {
            return "NULL";
        }

        switch (type) {
            case "bpchar":
            case "varchar":
            case "text":
                return String.format("'%s'", value);
            case "bool":
                if (value.equalsIgnoreCase("T")) {
                    return "TRUE";
                } else {
                    return "FALSE";
                }
            case "timestamp":
                throw new ExecutionControl.NotImplementedException("TODO");
        }

        return value;
    }
}
