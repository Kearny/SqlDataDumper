package com.kearny.sqldatadumper.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.stereotype.Service;

@Service
public class ConnectionService {

    private Connection connection;

    public ResultSet runSqlQuery(final String query)
            throws SQLException {

        return getConnectionInstance().createStatement().executeQuery(query);
    }

    private Connection getConnectionInstance() {

        if (connection == null) {
            final var url = "jdbc:postgresql://localhost:5432/melody";

            try {
                connection = DriverManager.getConnection(url, "postgres", "root");
            } catch (final SQLException e) {
                e.printStackTrace();
            }
        }

        return connection;
    }
}
