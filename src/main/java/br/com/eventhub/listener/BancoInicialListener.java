package br.com.eventhub.listener;

import br.com.eventhub.dao.ConnectionFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebListener
public class BancoInicialListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent evento) {
        String SQL = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' AND TABLE_NAME = 'USUARIO'";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            ResultSet resultSet = preparedStatement.executeQuery();
            resultSet.next();
            if (resultSet.getInt(1) == 0) {
                connection.prepareStatement("RUNSCRIPT FROM 'classpath:/schema.sql' CHARSET 'UTF-8'").execute();
                connection.prepareStatement("RUNSCRIPT FROM 'classpath:/dados.sql' CHARSET 'UTF-8'").execute();
                System.out.println("success in create database with sample data");
            }
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in create database");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent evento) {
    }
}
