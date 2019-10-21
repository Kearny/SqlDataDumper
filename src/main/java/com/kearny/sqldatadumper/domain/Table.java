package com.kearny.sqldatadumper.domain;

import lombok.Data;
import lombok.experimental.SuperBuilder;

import java.util.List;

@SuperBuilder
@Data
public class Table {

    private String schemaName;
    private String name;
    private Column primaryKeyColumn;
    private String select;
    private String insert;
    private List<Column> columns;
    private List<Table> foreignTables;
}
