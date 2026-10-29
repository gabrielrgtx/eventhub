package br.com.eventhub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FavoritoDao {

    public void insertFavorito(int usuarioId, int eventoId) {
        String SQL = "INSERT INTO FAVORITO (USUARIO_ID, EVENTO_ID) VALUES (?, ?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            preparedStatement.execute();
            System.out.println("success in insert favorito");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteFavorito(int usuarioId, int eventoId) {
        String SQL = "DELETE FROM FAVORITO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            preparedStatement.execute();
            System.out.println("success in delete favorito");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public boolean existsFavorito(int usuarioId, int eventoId) {
        String SQL = "SELECT COUNT(*) FROM FAVORITO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            boolean existe = false;
            if (resultSet.next()) {
                existe = resultSet.getInt(1) > 0;
            }
            System.out.println("success in check favorito");
            connection.close();
            return existe;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return false;
        }
    }
}
