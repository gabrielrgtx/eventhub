package br.com.eventhub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class EventoAcessibilidadeDao {

    public static final Map<String, String> RECURSOS = new LinkedHashMap<>();

    static {
        RECURSOS.put("RAMPA", "Rampa de acesso");
        RECURSOS.put("LIBRAS", "Intérprete de Libras");
        RECURSOS.put("BANHEIRO_ADAPTADO", "Banheiro adaptado");
        RECURSOS.put("ESPACO_SENSORIAL", "Espaço sensorial");
    }

    public static List<String> validos(String[] valores) {
        List<String> recursos = new ArrayList<>();
        if (valores != null) {
            for (String valor : valores) {
                if (RECURSOS.containsKey(valor) && !recursos.contains(valor)) {
                    recursos.add(valor);
                }
            }
        }
        return recursos;
    }

    public void salvar(int eventoId, List<String> recursos) {
        String SQL_EXCLUIR = "DELETE FROM EVENTO_ACESSIBILIDADE WHERE EVENTO_ID = ?";
        String SQL_INSERIR = "INSERT INTO EVENTO_ACESSIBILIDADE (EVENTO_ID, RECURSO) VALUES (?, ?)";
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement excluirStatement = connection.prepareStatement(SQL_EXCLUIR);
            excluirStatement.setInt(1, eventoId);
            excluirStatement.execute();
            for (String recurso : recursos) {
                PreparedStatement inserirStatement = connection.prepareStatement(SQL_INSERIR);
                inserirStatement.setInt(1, eventoId);
                inserirStatement.setString(2, recurso);
                inserirStatement.execute();
            }
            System.out.println("success in save evento acessibilidade");
            connection.close();
        } catch (Exception e) {
            System.out.println("fail in database connection");
        }
    }

    public List<String> findRecursosByEvento(int eventoId) {
        String SQL = "SELECT RECURSO FROM EVENTO_ACESSIBILIDADE WHERE EVENTO_ID = ?";
        List<String> recursos = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setInt(1, eventoId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                recursos.add(resultSet.getString("RECURSO"));
            }
            System.out.println("success in find recursos by evento");
            connection.close();
            return recursos;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }

    public List<Integer> findEventoIdsComTodos(List<String> recursos) {
        StringBuilder marcadores = new StringBuilder();
        for (int i = 0; i < recursos.size(); i++) {
            marcadores.append(i == 0 ? "?" : ", ?");
        }
        String SQL = "SELECT EVENTO_ID FROM EVENTO_ACESSIBILIDADE WHERE RECURSO IN (" + marcadores + ") "
                + "GROUP BY EVENTO_ID HAVING COUNT(DISTINCT RECURSO) = ?";
        List<Integer> eventoIds = new ArrayList<>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println("success in database connection");
            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            for (int i = 0; i < recursos.size(); i++) {
                preparedStatement.setString(i + 1, recursos.get(i));
            }
            preparedStatement.setInt(recursos.size() + 1, recursos.size());
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                eventoIds.add(resultSet.getInt("EVENTO_ID"));
            }
            System.out.println("success in find eventos by acessibilidade");
            connection.close();
            return eventoIds;
        } catch (Exception e) {
            System.out.println("fail in database connection");
            return Collections.emptyList();
        }
    }
}
