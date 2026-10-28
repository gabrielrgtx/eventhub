package br.com.eventhub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InscricaoDao {

    public void insertInscricao(int usuarioId, int eventoId) {
        String SQL = "INSERT INTO INSCRICAO (USUARIO_ID, EVENTO_ID, DATA_INSCRICAO) VALUES (?, ?, CURRENT_TIMESTAMP)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            preparedStatement.execute();
            System.out.println("success in insert inscricao");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteInscricao(int usuarioId, int eventoId) {
        String SQL = "DELETE FROM INSCRICAO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            preparedStatement.execute();
            System.out.println("success in delete inscricao");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public boolean existsInscricao(int usuarioId, int eventoId) {
        String SQL = "SELECT COUNT(*) FROM INSCRICAO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
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
            System.out.println("success in check inscricao");
            connection.close();
            return existe;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return false;
        }
    }

    public int countByEvento(int eventoId) {
        String SQL = "SELECT COUNT(*) FROM INSCRICAO WHERE EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            int total = 0;
            if (resultSet.next()) {
                total = resultSet.getInt(1);
            }
            System.out.println("success in count inscricoes");
            connection.close();
            return total;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return 0;
        }
    }
}