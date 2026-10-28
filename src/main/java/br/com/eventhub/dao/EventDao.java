package br.com.eventhub.dao;

import br.com.eventhub.model.Event;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class EventDao {

    public void createEvent(Event evento) {
        String SQL = "INSERT INTO EVENTO (NOME) VALUES (?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, evento.getNome());
            preparedStatement.execute();
            System.out.println("success in insert event");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public List<Event> findAllEvents() {
        String SQL = "SELECT * FROM EVENTO";
        List<Event> eventos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Event evento = new Event();
                evento.setId(resultSet.getInt("ID"));
                evento.setNome(resultSet.getString("NOME"));
                eventos.add(evento);
            }
            System.out.println("success in find all events");
            connection.close();
            return eventos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }
}