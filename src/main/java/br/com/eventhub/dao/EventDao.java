package br.com.eventhub.dao;

import br.com.eventhub.model.Endereco;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class EventDao {

    public int createEvent(Event evento) {
        String SQL = "INSERT INTO EVENTO (NOME, SOBRE, DATA_EVENTO, INICIO, FIM, VAGAS, PUBLICO, CANCELADO, CRIADOR_ID, RUA, NUMERO, BAIRRO, CIDADE, ESTADO, CEP) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, evento.getNome());
            preparedStatement.setString(2, evento.getSobre());
            preparedStatement.setDate(3, Date.valueOf(evento.getData()));
            preparedStatement.setTime(4, Time.valueOf(evento.getInicio()));
            preparedStatement.setTime(5, evento.getFim() == null ? null : Time.valueOf(evento.getFim()));
            preparedStatement.setInt(6, evento.getVagas());
            preparedStatement.setBoolean(7, evento.isPublico());
            preparedStatement.setBoolean(8, evento.isCancelado());
            preparedStatement.setInt(9, evento.getCriador().getId());
            preparedStatement.setString(10, evento.getEndereco().getRua());
            preparedStatement.setString(11, evento.getEndereco().getNumero());
            preparedStatement.setString(12, evento.getEndereco().getBairro());
            preparedStatement.setString(13, evento.getEndereco().getCidade());
            preparedStatement.setString(14, evento.getEndereco().getEstado());
            preparedStatement.setString(15, evento.getEndereco().getCep());
            preparedStatement.execute();
            ResultSet resultSet = preparedStatement.getGeneratedKeys();
            int id = 0;
            if (resultSet.next()) {
                id = resultSet.getInt(1);
            }
            System.out.println("success in insert event");
            connection.close();
            return id;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return 0;
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
                eventos.add(montarEvento(resultSet));
            }
            System.out.println("success in find all events");
            connection.close();
            return eventos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public Event findEventById(int id) {
        String SQL = "SELECT * FROM EVENTO WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            Event evento = null;
            if (resultSet.next()) {
                evento = montarEvento(resultSet);
            }
            System.out.println("success in find event by id");
            connection.close();
            return evento;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return null;
        }
    }

    public void updateEvent(Event evento) {
        String SQL = "UPDATE EVENTO SET NOME = ?, SOBRE = ?, DATA_EVENTO = ?, INICIO = ?, FIM = ?, VAGAS = ?, PUBLICO = ?, CANCELADO = ?, RUA = ?, NUMERO = ?, BAIRRO = ?, CIDADE = ?, ESTADO = ?, CEP = ? WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, evento.getNome());
            preparedStatement.setString(2, evento.getSobre());
            preparedStatement.setDate(3, Date.valueOf(evento.getData()));
            preparedStatement.setTime(4, Time.valueOf(evento.getInicio()));
            preparedStatement.setTime(5, evento.getFim() == null ? null : Time.valueOf(evento.getFim()));
            preparedStatement.setInt(6, evento.getVagas());
            preparedStatement.setBoolean(7, evento.isPublico());
            preparedStatement.setBoolean(8, evento.isCancelado());
            preparedStatement.setString(9, evento.getEndereco().getRua());
            preparedStatement.setString(10, evento.getEndereco().getNumero());
            preparedStatement.setString(11, evento.getEndereco().getBairro());
            preparedStatement.setString(12, evento.getEndereco().getCidade());
            preparedStatement.setString(13, evento.getEndereco().getEstado());
            preparedStatement.setString(14, evento.getEndereco().getCep());
            preparedStatement.setInt(15, evento.getId());
            preparedStatement.execute();
            System.out.println("success in update event");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void deleteEventById(String eventId) {
        String SQL = "DELETE FROM EVENTO WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, eventId);
            preparedStatement.execute();
            System.out.println("success on delete event with id: " + eventId);
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public void cancelEventById(int id) {
        String SQL = "UPDATE EVENTO SET CANCELADO = TRUE WHERE ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, id);
            preparedStatement.execute();
            System.out.println("success in cancel event");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public int countByCriador(int userId) {
        String SQL = "SELECT COUNT(*) FROM EVENTO WHERE CRIADOR_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, userId);
            ResultSet resultSet = preparedStatement.executeQuery();
            int total = 0;
            if (resultSet.next()) {
                total = resultSet.getInt(1);
            }
            System.out.println("success in count events by criador");
            connection.close();
            return total;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return 0;
        }
    }

    public List<Event> findByCriador(int userId) {
        String SQL = "SELECT * FROM EVENTO WHERE CRIADOR_ID = ?";
        List<Event> eventos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, userId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                eventos.add(montarEvento(resultSet));
            }
            System.out.println("success in find events by criador");
            connection.close();
            return eventos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public List<Event> findByInscrito(int usuarioId) {
        String SQL = "SELECT E.* FROM EVENTO E INNER JOIN INSCRICAO I ON E.ID = I.EVENTO_ID WHERE I.USUARIO_ID = ?";
        List<Event> eventos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                eventos.add(montarEvento(resultSet));
            }
            System.out.println("success in find events by inscrito");
            connection.close();
            return eventos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public List<Event> search(String nome, Integer categoriaId, String cidade, LocalDate data, int usuarioId) {
        String SQL = "SELECT DISTINCT E.* FROM EVENTO E LEFT JOIN EVENTO_CATEGORIA EC ON E.ID = EC.EVENTO_ID WHERE (E.PUBLICO = TRUE OR E.CRIADOR_ID = ?)";
        if (nome != null) {
            SQL += " AND UPPER(E.NOME) LIKE UPPER(?)";
        }
        if (categoriaId != null) {
            SQL += " AND EC.CATEGORIA_ID = ?";
        }
        if (cidade != null) {
            SQL += " AND UPPER(E.CIDADE) LIKE UPPER(?)";
        }
        if (data != null) {
            SQL += " AND E.DATA_EVENTO = ?";
        }
        SQL += " ORDER BY E.DATA_EVENTO";
        List<Event> eventos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            int indice = 1;
            preparedStatement.setInt(indice++, usuarioId);
            if (nome != null) {
                preparedStatement.setString(indice++, "%" + nome + "%");
            }
            if (categoriaId != null) {
                preparedStatement.setInt(indice++, categoriaId);
            }
            if (cidade != null) {
                preparedStatement.setString(indice++, "%" + cidade + "%");
            }
            if (data != null) {
                preparedStatement.setDate(indice, Date.valueOf(data));
            }
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                eventos.add(montarEvento(resultSet));
            }
            System.out.println("success in search events");
            connection.close();
            return eventos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public List<Event> findByFavorito(int usuarioId) {
        String SQL = "SELECT E.* FROM EVENTO E INNER JOIN FAVORITO F ON E.ID = F.EVENTO_ID WHERE F.USUARIO_ID = ?";
        List<Event> eventos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                eventos.add(montarEvento(resultSet));
            }
            System.out.println("success in find events by favorito");
            connection.close();
            return eventos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    private Event montarEvento(ResultSet resultSet) throws SQLException {
        Event evento = new Event();
        evento.setId(resultSet.getInt("ID"));
        evento.setNome(resultSet.getString("NOME"));
        evento.setSobre(resultSet.getString("SOBRE"));
        evento.setData(resultSet.getDate("DATA_EVENTO").toLocalDate());
        evento.setInicio(resultSet.getTime("INICIO").toLocalTime());
        Time fim = resultSet.getTime("FIM");
        if (fim != null) {
            evento.setFim(fim.toLocalTime());
        }
        evento.setVagas(resultSet.getInt("VAGAS"));
        evento.setPublico(resultSet.getBoolean("PUBLICO"));
        evento.setCancelado(resultSet.getBoolean("CANCELADO"));
        User criador = new User();
        criador.setId(resultSet.getInt("CRIADOR_ID"));
        evento.setCriador(criador);
        Endereco endereco = new Endereco();
        endereco.setRua(resultSet.getString("RUA"));
        endereco.setNumero(resultSet.getString("NUMERO"));
        endereco.setBairro(resultSet.getString("BAIRRO"));
        endereco.setCidade(resultSet.getString("CIDADE"));
        endereco.setEstado(resultSet.getString("ESTADO"));
        endereco.setCep(resultSet.getString("CEP"));
        evento.setEndereco(endereco);
        return evento;
    }
}