package com.kearny.sqldatadumper.service;

import com.kearny.sqldatadumper.domain.Column;
import com.kearny.sqldatadumper.domain.Table;
import jdk.jshell.spi.ExecutionControl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.sql.SQLException;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class TableServiceIT {

    private Table table;

    @Autowired
    private TableService tableService;

    @BeforeEach
    void setUp() {
        table = Table.builder()
                .schemaName("valo_fixe")
                .name("valorisation")
                .primaryKeyColumn(Column.builder()
                        .name("id")
                        .value("695815")
                        .type("bigint")
                        .build())
                .build();
    }

    @Test
    void hydrateTable() throws SQLException, ExecutionControl.NotImplementedException {

        // Given

        // When
        tableService.hydrateTable(table);

        // Then
        assertThat(table.getSelect()).isEqualTo("SELECT * FROM valo_fixe.valorisation WHERE id = '695815';");
        assertThat(table.getColumns().size()).isEqualTo(21);
        assertThat(table.getColumns().get(0)).isEqualTo(Column.builder()
                .name("id")
                .value("695815")
                .type("int8")
                .build());
        assertThat(table.getInsert()).isEqualTo("INSERT INTO valo_fixe.valorisation (id, code_mois, id_evt, id_payplan, code_type_rem, dans_zone_de_vente, raccorde, ordre_analytique, montant, code_ref_nature_comptable, id_prime_volu, id_evt_option, id_echeancier_detail, statut, code_point_paiement, code_partenaire, code_tva_facture, code_tva_provision, date_creation, id_ecriture_comptable, id_evt_raccordement) VALUES (695815, 201906, 15090963-41d9-47cc-8be3-6300591b2d82, 198, PRIME_VOLUMIQUE, t, t, O12E8SFHV001, 19.4, 62242800, null, null, null, PROVISIONNEE, 0001031097, 0001031097, WC, XD, 2019-07-11 14:27:58.75, 305, null);");
        assertThat(table.getForeignTables().size()).isEqualTo(14);
    }
}