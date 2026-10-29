<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${fn:escapeXml(perfil.nome)}</title>
</head>
<body>
    <h1>${fn:escapeXml(perfil.nome)}</h1>
    <p>@${fn:escapeXml(perfil.usuario)}</p>
    <c:if test="${fn:startsWith(perfil.foto, 'http://') or fn:startsWith(perfil.foto, 'https://')}">
        <img src="${fn:escapeXml(perfil.foto)}" width="120">
    </c:if>

    <h2>Eventos publicados</h2>
    <c:choose>
        <c:when test="${empty eventos}">
            <p>Nenhum evento publicado.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>Nome</th>
                    <th>Data</th>
                    <th>Situação</th>
                </tr>
                <c:forEach var="evento" items="${eventos}">
                    <tr>
                        <td><a href="/evento?id=${evento.id}">${fn:escapeXml(evento.nome)}</a></td>
                        <td>${evento.data}</td>
                        <td>${evento.cancelado ? 'Cancelado' : 'Ativo'}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <h2>Avaliações</h2>
    <c:choose>
        <c:when test="${empty avaliacoes}">
            <p>Nenhuma avaliação feita.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="avaliacao" items="${avaliacoes}">
                <p>
                    <a href="/evento?id=${avaliacao.evento.id}">${fn:escapeXml(avaliacao.evento.nome)}</a> - nota ${avaliacao.nota}<br>
                    ${fn:escapeXml(avaliacao.comentario)}
                </p>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <p><a href="/listar-eventos">Voltar para os eventos</a></p>
</body>
</html>
