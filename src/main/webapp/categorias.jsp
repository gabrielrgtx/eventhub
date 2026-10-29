<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Categorias</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <main class="container">
        <div class="linhas"><span></span><span></span></div>
        <h1 class="titulo-pagina">Categorias</h1>

        <c:if test="${param.erro == 'nome-vazio'}">
            <p class="mensagem">O nome da categoria não pode ser vazio.</p>
        </c:if>
        <c:if test="${param.erro == 'nome-duplicado'}">
            <p class="mensagem">Já existe uma categoria com esse nome.</p>
        </c:if>

        <div class="caixa">
            <c:choose>
                <c:when test="${empty categoriaEdicao}">
                    <h2>Nova categoria</h2>
                    <form action="/categorias" method="post">
                        <input type="hidden" name="acao" value="criar">
                        <div class="campo">
                            <label>Nome</label>
                            <input type="text" name="nome" maxlength="100">
                        </div>
                        <button class="botao" type="submit">Cadastrar</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <h2>Editar categoria</h2>
                    <form action="/categorias" method="post">
                        <input type="hidden" name="acao" value="editar">
                        <input type="hidden" name="id" value="${categoriaEdicao.id}">
                        <div class="campo">
                            <label>Nome</label>
                            <input type="text" name="nome" value="<c:out value="${categoriaEdicao.nome}"/>" maxlength="100">
                        </div>
                        <button class="botao" type="submit">Salvar</button>
                        <a class="botao claro" href="/categorias">Cancelar edição</a>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <h2 class="subtitulo">Lista de categorias</h2>
        <c:choose>
            <c:when test="${empty categorias}">
                <p class="vazio">Nenhuma categoria cadastrada.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Ações</th>
                    </tr>
                    <c:forEach var="categoria" items="${categorias}">
                        <tr>
                            <td><c:out value="${categoria.nome}"/></td>
                            <td>
                                <a class="botao pequeno claro" href="/categorias?editar=${categoria.id}">Editar</a>
                                <form action="/categorias" method="post" onsubmit="return confirm('Excluir esta categoria?');">
                                    <input type="hidden" name="acao" value="excluir">
                                    <input type="hidden" name="id" value="${categoria.id}">
                                    <button class="botao pequeno perigo" type="submit">Excluir</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
