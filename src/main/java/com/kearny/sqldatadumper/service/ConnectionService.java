package com.kearny.sqldatadumper.service;

import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

@Service
public class ConnectionService {

    private Connection connection;

    public ResultSet runSqlQuery(String query) throws SQLException {
        return getConnectionInstance().createStatement().executeQuery(query);
    }

    private Connection getConnectionInstance() {

        if (connection == null) {
            var url = "jdbc:postgresql://localhost:5432/melody";

            try {
                this.connection = DriverManager.getConnection(url, "postgres", "root");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return connection;
    }
}
