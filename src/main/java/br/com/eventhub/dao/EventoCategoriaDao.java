package br.com.eventhub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class EventoCategoriaDao {

    public void insertCategoria(int eventoId, int categoriaId) {
        String SQL = "INSERT INTO EVENTO_CATEGORIA (EVENTO_ID, CATEGORIA_ID) VALUES (?, ?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            preparedStatement.setInt(2, categoriaId);
            preparedStatement.execute();
            System.out.println("success in insert evento categoria");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteByEvento(int eventoId) {
        String SQL = "DELETE FROM EVENTO_CATEGORIA WHERE EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            preparedStatement.execute();
            System.out.println("success in delete categorias by evento");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public List<Integer> findCategoriaIdsByEvento(int eventoId) {
        String SQL = "SELECT CATEGORIA_ID FROM EVENTO_CATEGORIA WHERE EVENTO_ID = ?";
        List<Integer> categoriaIds = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                categoriaIds.add(resultSet.getInt("CATEGORIA_ID"));
            }
            System.out.println("success in find categoria ids by evento");
            connection.close();
            return categoriaIds;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }
}
