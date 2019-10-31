package com.kearny.sqldatadumper.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.SuperBuilder;

@EqualsAndHashCode(callSuper = true)
@SuperBuilder
@Data
public class ForeignTable extends Table {

    private String linkParentColumn;

    private String linkChildrenColumn;
}
