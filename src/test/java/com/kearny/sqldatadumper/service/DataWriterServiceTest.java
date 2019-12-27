package com.kearny.sqldatadumper.service;

import java.util.LinkedList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;

import com.kearny.sqldatadumper.domain.Table;

import lombok.val;

import static org.assertj.core.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
public class DataWriterServiceTest {

    @InjectMocks
    DataWriterService dataWriterService;

    @Test
    void testTreeWriterThreeLevels() {

        // Given
        val table = buildTableTree();

        // When
        val insert = dataWriterService.getTablesInsertsInOrder(table);

        // Then
        assertThat(insert).containsExactly(
                "INSERT INTO schema.H...",
                "INSERT INTO schema.G...",
                "INSERT INTO schema.F...",
                "INSERT INTO schema.E...",
                "INSERT INTO schema.D...",
                "INSERT INTO schema.C...",
                "INSERT INTO schema.B...",
                "INSERT INTO schema.A..."
        );
    }

    private Table buildTableTree() {

        val tableG = Table.builder()
                          .name("G")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.G...")
                          .build();

        val tableH = Table.builder()
                          .name("H")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.H...")
                          .build();

        val tableE = Table.builder()
                          .name("E")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.E...")
                          .build();

        val tableF = Table.builder()
                          .name("F")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.F...")
                          .build();

        val tableB = Table.builder()
                          .name("B")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.B...")
                          .build();

        final List<Table> CForeignTables = new LinkedList<>();
        CForeignTables.add(tableE);
        CForeignTables.add(tableF);
        val tableC = Table.builder()
                          .name("C")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.C...")
                          .foreignTables(CForeignTables)
                          .build();

        final List<Table> DForeignTables = new LinkedList<>();
        DForeignTables.add(tableG);
        DForeignTables.add(tableH);
        val tableD = Table.builder()
                          .name("D")
                          .schemaName("schema")
                          .insert("INSERT INTO schema.D...")
                          .foreignTables(DForeignTables)
                          .build();

        final List<Table> AforeignTables = new LinkedList<>();
        AforeignTables.add(tableB);
        AforeignTables.add(tableC);
        AforeignTables.add(tableD);
        return Table.builder()
                    .name("A")
                    .schemaName("schema")
                    .select("SELECT * FROM schema.A WHERE id = 1;")
                    .insert("INSERT INTO schema.A...")
                    .foreignTables(AforeignTables)
                    .build();
    }
}