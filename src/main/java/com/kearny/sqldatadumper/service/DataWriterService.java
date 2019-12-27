package com.kearny.sqldatadumper.service;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kearny.sqldatadumper.domain.Table;

import lombok.extern.slf4j.Slf4j;
import lombok.val;

@Slf4j
@Service
public class DataWriterService {

    private BufferedWriter writer;

    public void writeTableData(final Table table) {

        try (val bufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("export.sql"), StandardCharsets.UTF_8))) {
            this.writer = bufferedWriter;
            writer.write("-- Generated File --");
            val tablesInsertsInOrder = getTablesInsertsInOrder(table);
            writeData(tablesInsertsInOrder);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeData(final LinkedList<String> inserts) {

        try {
            for (val insert : inserts) {
                writer.newLine();
                writer.append(insert);
            }
        } catch (final IOException e) {
            e.printStackTrace();
        }
    }

    LinkedList<String> getTablesInsertsInOrder(final Table rootTable) {

        val inserts = getInserts(rootTable);

        val reverseInsert = new LinkedList<String>();
        for (int i = inserts.size() - 1; i >= 0; i--) {
            reverseInsert.add(inserts.get(i));
        }

        return reverseInsert;
    }

    private LinkedList<String> getInserts(final Table rootTable) {

        if (rootTable == null) {
            return new LinkedList<>();
        }

        val rawTablesInOrder = new LinkedList<List<String>>();

        final Queue<Table> tableQueue = new LinkedList<>();
        tableQueue.offer(rootTable);

        // Traverse the N-ary Tree by level
        while (!tableQueue.isEmpty()) {
            val size = tableQueue.size();
            final List<String> inserts = new LinkedList<>();

            for (int i = 0; i < size; i++) {
                val table = tableQueue.poll();
                if (table != null) {

                    inserts.add(table.getInsert());

                    if (table.getForeignTables() != null) {
                        table.getForeignTables().forEach(tableQueue::offer);
                    }
                }
            }

            rawTablesInOrder.add(inserts);
        }

        return rawTablesInOrder.stream()
                               .flatMap(List::stream)
                               .collect(Collectors.toCollection(LinkedList::new));
    }
}
