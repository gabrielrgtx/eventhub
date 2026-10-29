<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${evento.nome}</title>
</head>
<body>
    <h1>${evento.nome}</h1>
    <p>${evento.sobre}</p>
    <c:if test="${not empty evento.categorias}">
        <p>Categorias:
            <c:forEach var="categoria" items="${evento.categorias}" varStatus="status">
                ${categoria.nome}${status.last ? '' : ', '}
            </c:forEach>
        </p>
    </c:if>
    <c:forEach var="img" items="${evento.imagens}">
        <img src="${img.caminho}" width="200">
    </c:forEach>

    <p>Data: ${evento.data}</p>
    <p>Início: ${evento.inicio}</p>
    <c:if test="${not empty evento.fim}">
        <p>Fim: ${evento.fim}</p>
    </c:if>

    <h2>Endereço</h2>
    <p>Rua: ${evento.endereco.rua}</p>
    <p>Número: ${evento.endereco.numero}</p>
    <p>Bairro: ${evento.endereco.bairro}</p>
    <p>Cidade: ${evento.endereco.cidade}</p>
    <p>Estado: ${evento.endereco.estado}</p>
    <p>CEP: ${evento.endereco.cep}</p>

    <c:choose>
        <c:when test="${vagasRestantes <= 0}">
            <p>Esgotado</p>
        </c:when>
        <c:otherwise>
            <p>Vagas restantes: ${vagasRestantes}</p>
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${empty usuarioLogado}">
            <p><a href="/login">Entre para se inscrever</a></p>
        </c:when>
        <c:when test="${inscrito}">
            <form action="/inscricao" method="post">
                <input type="hidden" name="eventoId" value="${evento.id}">
                <input type="hidden" name="acao" value="cancelar">
                <button type="submit">Cancelar inscrição</button>
            </form>
        </c:when>
        <c:otherwise>
            <form action="/inscricao" method="post">
                <input type="hidden" name="eventoId" value="${evento.id}">
                <input type="hidden" name="acao" value="inscrever">
                <button type="submit">Inscrever-se</button>
            </form>
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${empty usuarioLogado}">
            <p><a href="/login">Entre para favoritar</a></p>
        </c:when>
        <c:when test="${favoritado}">
            <form action="/favorito" method="post">
                <input type="hidden" name="eventoId" value="${evento.id}">
                <input type="hidden" name="acao" value="desfavoritar">
                <button type="submit">Desfavoritar</button>
            </form>
        </c:when>
        <c:otherwise>
            <form action="/favorito" method="post">
                <input type="hidden" name="eventoId" value="${evento.id}">
                <input type="hidden" name="acao" value="favoritar">
                <button type="submit">Favoritar</button>
            </form>
        </c:otherwise>
    </c:choose>

    <p><a href="/listar-eventos">Voltar para os eventos</a></p>
</body>
</html>
