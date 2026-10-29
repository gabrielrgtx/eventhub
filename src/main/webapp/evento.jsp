<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${fn:escapeXml(evento.nome)}</title>
</head>
<body>
    <h1>${fn:escapeXml(evento.nome)}</h1>
    <c:if test="${evento.cancelado}">
        <p><strong>Evento cancelado</strong></p>
    </c:if>
    <p>${fn:escapeXml(evento.sobre)}</p>
    <c:if test="${not empty evento.categorias}">
        <p>Categorias:
            <c:forEach var="categoria" items="${evento.categorias}" varStatus="status">
                ${fn:escapeXml(categoria.nome)}${status.last ? '' : ', '}
            </c:forEach>
        </p>
    </c:if>
    <c:forEach var="img" items="${evento.imagens}">
        <img src="${fn:escapeXml(img.caminho)}" width="200">
    </c:forEach>

    <p>Data: ${evento.data}</p>
    <p>Início: ${evento.inicio}</p>
    <c:if test="${not empty evento.fim}">
        <p>Fim: ${evento.fim}</p>
    </c:if>

    <h2>Endereço</h2>
    <p>Rua: ${fn:escapeXml(evento.endereco.rua)}</p>
    <p>Número: ${fn:escapeXml(evento.endereco.numero)}</p>
    <p>Bairro: ${fn:escapeXml(evento.endereco.bairro)}</p>
    <p>Cidade: ${fn:escapeXml(evento.endereco.cidade)}</p>
    <p>Estado: ${fn:escapeXml(evento.endereco.estado)}</p>
    <p>CEP: ${fn:escapeXml(evento.endereco.cep)}</p>

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
        <c:when test="${not evento.cancelado and vagasRestantes > 0}">
            <form action="/inscricao" method="post">
                <input type="hidden" name="eventoId" value="${evento.id}">
                <input type="hidden" name="acao" value="inscrever">
                <button type="submit">Inscrever-se</button>
            </form>
        </c:when>
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

    <h2>Avaliações</h2>
    <c:if test="${not empty param.erro}">
        <p>Não foi possível avaliar: ${fn:escapeXml(param.erro)}</p>
    </c:if>
    <c:choose>
        <c:when test="${empty avaliacoes}">
            <p>Nenhuma avaliação ainda.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="avaliacao" items="${avaliacoes}">
                <p>
                    <strong>${fn:escapeXml(avaliacao.usuario.nome)}</strong> - nota ${avaliacao.nota}<br>
                    ${fn:escapeXml(avaliacao.comentario)}
                </p>
                <c:if test="${not empty usuarioLogado and usuarioLogado.id == avaliacao.usuario.id}">
                    <form action="/avaliacao" method="post">
                        <input type="hidden" name="eventoId" value="${evento.id}">
                        <input type="hidden" name="avaliacaoId" value="${avaliacao.id}">
                        <input type="hidden" name="acao" value="excluir">
                        <button type="submit">Excluir minha avaliação</button>
                    </form>
                </c:if>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    <c:if test="${podeAvaliar}">
        <form action="/avaliacao" method="post">
            <input type="hidden" name="eventoId" value="${evento.id}">
            <input type="hidden" name="acao" value="criar">
            <label>Nota</label>
            <select name="nota">
                <option value="5">5</option>
                <option value="4">4</option>
                <option value="3">3</option>
                <option value="2">2</option>
                <option value="1">1</option>
            </select><br>
            <label>Comentário</label><br>
            <textarea name="comentario" maxlength="1000"></textarea><br>
            <button type="submit">Avaliar</button>
        </form>
    </c:if>

    <p><a href="/listar-eventos">Voltar para os eventos</a></p>
</body>
</html>
