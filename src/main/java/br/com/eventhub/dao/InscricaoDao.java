package br.com.eventhub.dao;

import br.com.eventhub.model.Inscricao;
import br.com.eventhub.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class InscricaoDao {

    public static final int ERRO = 0;
    public static final int SUCESSO = 1;
    public static final int INDISPONIVEL = 2;
    public static final int JA_INSCRITO = 3;
    public static final int ESGOTADO = 4;
    public static final int ENCERRADO = 5;
    public static final int PROPRIO_EVENTO = 6;

    public int inscrever(int usuarioId, int eventoId) {
        String SQL_EVENTO = "SELECT DATA_EVENTO, INICIO, VAGAS, CANCELADO, CRIADOR_ID FROM EVENTO WHERE ID = ? FOR UPDATE";
        String SQL_EXISTE = "SELECT COUNT(*) FROM INSCRICAO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
        String SQL_TOTAL = "SELECT COUNT(*) FROM INSCRICAO WHERE EVENTO_ID = ?";
        String SQL_INSERIR = "INSERT INTO INSCRICAO (USUARIO_ID, EVENTO_ID, DATA_INSCRICAO) VALUES (?, ?, CURRENT_TIMESTAMP)";
        Connection connection = null;
        try {
            connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            connection.setAutoCommit(false);
            PreparedStatement eventoStatement = connection.prepareStatement(SQL_EVENTO);
            eventoStatement.setInt(1, eventoId);
            ResultSet evento = eventoStatement.executeQuery();
            int resultado = SUCESSO;
            if (!evento.next() || evento.getBoolean("CANCELADO")) {
                resultado = INDISPONIVEL;
            } else if (evento.getInt("CRIADOR_ID") == usuarioId) {
                resultado = PROPRIO_EVENTO;
            } else if (!LocalDateTime.of(evento.getDate("DATA_EVENTO").toLocalDate(), evento.getTime("INICIO").toLocalTime()).isAfter(LocalDateTime.now())) {
                resultado = ENCERRADO;
            } else {
                PreparedStatement existeStatement = connection.prepareStatement(SQL_EXISTE);
                existeStatement.setInt(1, usuarioId);
                existeStatement.setInt(2, eventoId);
                ResultSet existe = existeStatement.executeQuery();
                existe.next();
                if (existe.getInt(1) > 0) {
                    resultado = JA_INSCRITO;
                } else {
                    PreparedStatement totalStatement = connection.prepareStatement(SQL_TOTAL);
                    totalStatement.setInt(1, eventoId);
                    ResultSet total = totalStatement.executeQuery();
                    total.next();
                    if (total.getInt(1) >= evento.getInt("VAGAS")) {
                        resultado = ESGOTADO;
                    } else {
                        PreparedStatement inserirStatement = connection.prepareStatement(SQL_INSERIR);
                        inserirStatement.setInt(1, usuarioId);
                        inserirStatement.setInt(2, eventoId);
                        inserirStatement.executeUpdate();
                    }
                }
            }
            if (resultado == SUCESSO) {
                connection.commit();
            } else {
                connection.rollback();
            }
            System.out.println("success in insert inscricao");
            return resultado;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ignored) {
                    System.out.println("fail in database connection");
                }
            }
            return ERRO;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception ignored) {
                    System.out.println("fail in database connection");
                }
            }
        }
    }

    public int cancelar(int usuarioId, int eventoId) {
        String SQL_EVENTO = "SELECT DATA_EVENTO, INICIO FROM EVENTO WHERE ID = ? FOR UPDATE";
        String SQL_EXCLUIR = "DELETE FROM INSCRICAO WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
        Connection connection = null;
        try {
            connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            connection.setAutoCommit(false);
            PreparedStatement eventoStatement = connection.prepareStatement(SQL_EVENTO);
            eventoStatement.setInt(1, eventoId);
            ResultSet evento = eventoStatement.executeQuery();
            if (!evento.next()) {
                connection.rollback();
                return INDISPONIVEL;
            }
            if (!LocalDateTime.of(evento.getDate("DATA_EVENTO").toLocalDate(), evento.getTime("INICIO").toLocalTime()).isAfter(LocalDateTime.now())) {
                connection.rollback();
                return ENCERRADO;
            }
            PreparedStatement excluirStatement = connection.prepareStatement(SQL_EXCLUIR);
            excluirStatement.setInt(1, usuarioId);
            excluirStatement.setInt(2, eventoId);
            int excluidos = excluirStatement.executeUpdate();
            connection.commit();
            System.out.println("success in delete inscricao");
            return excluidos == 1 ? SUCESSO : JA_INSCRITO;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ignored) {
                    System.out.println("fail in database connection");
                }
            }
            return ERRO;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception ignored) {
                    System.out.println("fail in database connection");
                }
            }
        }
    }

    public boolean confirmarPresenca(int criadorId, int usuarioId, int eventoId) {
        String SQL = "INSERT INTO PRESENCA (USUARIO_ID, EVENTO_ID, DATA_CONFIRMACAO) "
                + "SELECT I.USUARIO_ID, I.EVENTO_ID, CURRENT_TIMESTAMP FROM INSCRICAO I "
                + "JOIN EVENTO E ON E.ID = I.EVENTO_ID WHERE I.USUARIO_ID = ? AND I.EVENTO_ID = ? "
                + "AND E.CRIADOR_ID = ? AND E.CANCELADO = FALSE AND E.DATA_EVENTO < CURRENT_DATE "
                + "AND NOT EXISTS (SELECT 1 FROM PRESENCA P WHERE P.USUARIO_ID = I.USUARIO_ID AND P.EVENTO_ID = I.EVENTO_ID)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            preparedStatement.setInt(3, criadorId);
            int inseridos = preparedStatement.executeUpdate();
            System.out.println("success in confirm presenca");
            connection.close();
            return inseridos == 1;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return false;
        }
    }

    public List<Inscricao> findByEvento(int eventoId) {
        String SQL = "SELECT I.ID, I.DATA_INSCRICAO, U.ID AS USUARIO_ID, U.NOME, U.USUARIO, "
                + "P.USUARIO_ID AS PRESENCA_ID FROM INSCRICAO I JOIN USUARIO U ON U.ID = I.USUARIO_ID "
                + "LEFT JOIN PRESENCA P ON P.USUARIO_ID = I.USUARIO_ID AND P.EVENTO_ID = I.EVENTO_ID "
                + "WHERE I.EVENTO_ID = ? ORDER BY U.NOME";
        List<Inscricao> inscritos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Inscricao inscricao = new Inscricao();
                inscricao.setId(resultSet.getInt("ID"));
                inscricao.setDataInscricao(resultSet.getTimestamp("DATA_INSCRICAO").toLocalDateTime());
                inscricao.setPresencaConfirmada(resultSet.getObject("PRESENCA_ID") != null);
                User usuario = new User();
                usuario.setId(resultSet.getInt("USUARIO_ID"));
                usuario.setNome(resultSet.getString("NOME"));
                usuario.setUsuario(resultSet.getString("USUARIO"));
                inscricao.setUsuario(usuario);
                inscritos.add(inscricao);
            }
            System.out.println("success in find inscricoes by evento");
            connection.close();
            return inscritos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public boolean existsPresenca(int usuarioId, int eventoId) {
        String SQL = "SELECT COUNT(*) FROM PRESENCA WHERE USUARIO_ID = ? AND EVENTO_ID = ?";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, usuarioId);
            preparedStatement.setInt(2, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            resultSet.next();
            boolean existe = resultSet.getInt(1) > 0;
            System.out.println("success in check presenca");
            connection.close();
            return existe;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return false;
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
