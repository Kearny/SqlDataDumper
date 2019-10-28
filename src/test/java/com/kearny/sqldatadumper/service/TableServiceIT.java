package com.kearny.sqldatadumper.service;

import com.kearny.sqldatadumper.domain.Column;
import com.kearny.sqldatadumper.domain.Table;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

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
        firstRowValues[0] = "695815";
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
                .select("SELECT * FROM valo_fixe.valorisation WHERE id = 10234;")
                .build();
    }

//    @Test
//    void hydrateTable() throws SQLException, ExecutionControl.NotImplementedException, IOException {
//
//        // Given
//
//        // When
//        tableService.hydrateTable(table);
//
//        // Then
//        assertThat(table.getSelect()).isEqualTo("SELECT * FROM valo_fixe.valorisation WHERE id = 695815;");
//        assertThat(table.getRows().get(0).size()).isEqualTo(21);
//        assertThat(table.getRows().get(0).get(0)).isEqualTo(Column.builder()
//                .name("id")
//                .type("bigint")
//                .build());
//        assertThat(table.getInsert()).isEqualTo("INSERT INTO valo_fixe.valorisation (id, code_mois, id_evt, id_payplan, code_type_rem, dans_zone_de_vente, raccorde, ordre_analytique, montant, code_ref_nature_comptable, id_prime_volu, id_evt_option, id_echeancier_detail, statut, code_point_paiement, code_partenaire, code_tva_facture, code_tva_provision, date_creation, id_ecriture_comptable, id_evt_raccordement) VALUES (695815, '201906', '15090963-41d9-47cc-8be3-6300591b2d82', 198, 'PRIME_VOLUMIQUE', TRUE, TRUE, 'O12E8SFHV001', 19.4, '62242800', NULL, NULL, NULL, 'PROVISIONNEE', '0001031097', '0001031097', 'WC', 'XD', '2019-07-11 14:27:58.75', 305, NULL);");
//        assertThat(table.getValueToString(0, 1)).isEqualTo("695815");
//    }

    @Test
    void testBuildSelect() {

        // Given

        // When
        tableService.buildSelect(table);

        // Then
        assertThat(table.getSelect()).isEqualTo("SELECT * FROM valo_fixe.valorisation WHERE id = 695816;");
    }

    @Test
    void testFindColumnsProperties() throws SQLException {

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
    void testFindAllRowsData() throws SQLException {

        // Given
        table.setRows(null);

        // When
        tableService.findAllRowsData(table);

        // Then
        assertThat(table.getRows().size()).isEqualTo(1);
    }
}