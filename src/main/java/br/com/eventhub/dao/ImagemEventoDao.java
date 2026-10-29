package br.com.eventhub.dao;

import br.com.eventhub.model.ImagemEvento;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ImagemEventoDao {

    public void insertImagem(int eventoId, String caminho) {
        String SQL = "INSERT INTO IMAGEM_EVENTO (EVENTO_ID, CAMINHO) VALUES (?, ?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            preparedStatement.setString(2, caminho);
            preparedStatement.execute();
            System.out.println("success in insert imagem");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteByEvento(int eventoId) {
        String SQL = "DELETE FROM IMAGEM_EVENTO WHERE EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            preparedStatement.execute();
            System.out.println("success in delete imagens by evento");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public List<ImagemEvento> findByEvento(int eventoId) {
        String SQL = "SELECT * FROM IMAGEM_EVENTO WHERE EVENTO_ID = ?";
        List<ImagemEvento> imagens = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                ImagemEvento imagem = new ImagemEvento();
                imagem.setId(resultSet.getInt("ID"));
                imagem.setCaminho(resultSet.getString("CAMINHO"));
                imagens.add(imagem);
            }
            System.out.println("success in find imagens by evento");
            connection.close();
            return imagens;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }
}
