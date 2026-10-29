package br.com.eventhub.dao;

import br.com.eventhub.model.Categoria;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CategoriaDao {

    public void insert(Categoria categoria) {
        String SQL = "INSERT INTO CATEGORIA (NOME) VALUES (?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, categoria.getNome());
            preparedStatement.execute();
            System.out.println("success in insert categoria");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public List<Categoria> findAll() {
        String SQL = "SELECT * FROM CATEGORIA ORDER BY NOME";
        List<Categoria> categorias = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                categorias.add(mapear(resultSet));
            }
            System.out.println("success in find all categorias");
            connection.close();
            return categorias;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public Categoria findById(int id) {
        String SQL = "SELECT * FROM CATEGORIA WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            Categoria categoria = null;
            if (resultSet.next()) {
                categoria = mapear(resultSet);
            }
            System.out.println("success in find categoria by id");
            connection.close();
            return categoria;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return null;
        }
    }

    public Categoria findByNome(String nome) {
        String SQL = "SELECT * FROM CATEGORIA WHERE UPPER(NOME) = UPPER(?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, nome);
            ResultSet resultSet = preparedStatement.executeQuery();
            Categoria categoria = null;
            if (resultSet.next()) {
                categoria = mapear(resultSet);
            }
            System.out.println("success in find categoria by nome");
            connection.close();
            return categoria;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return null;
        }
    }

    public void update(Categoria categoria) {
        String SQL = "UPDATE CATEGORIA SET NOME = ? WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, categoria.getNome());
            preparedStatement.setInt(2, categoria.getId());
            preparedStatement.execute();
            System.out.println("success in update categoria");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteById(int id) {
        String SQL = "DELETE FROM CATEGORIA WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            preparedStatement.execute();
            System.out.println("success in delete categoria with id: " + id);
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    private Categoria mapear(ResultSet resultSet) throws SQLException {
        Categoria categoria = new Categoria();
        categoria.setId(resultSet.getInt("ID"));
        categoria.setNome(resultSet.getString("NOME"));
        return categoria;
    }
}