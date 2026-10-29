<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Meu perfil</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <main class="container">
        <div class="linhas"><span></span><span></span></div>
        <h1 class="titulo-pagina">Editar perfil</h1>

        <c:if test="${param.erro == 'eventos'}">
            <p class="mensagem">Você não pode excluir a conta enquanto tiver eventos publicados.</p>
        </c:if>

        <form class="caixa" action="/perfil" method="post">
            <div class="campo">
                <label>Nome</label>
                <input type="text" name="nome" value="<c:out value="${usuarioLogado.nome}"/>">
            </div>
            <div class="campo">
                <label>Usuário</label>
                <input type="text" name="usuario" value="<c:out value="${usuarioLogado.usuario}"/>">
            </div>
            <div class="campo">
                <label>E-mail</label>
                <input type="email" name="email" value="<c:out value="${usuarioLogado.email}"/>">
            </div>
            <div class="campo">
                <label>Foto (URL)</label>
                <input type="text" name="foto" value="<c:out value="${usuarioLogado.foto}"/>">
            </div>
            <button class="botao" type="submit">Salvar</button>
            <a class="botao claro" href="/usuario?id=${usuarioLogado.id}">Ver meu perfil</a>
        </form>

        <div class="caixa">
            <p><a href="/categorias">Gerenciar categorias</a></p>
            <p><a class="botao claro" href="/logout">Sair</a></p>
            <form action="/excluir-conta" method="post" onsubmit="return confirm('Tem certeza que quer excluir sua conta?');">
                <button class="botao perigo" type="submit">Excluir conta</button>
            </form>
        </div>
    </main>
</body>
</html>
