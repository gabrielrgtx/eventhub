<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
                        <td><a href="/evento?id=${evento.id}">${fn:escapeXml(evento.nome)}</a></td>
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
                        <td><a href="/evento?id=${evento.id}">${fn:escapeXml(evento.nome)}</a></td>
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
                        <td><a href="/evento?id=${evento.id}">${fn:escapeXml(evento.nome)}</a></td>
                        <td>${evento.data}</td>
                        <td>${evento.vagas}</td>
                        <td>${evento.cancelado ? 'Cancelado' : 'Ativo'}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <h2>Meus favoritos</h2>
    <c:choose>
        <c:when test="${empty favoritos}">
            <p>Você ainda não favoritou nenhum evento.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>Nome</th>
                    <th>Data</th>
                    <th>Vagas</th>
                    <th>Situação</th>
                </tr>
                <c:forEach var="evento" items="${favoritos}">
                    <tr>
                        <td><a href="/evento?id=${evento.id}">${fn:escapeXml(evento.nome)}</a></td>
                        <td>${evento.data}</td>
                        <td>${evento.vagas}</td>
                        <td>${evento.cancelado ? 'Cancelado' : 'Ativo'}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <p><a href="/listar-eventos">Todos os eventos</a> | <a href="/novo-evento">Novo evento</a></p>
</body>
</html>