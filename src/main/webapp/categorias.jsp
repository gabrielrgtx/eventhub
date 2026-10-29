<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Categorias</title>
</head>
<body>
    <h1>Categorias</h1>

    <p>${param.erro == 'nome-vazio' ? 'O nome da categoria não pode ser vazio.' : ''}${param.erro == 'nome-duplicado' ? 'Já existe uma categoria com esse nome.' : ''}</p>

    <c:choose>
        <c:when test="${empty categoriaEdicao}">
            <h2>Nova categoria</h2>
            <form action="/categorias" method="post">
                <input type="hidden" name="acao" value="criar">
                <label>Nome</label>
                <input type="text" name="nome" maxlength="100">
                <button type="submit">Cadastrar</button>
            </form>
        </c:when>
        <c:otherwise>
            <h2>Editar categoria</h2>
            <form action="/categorias" method="post">
                <input type="hidden" name="acao" value="editar">
                <input type="hidden" name="id" value="${categoriaEdicao.id}">
                <label>Nome</label>
                <input type="text" name="nome" value="${categoriaEdicao.nome}" maxlength="100">
                <button type="submit">Salvar</button>
            </form>
            <p><a href="/categorias">Cancelar edição</a></p>
        </c:otherwise>
    </c:choose>

    <h2>Lista de categorias</h2>
    <c:choose>
        <c:when test="${empty categorias}">
            <p>Nenhuma categoria cadastrada.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Ações</th>
                </tr>
                <c:forEach var="categoria" items="${categorias}">
                    <tr>
                        <td>${categoria.id}</td>
                        <td>${categoria.nome}</td>
                        <td>
                            <a href="/categorias?editar=${categoria.id}">Editar</a>
                            <form action="/categorias" method="post" onsubmit="return confirm('Excluir esta categoria?');">
                                <input type="hidden" name="acao" value="excluir">
                                <input type="hidden" name="id" value="${categoria.id}">
                                <button type="submit">Excluir</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <p><a href="/painel">Meu painel</a> | <a href="/listar-eventos">Todos os eventos</a></p>
</body>
</html>