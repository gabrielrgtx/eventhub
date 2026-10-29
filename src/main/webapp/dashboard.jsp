<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>
    <h1>Eventos</h1>
    <form action="/listar-eventos" method="get">
        <input type="text" name="nome" placeholder="Buscar por nome" value="${fn:escapeXml(param.nome)}">
        <select name="categoria">
            <option value="">Todas as categorias</option>
            <c:forEach var="c" items="${categorias}">
                <option value="${c.id}" ${param.categoria == c.id ? 'selected' : ''}>${fn:escapeXml(c.nome)}</option>
            </c:forEach>
        </select>
        <input type="text" name="cidade" placeholder="Cidade" value="${fn:escapeXml(param.cidade)}">
        <input type="date" name="data" value="${fn:escapeXml(param.data)}">
        <button type="submit">Buscar</button>
        <a href="/listar-eventos">Limpar</a>
    </form>
    <c:if test="${empty eventos}">
        <p>Nenhum evento encontrado.</p>
    </c:if>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="evento" items="${eventos}">
            <tr>
                <td>${evento.id}</td>
                <td>${fn:escapeXml(evento.nome)}${evento.cancelado ? ' (cancelado)' : ''}</td>
                <td>
                    <a href="/evento?id=${evento.id}">Ver</a>
                    <c:if test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}">
                        <a href="/editar-evento?id=${evento.id}">Editar</a>
                        <form action="/cancelar-evento" method="post">
                            <input type="hidden" name="id" value="${evento.id}">
                            <button type="submit">Cancelar</button>
                        </form>
                        <form action="/delete-event" method="post">
                            <input type="hidden" id="id" name="id" value="${evento.id}">
                            <button type="submit">Delete</button>
                        </form>
                    </c:if>
                    <c:choose>
                        <c:when test="${empty usuarioLogado}">
                            <a href="/login">Entre para se inscrever</a>
                        </c:when>
                        <c:when test="${inscritos.contains(evento.id)}">
                            <form action="/inscricao" method="post">
                                <input type="hidden" name="acao" value="cancelar">
                                <input type="hidden" name="eventoId" value="${evento.id}">
                                <button type="submit">Cancelar inscrição</button>
                            </form>
                        </c:when>
                        <c:when test="${evento.cancelado}">
                            Cancelado
                        </c:when>
                        <c:when test="${vagasRestantes[evento.id] <= 0}">
                            Esgotado
                        </c:when>
                        <c:otherwise>
                            <form action="/inscricao" method="post">
                                <input type="hidden" name="acao" value="inscrever">
                                <input type="hidden" name="eventoId" value="${evento.id}">
                                <button type="submit">Inscrever-se</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </table>
    <p><a href="/novo-evento">Novo evento</a></p>
    <p><a href="/painel">Meu painel</a></p>
</body>
</html>