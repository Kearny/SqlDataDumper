package com.kearny.sqldatadumper.domain;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

class TableTest {

    private Table table;

    @BeforeEach
    void setUp() {
        final var intColumn = Column.builder()
                .ordinal(1)
                .name("id")
                .type("bigint")
                .build();
        final var stringColumn = Column.builder()
                .ordinal(2)
                .name("name")
                .type("character")
                .build();
        final var booleanColumn = Column.builder()
                .ordinal(3)
                .name("isPublished")
                .type("boolean")
                .build();
        final var columns = new ArrayList<Column>();
        columns.add(intColumn);
        columns.add(stringColumn);
        columns.add(booleanColumn);

        final var rows = new HashMap<Integer, String[]>();

        final var firstRowValues = new String[columns.size()];
        firstRowValues[0] = "10234";
        firstRowValues[1] = null;
        firstRowValues[2] = "T";
        rows.put(0, firstRowValues);

        final var secondRowValues = new String[columns.size()];
        secondRowValues[0] = "56789";
        secondRowValues[1] = "Ceci est une chaîne de caractères.";
        secondRowValues[2] = "F";
        rows.put(1, secondRowValues);


        table = Table.builder()
                .schemaName("valo_fixe")
                .name("valorisation")
                .columns(columns)
                .rows(rows)
                .build();
    }

    @AfterEach
    void tearDown() {
    }

    @Test
    void testGetValue() {

        // Given

        // When
        final var value = table.getValue(0, 1);

        // Then
        assertThat(value).isEqualTo("10234");
    }

    @Test
    void testGetIntValueToString() {

        // Given

        // When
        final var valueToString = table.getValueToString(0, 1);

        // Then
        assertThat(valueToString).isEqualTo("10234");
    }

    @Test
    void testGetStringValueToString() {

        // Given

        // When
        final var valueToString = table.getValueToString(1, 2);

        // Then
        assertThat(valueToString).isEqualTo("'Ceci est une chaîne de caractères.'");
    }

    @Test
    void testFalseBooleanValueToString() {

        // Given

        // When
        final var trueValueToString = table.getValueToString(0,3);
        final var falseValueToString = table.getValueToString(1,3);

        // Then
        assertThat(trueValueToString).isEqualTo("TRUE");
        assertThat(falseValueToString).isEqualTo("FALSE");
    }

    @Test
    void testNullValueToString() {

        // Given

        // When
        final var valueToString = table.getValueToString(0,2);

        // Then
        assertThat(valueToString).isEqualTo("NULL");
    }
}