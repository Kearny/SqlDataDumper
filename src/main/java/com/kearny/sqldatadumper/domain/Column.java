package com.kearny.sqldatadumper.domain;

import lombok.Data;
import lombok.NonNull;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@Data
public class Column {

    private Integer ordinal;

    @NonNull
    private String name;

    @NonNull
    private String type;

    public void setValue(final String string) {

    }
}
