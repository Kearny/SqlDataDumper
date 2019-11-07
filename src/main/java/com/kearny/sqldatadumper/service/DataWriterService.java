package com.kearny.sqldatadumper.service;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;

import org.springframework.stereotype.Service;

import com.kearny.sqldatadumper.domain.Table;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DataWriterService {

    private BufferedWriter writer;

    public void writeTableData(final Table table) {

        try (var bufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("export.sql"), StandardCharsets.UTF_8))) {
            this.writer = bufferedWriter;
            writer.write("-- Generated File --");
            writeData(table);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeData(final Table table) {

        if (table.getForeignTables() != null && !table.getForeignTables().isEmpty()) {
            table.getForeignTables().forEach(this::writeData);
        }

        if (table.getInsert() != null) {
            try {
                writer.newLine();
                writer.append(table.getInsert());
            } catch (final IOException e) {
                e.printStackTrace();
            }
        }
    }
}
