package com.kearny.sqldatadumper.domain;

import java.util.ArrayList;
import java.util.HashMap;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import lombok.val;

import static org.assertj.core.api.Assertions.*;

class TableTest {

    private Table table;

    @BeforeEach
    void setUp() {

        val intColumn = Column.builder()
                              .ordinal(1)
                              .name("id")
                              .type("bigint")
                              .build();
        val stringColumn = Column.builder()
                                 .ordinal(2)
                                 .name("name")
                                 .type("character")
                                 .build();
        val booleanColumn = Column.builder()
                                  .ordinal(3)
                                  .name("isPublished")
                                  .type("boolean")
                                  .build();
        val columns = new ArrayList<Column>();
        columns.add(intColumn);
        columns.add(stringColumn);
        columns.add(booleanColumn);

        val rows = new HashMap<Integer, String[]>();

        val firstRowValues = new String[columns.size()];
        firstRowValues[0] = "10234";
        firstRowValues[1] = null;
        firstRowValues[2] = "T";
        rows.put(0, firstRowValues);

        val secondRowValues = new String[columns.size()];
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
        val value = table.getValue(0, 1);

        // Then
        assertThat(value).isEqualTo("10234");
    }

    @Test
    void testGetIntValueToString() {

        // Given

        // When
        val valueToString = table.getValueToString(0, 1);

        // Then
        assertThat(valueToString).isEqualTo("10234");
    }

    @Test
    void testGetStringValueToString() {

        // Given

        // When
        val valueToString = table.getValueToString(1, 2);

        // Then
        assertThat(valueToString).isEqualTo("'Ceci est une chaîne de caractères.'");
    }

    @Test
    void testFalseBooleanValueToString() {

        // Given

        // When
        val trueValueToString = table.getValueToString(0, 3);
        val falseValueToString = table.getValueToString(1, 3);

        // Then
        assertThat(trueValueToString).isEqualTo("TRUE");
        assertThat(falseValueToString).isEqualTo("FALSE");
    }

    @Test
    void testNullValueToString() {

        // Given

        // When
        val valueToString = table.getValueToString(0, 2);

        // Then
        assertThat(valueToString).isEqualTo("NULL");
    }
}
