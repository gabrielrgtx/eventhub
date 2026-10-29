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
        <c:if test="${param.erro == 'duplicado'}"><p class="mensagem" role="alert">Usuário ou e-mail já está em uso.</p></c:if>
        <c:if test="${param.erro == 'salvar'}"><p class="mensagem" role="alert">Não foi possível salvar o perfil. Tente novamente.</p></c:if>
        <c:if test="${param.retorno == 'salvo'}"><p class="mensagem" role="status">Perfil atualizado.</p></c:if>
        <c:if test="${param.erro == 'foto'}"><p class="mensagem" role="alert">Não foi possível usar essa foto. Envie uma imagem JPG, PNG, WEBP ou GIF de até 5 MB.</p></c:if>

        <form class="caixa" action="/editar-perfil" method="post" enctype="multipart/form-data">
            <div class="campo foto-perfil">
                <c:choose>
                    <c:when test="${not empty usuarioLogado.foto}">
                        <img class="foto-previa" id="foto-previa" src="<c:out value="${usuarioLogado.foto}"/>" alt="Sua foto de perfil">
                    </c:when>
                    <c:otherwise>
                        <img class="foto-previa" id="foto-previa" alt="Sua foto de perfil" hidden>
                        <span class="avatar avatar-padrao foto-previa" id="foto-padrao"><svg viewBox="0 0 100 100" aria-hidden="true"><circle cx="50" cy="36" r="19"/><path d="M14 99c3-24 18-37 36-37s33 13 36 37"/></svg></span>
                    </c:otherwise>
                </c:choose>
                <div>
                    <label class="botao claro" for="foto-arquivo">${empty usuarioLogado.foto ? 'Adicionar foto' : 'Trocar foto'}</label>
                    <input class="acessivel" type="file" id="foto-arquivo" name="foto-arquivo" accept="image/jpeg,image/png,image/webp,image/gif">
                    <p class="vazio">JPG, PNG, WEBP ou GIF, até 5 MB.</p>
                    <c:if test="${not empty usuarioLogado.foto}">
                        <label class="remover-foto"><input type="checkbox" name="remover-foto"> Remover foto atual</label>
                    </c:if>
                </div>
            </div>
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
            <button class="botao" type="submit">Salvar</button>
            <a class="botao claro" href="/perfil">Ver meu perfil</a>
        </form>

        <div class="caixa">
            <p><a href="/categorias">Gerenciar categorias</a></p>
            <p><a class="botao claro" href="/logout">Sair</a></p>
            <form action="/excluir-conta" method="post" onsubmit="return confirm('Tem certeza que quer excluir sua conta?');">
                <button class="botao perigo" type="submit">Excluir conta</button>
            </form>
        </div>
    </main>
    <script>
        (function () {
            var arquivo = document.getElementById('foto-arquivo');
            var previa = document.getElementById('foto-previa');
            var padrao = document.getElementById('foto-padrao');
            arquivo.addEventListener('change', function () {
                if (arquivo.files.length == 0) {
                    return;
                }
                if (arquivo.files[0].size > 5 * 1024 * 1024) {
                    alert('A foto precisa ter no máximo 5 MB.');
                    arquivo.value = '';
                    return;
                }
                previa.src = URL.createObjectURL(arquivo.files[0]);
                previa.hidden = false;
                if (padrao != null) {
                    padrao.hidden = true;
                }
            });
        })();
    </script>
</body>
</html>
