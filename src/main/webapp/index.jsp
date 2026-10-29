<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:if test="${categorias == null}">
    <c:redirect url="/novo-evento"/>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Evento</title>
</head>
<body>
    <h2>${empty evento ? 'Novo Evento' : 'Editar Evento'}</h2>

    <form action="/create-event" method="post">
        <input type="hidden" name="id" value="${evento.id}">

        <label>Nome</label>
        <input type="text" name="nome" value="${fn:escapeXml(evento.nome)}" required><br>

        <label>Sobre</label>
        <textarea name="sobre">${fn:escapeXml(evento.sobre)}</textarea><br>

        <label>Data</label>
        <input type="date" name="data" value="${evento.data}" required><br>

        <label>Início</label>
        <input type="time" name="inicio" value="${evento.inicio}" required><br>

        <label>Fim</label>
        <input type="time" name="fim" value="${evento.fim}"><br>

        <label>Vagas</label>
        <input type="number" name="vagas" value="${evento.vagas}" min="0" required><br>

        <label>Público</label>
        <input type="checkbox" name="publico" ${empty evento or evento.publico ? 'checked' : ''}><br>

        <h3>Endereço</h3>
        <label>Rua</label>
        <input type="text" name="rua" value="${fn:escapeXml(evento.endereco.rua)}"><br>

        <label>Número</label>
        <input type="text" name="numero" value="${fn:escapeXml(evento.endereco.numero)}"><br>

        <label>Bairro</label>
        <input type="text" name="bairro" value="${fn:escapeXml(evento.endereco.bairro)}"><br>

        <label>Cidade</label>
        <input type="text" name="cidade" value="${fn:escapeXml(evento.endereco.cidade)}"><br>

        <label>Estado</label>
        <input type="text" name="estado" value="${fn:escapeXml(evento.endereco.estado)}" maxlength="2"><br>

        <label>CEP</label>
        <input type="text" name="cep" value="${fn:escapeXml(evento.endereco.cep)}"><br>

        <h3>Categorias</h3>
        <c:forEach var="c" items="${categorias}">
            <label><input type="checkbox" name="categorias" value="${c.id}" ${categoriasEvento.contains(c.id) ? 'checked' : ''}> ${fn:escapeXml(c.nome)}</label><br>
        </c:forEach>

        <h3>Imagens</h3>
        <label>URLs das imagens (uma por linha, começando com http:// ou https://)</label><br>
        <textarea name="imagens" rows="4" cols="60"><c:forEach var="img" items="${imagensEvento}">${fn:escapeXml(img.caminho)}
</c:forEach></textarea><br>

        <button type="submit">Salvar</button>
    </form>

    <p><a href="/listar-eventos">Voltar para a lista</a></p>
</body>
</html>