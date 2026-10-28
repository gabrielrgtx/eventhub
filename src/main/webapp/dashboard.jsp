<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>
    <h1>Eventos</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="evento" items="${eventos}">
            <tr>
                <td>${evento.id}</td>
                <td>${evento.nome}${evento.cancelado ? ' (cancelado)' : ''}</td>
                <td>
                    <a href="/editar-evento?id=${evento.id}">Editar</a>
                    <form action="/cancelar-evento" method="post">
                        <input type="hidden" name="id" value="${evento.id}">
                        <button type="submit">Cancelar</button>
                    </form>
                    <form action="/delete-event" method="post">
                        <input type="hidden" id="id" name="id" value="${evento.id}">
                        <button type="submit">Delete</button>
                    </form>
                    <form action="/inscricao" method="post">
                        <input type="hidden" name="acao" value="inscrever">
                        <input type="hidden" name="eventoId" value="${evento.id}">
                        <button type="submit">Inscrever-se</button>
                    </form>
                    <form action="/inscricao" method="post">
                        <input type="hidden" name="acao" value="cancelar">
                        <input type="hidden" name="eventoId" value="${evento.id}">
                        <button type="submit">Cancelar inscrição</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
    <p><a href="/">Novo evento</a></p>
    <p><a href="/painel">Meu painel</a></p>
</body>
</html>