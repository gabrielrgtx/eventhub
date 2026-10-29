package br.com.eventhub.dao;

import br.com.eventhub.model.Avaliacao;
import br.com.eventhub.model.Endereco;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class AvaliacaoDao {

    public void insert(Avaliacao avaliacao) {
        String SQL = "INSERT INTO AVALIACAO (USUARIO_ID, EVENTO_ID, NOTA, COMENTARIO, DATA_AVALIACAO) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, avaliacao.getUsuario().getId());
            preparedStatement.setInt(2, avaliacao.getEvento().getId());
            preparedStatement.setInt(3, avaliacao.getNota());
            preparedStatement.setString(4, avaliacao.getComentario());
            preparedStatement.execute();
            System.out.println("success in insert avaliacao");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public List<Avaliacao> findByEvento(int eventoId) {
        String SQL = "SELECT A.ID, A.NOTA, A.COMENTARIO, A.DATA_AVALIACAO, U.ID AS USUARIO_ID, U.NOME, U.USUARIO, U.FOTO "
                + "FROM AVALIACAO A JOIN USUARIO U ON U.ID = A.USUARIO_ID WHERE A.EVENTO_ID = ?";
        List<Avaliacao> avaliacoes = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Avaliacao avaliacao = new Avaliacao();
                avaliacao.setId(resultSet.getInt("ID"));
                avaliacao.setNota(resultSet.getInt("NOTA"));
                avaliacao.setComentario(resultSet.getString("COMENTARIO"));
                avaliacao.setData(resultSet.getTimestamp("DATA_AVALIACAO").toLocalDateTime());
                User usuario = new User();
                usuario.setId(resultSet.getInt("USUARIO_ID"));
                usuario.setNome(resultSet.getString("NOME"));
                usuario.setUsuario(resultSet.getString("USUARIO"));
                usuario.setFoto(resultSet.getString("FOTO"));
                avaliacao.setUsuario(usuario);
                avaliacoes.add(avaliacao);
            }
            System.out.println("success in find avaliacoes by evento");
            connection.close();
            return avaliacoes;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public List<Avaliacao> findByUsuario(int usuarioId) {
        String SQL = "SELECT A.ID, A.NOTA, A.COMENTARIO, A.DATA_AVALIACAO, E.ID AS EVENTO_ID, E.NOME, E.DATA_EVENTO, E.CIDADE "
                + "FROM AVALIACAO A JOIN EVENTO E ON E.ID = A.EVENTO_ID WHERE A.USUARIO_ID = ? ORDER BY A.DATA_AVALIACAO DESC";
        List<Avaliacao> avaliacoes = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Avaliacao avaliacao = new Avaliacao();
                avaliacao.setId(resultSet.getInt("ID"));
                avaliacao.setNota(resultSet.getInt("NOTA"));
                avaliacao.setComentario(resultSet.getString("COMENTARIO"));
                avaliacao.setData(resultSet.getTimestamp("DATA_AVALIACAO").toLocalDateTime());
                Event evento = new Event();
                evento.setId(resultSet.getInt("EVENTO_ID"));
                evento.setNome(resultSet.getString("NOME"));
                evento.setData(resultSet.getDate("DATA_EVENTO").toLocalDate());
                Endereco endereco = new Endereco();
                endereco.setCidade(resultSet.getString("CIDADE"));
                evento.setEndereco(endereco);
                avaliacao.setEvento(evento);
                avaliacoes.add(avaliacao);
            }
            System.out.println("success in find avaliacoes by usuario");
            connection.close();
            return avaliacoes;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public void update(Avaliacao avaliacao) {
        String SQL = "UPDATE AVALIACAO SET NOTA = ?, COMENTARIO = ? WHERE ID = ? AND USUARIO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, avaliacao.getNota());
            preparedStatement.setString(2, avaliacao.getComentario());
            preparedStatement.setInt(3, avaliacao.getId());
            preparedStatement.setInt(4, avaliacao.getUsuario().getId());
            preparedStatement.execute();
            System.out.println("success in update avaliacao");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteById(int id, int usuarioId) {
        String SQL = "DELETE FROM AVALIACAO WHERE ID = ? AND USUARIO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            preparedStatement.setInt(2, usuarioId);
            preparedStatement.execute();
            System.out.println("success in delete avaliacao with id: " + id);
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public boolean existsByUsuarioEvento(int usuarioId, int eventoId) {
        String SQL = "SELECT COUNT(*) FROM AVALIACAO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
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
            System.out.println("success in check avaliacao");
            connection.close();
            return existe;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return false;
        }
    }
}