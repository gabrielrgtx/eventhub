<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <input type="text" name="nome" value="${evento.nome}" required><br>

        <label>Sobre</label>
        <textarea name="sobre">${evento.sobre}</textarea><br>

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
        <input type="text" name="rua" value="${evento.endereco.rua}"><br>

        <label>Número</label>
        <input type="text" name="numero" value="${evento.endereco.numero}"><br>

        <label>Bairro</label>
        <input type="text" name="bairro" value="${evento.endereco.bairro}"><br>

        <label>Cidade</label>
        <input type="text" name="cidade" value="${evento.endereco.cidade}"><br>

        <label>Estado</label>
        <input type="text" name="estado" value="${evento.endereco.estado}" maxlength="2"><br>

        <label>CEP</label>
        <input type="text" name="cep" value="${evento.endereco.cep}"><br>

        <h3>Categorias</h3>
        <c:forEach var="c" items="${categorias}">
            <label><input type="checkbox" name="categorias" value="${c.id}" ${categoriasEvento.contains(c.id) ? 'checked' : ''}> ${c.nome}</label><br>
        </c:forEach>

        <h3>Imagens</h3>
        <label>URLs das imagens (uma por linha)</label><br>
        <textarea name="imagens" rows="4" cols="60"><c:forEach var="img" items="${imagensEvento}">${img.caminho}
</c:forEach></textarea><br>

        <button type="submit">Salvar</button>
    </form>

    <p><a href="/listar-eventos">Voltar para a lista</a></p>
</body>
</html>