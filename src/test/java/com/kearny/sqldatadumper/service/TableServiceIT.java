package com.kearny.sqldatadumper.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.kearny.sqldatadumper.domain.Column;
import com.kearny.sqldatadumper.domain.Table;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
class TableServiceIT {

    private final Column idColumn = Column.builder()
                                          .ordinal(1)
                                          .name("id")
                                          .type("bigint")
                                          .build();
    private final Column codeMoisColumn = Column.builder()
                                                .ordinal(2)
                                                .name("code_mois")
                                                .type("character")
                                                .build();
    private final Column idEvtColumn = Column.builder()
                                             .ordinal(3)
                                             .name("id_evt")
                                             .type("character")
                                             .build();
    private final Column idPayplanColumn = Column.builder()
                                                 .ordinal(4)
                                                 .name("id_payplan")
                                                 .type("integer")
                                                 .build();
    private Table table;

    @Autowired
    private TableService tableService;

    @BeforeEach
    void setUp() {

        final var columns = new ArrayList<Column>(21);
        columns.add(idColumn);
        columns.add(codeMoisColumn);
        columns.add(idEvtColumn);
        columns.add(idPayplanColumn);

        final var rows = new HashMap<Integer, String[]>();

        final var firstRowValues = new String[columns.size()];
        firstRowValues[0] = "143430";
        firstRowValues[1] = "201906";
        firstRowValues[2] = "15090963-41d9-47cc-8be3-6300591b2d82";
        firstRowValues[3] = "198";
        rows.put(0, firstRowValues);

        final var secondRowValues = new String[columns.size()];
        firstRowValues[0] = "695816";
        firstRowValues[1] = "201906";
        firstRowValues[2] = "1ee5dfac-83f8-4a5d-b2e9-2435c9462799";
        firstRowValues[3] = "198";
        rows.put(1, secondRowValues);

        table = Table.builder()
                     .schemaName("valo_fixe")
                     .name("valorisation")
                     .columns(columns)
                     .rows(rows)
                     .select("SELECT * FROM valo_fixe.valorisation WHERE id = 143430;")
                     .build();
    }

       @Test
       void hydrateTable()
               throws SQLException, IOException {

           // Given
           var table = Table.builder()
                        .schemaName("valo_fixe")
                        .name("valorisation")
                        .select("SELECT * FROM valo_fixe.valorisation WHERE id = 143430;")
                        .build();

           // When
           tableService.hydrateTable(table);

           // Then
       }

    @Test
    void testBuildSelect() {

        // Given

        // When
        tableService.buildSelect(table);

        // Then
        assertThat(table.getSelect()).isEqualTo("SELECT * FROM valo_fixe.valorisation WHERE id = 695816;");
    }

    @Test
    void testFindColumnsProperties()
            throws SQLException {

        // Given
        table.setColumns(null);

        // When
        tableService.findColumnsProperties(table);

        // Then
        final var columns = table.getColumns();
        assertThat(columns).isNotEmpty();
        assertThat(columns.size()).isEqualTo(21);
        assertThat(columns.get(0)).isEqualTo(idColumn);
        assertThat(columns.get(1)).isEqualTo(codeMoisColumn);
        assertThat(columns.get(2)).isEqualTo(idEvtColumn);
        assertThat(columns.get(3)).isEqualTo(idPayplanColumn);
    }

    @Test
    void testFindAllRowsData()
            throws SQLException {

        // Given
        table.setRows(null);

        // When
        tableService.findAllRowsData(table);

        // Then
        assertThat(table.getRows()).isNotEmpty();
        assertThat(table.getRows().size()).isEqualTo(1);
        assertThat(table.getValue(0, 1)).isEqualTo("143430");
    }

    @Test
    void testBuildInsertBaseTable() {

        // Given
        table.setInsert(null);
        final var firstRow = table.getRows().get(0);
        final var rows = new HashMap<Integer, String[]>();
        rows.put(0,firstRow);
        table.setRows(rows);

        // When
        tableService.buildInsert(table);

        // Then
        assertThat(table.getInsert()).isNotNull();
        assertThat(table.getInsert()).isEqualTo("INSERT INTO valo_fixe.valorisation (id, code_mois, id_evt, id_payplan) VALUES (695816, '201906', '1ee5dfac-83f8-4a5d-b2e9-2435c9462799', 198);");
    }
}
