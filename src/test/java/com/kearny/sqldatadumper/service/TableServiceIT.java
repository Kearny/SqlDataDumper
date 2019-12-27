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
import com.kearny.sqldatadumper.domain.ForeignTable;
import com.kearny.sqldatadumper.domain.Table;

import lombok.val;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
class TableServiceIT {

    private static final String FIRST_ROW_ID = "695815";
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

    @Autowired
    private DataWriterService dataWriterService;

    @BeforeEach
    void setUp() {

        val columns = new ArrayList<Column>(21);
        columns.add(idColumn);
        columns.add(codeMoisColumn);
        columns.add(idEvtColumn);
        columns.add(idPayplanColumn);

        val rows = new HashMap<Integer, String[]>();

        val firstRowValues = new String[columns.size()];
        firstRowValues[0] = FIRST_ROW_ID;
        firstRowValues[1] = "201906";
        firstRowValues[2] = "15090963-41d9-47cc-8be3-6300591b2d82";
        firstRowValues[3] = "198";
        rows.put(0, firstRowValues);

        table = Table.builder()
                     .schemaName("valo_fixe")
                     .name("valorisation")
                     .columns(columns)
                     .rows(rows)
                     .select(String.format("SELECT * FROM valo_fixe.valorisation WHERE id = %s;", FIRST_ROW_ID))
                     .build();
    }

    @Test
    void hydrateTable()
            throws SQLException, IOException {

        // Given
        val table = Table.builder()
                         .schemaName("valo_fixe")
                         .name("valorisation")
                         .select(String.format("SELECT * FROM valo_fixe.valorisation WHERE id = %s;", FIRST_ROW_ID))
                         .build();

        // When
        tableService.hydrateTable(table);
        dataWriterService.writeTableData(table);

        // Then
    }

    @Test
    void testFindColumnsProperties()
            throws SQLException {

        // Given
        table.setColumns(null);

        // When
        tableService.findColumnsProperties(table);

        // Then
        val columns = table.getColumns();
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
        assertThat(table.getValue(0, 1)).isEqualTo(FIRST_ROW_ID);
    }

    @Test
    void testFindForeignTables()
            throws SQLException {

        // Given

        // When
        tableService.findForeignTables(table);

        // Then
        val foreignTables = table.getForeignTables();
        assertThat(foreignTables).isNotNull();
        assertThat(foreignTables.size()).isEqualTo(14);
    }

    @Test
    void testBuildForeignTableFromDefinition() {

        // Given
        val expectedTable = ForeignTable.builder()
                                        .name("partenaire")
                                        .schemaName("valo_common")
                                        .linkParentColumn("code_partenaire")
                                        .linkChildrenColumn("code")
                                        .build();
        val definition = "FOREIGN KEY (code_partenaire) REFERENCES valo_common.partenaire(code) MATCH FULL";

        // When
        val foreignTableFromDef = tableService.buildForeignTableFromDefinition(definition);

        // Then
        assertThat(foreignTableFromDef).isNotNull();
        assertThat(foreignTableFromDef).isEqualTo(expectedTable);
    }

    @Test
    void testBuildInsertBaseTable() {

        // Given

        // When
        tableService.buildInsert(table);

        // Then
        assertThat(table.getInsert()).isNotNull();
        assertThat(table.getInsert()).isEqualTo(
                "INSERT INTO valo_fixe.valorisation (id, code_mois, id_evt, id_payplan) VALUES (" + FIRST_ROW_ID
                        + ", '201906', '15090963-41d9-47cc-8be3-6300591b2d82', 198);");
    }
}
