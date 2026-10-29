package br.com.eventhub.dao;

import br.com.eventhub.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {

    private boolean erroLogin;

    public boolean isErroLogin() {
        return erroLogin;
    }

    public int insert(User usuario) {
        String SQL = "INSERT INTO USUARIO (NOME, USUARIO, EMAIL, SENHA, FOTO) VALUES (?, ?, ?, ?, ?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, usuario.getNome());
            preparedStatement.setString(2, usuario.getUsuario());
            preparedStatement.setString(3, usuario.getEmail());
            preparedStatement.setString(4, usuario.getSenha());
            preparedStatement.setString(5, usuario.getFoto());
            preparedStatement.execute();
            System.out.println("success in insert user");
            connection.close();
            return 1;
        } catch (SQLException e) {
            System.out.println("fail in database connection");
            return "23505".equals(e.getSQLState()) ? 2 : 0;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return 0;
        }
    }

    public User findById(int id) {
        String SQL = "SELECT * FROM USUARIO WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            User usuario = null;
            if (resultSet.next()) {
                usuario = mapear(resultSet);
            }
            System.out.println("success in find user by id");
            connection.close();
            return usuario;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return null;
        }
    }

    public User findByLogin(String identificador, String senha) {
        erroLogin = false;
        String SQL = "SELECT * FROM USUARIO WHERE (USUARIO = ? OR EMAIL = ?) AND SENHA = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, identificador);
            preparedStatement.setString(2, identificador);
            preparedStatement.setString(3, senha);
            ResultSet resultSet = preparedStatement.executeQuery();
            User usuario = null;
            if (resultSet.next()) {
                usuario = mapear(resultSet);
            }
            System.out.println("success in find user by login");
            connection.close();
            return usuario;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            erroLogin = true;
            return null;
        }
    }

    public int update(User usuario) {
        String SQL = "UPDATE USUARIO SET NOME = ?, USUARIO = ?, EMAIL = ?, FOTO = ? WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, usuario.getNome());
            preparedStatement.setString(2, usuario.getUsuario());
            preparedStatement.setString(3, usuario.getEmail());
            preparedStatement.setString(4, usuario.getFoto());
            preparedStatement.setInt(5, usuario.getId());
            int alterados = preparedStatement.executeUpdate();
            System.out.println("success in update user");
            connection.close();
            return alterados == 1 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println("fail in database connection");
            return "23505".equals(e.getSQLState()) ? 2 : 0;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return 0;
        }
    }

    public void deleteById(int id) {
        String SQL = "DELETE FROM USUARIO WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            preparedStatement.execute();
            System.out.println("success in delete user with id: " + id);
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    private User mapear(ResultSet resultSet) throws SQLException {
        User usuario = new User();
        usuario.setId(resultSet.getInt("ID"));
        usuario.setNome(resultSet.getString("NOME"));
        usuario.setUsuario(resultSet.getString("USUARIO"));
        usuario.setEmail(resultSet.getString("EMAIL"));
        usuario.setSenha(resultSet.getString("SENHA"));
        usuario.setFoto(resultSet.getString("FOTO"));
        return usuario;
    }
}
