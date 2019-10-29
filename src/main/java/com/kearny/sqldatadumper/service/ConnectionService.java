package com.kearny.sqldatadumper.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.stereotype.Service;

@Service
public class ConnectionService {

    private Connection connection;

    public ResultSet runSqlQuery(String query)
            throws SQLException {

        return getConnectionInstance().createStatement().executeQuery(query);
    }

    private Connection getConnectionInstance() {

        if (connection == null) {
            var url = "jdbc:postgresql://db04-mly-pp.phys.pack:1520/valorisation";

            try {
                this.connection = DriverManager.getConnection(url, "melody_adm", "6epi9vB2lLQTr0F");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return connection;
    }
}
