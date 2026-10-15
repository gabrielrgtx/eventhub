package br.com.eventhub.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    private static final String URL = "jdbc:h2:~/test";
    private static final String USUARIO = "sa";
    private static final String SENHA = "sa";

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USUARIO, SENHA);
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao conectar no banco", e);
        }
    }
}