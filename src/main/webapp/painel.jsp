<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meu painel</title>
</head>
<body>
    <h1>Meu painel</h1>

    <h2>Eventos que criei</h2>
    <c:choose>
        <c:when test="${empty criados}">
            <p>Você ainda não criou nenhum evento.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>Nome</th>
                    <th>Data</th>
                    <th>Vagas</th>
                    <th>Situação</th>
                </tr>
                <c:forEach var="evento" items="${criados}">
                    <tr>
                        <td>${evento.nome}</td>
                        <td>${evento.data}</td>
                        <td>${evento.vagas}</td>
                        <td>${evento.cancelado ? 'Cancelado' : 'Ativo'}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <h2>Eventos que vou</h2>
    <c:choose>
        <c:when test="${empty vou}">
            <p>Você não vai a nenhum evento.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>Nome</th>
                    <th>Data</th>
                    <th>Vagas</th>
                    <th>Situação</th>
                </tr>
                <c:forEach var="evento" items="${vou}">
                    <tr>
                        <td>${evento.nome}</td>
                        <td>${evento.data}</td>
                        <td>${evento.vagas}</td>
                        <td>${evento.cancelado ? 'Cancelado' : 'Ativo'}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <h2>Eventos que já fui</h2>
    <c:choose>
        <c:when test="${empty fui}">
            <p>Você ainda não foi a nenhum evento.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>Nome</th>
                    <th>Data</th>
                    <th>Vagas</th>
                    <th>Situação</th>
                </tr>
                <c:forEach var="evento" items="${fui}">
                    <tr>
                        <td>${evento.nome}</td>
                        <td>${evento.data}</td>
                        <td>${evento.vagas}</td>
                        <td>${evento.cancelado ? 'Cancelado' : 'Ativo'}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <p><a href="/listar-eventos">Todos os eventos</a> | <a href="/">Novo evento</a></p>
</body>
</html>