<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cadastre-se</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <main class="login-pagina">
        <svg class="login-onda onda-cadastro" viewBox="0 0 1280 850" preserveAspectRatio="none" aria-hidden="true"><path d="M620-90C816 98 1202 205 1271 51S933-160 997 154 1159 498 1370 614"/></svg>
        <svg class="login-onda onda-baixo" viewBox="0 0 1280 470" preserveAspectRatio="none" aria-hidden="true"><path d="M-100 65C196 12 470 139 655 300S1050 454 1390 494"/></svg>
        <div class="login-caixa">
            <h1 class="logo">Cadastre-se!</h1>

            <c:if test="${not empty erro}">
                <p class="mensagem" role="alert"><c:out value="${erro}"/></p>
            </c:if>

            <form action="/cadastro" method="post">
                <div class="campo">
                    <label class="acessivel" for="cadastro-nome">Nome</label>
                    <input type="text" name="nome" id="cadastro-nome" placeholder="Nome" autocomplete="name" value="<c:out value="${param.nome}"/>">
                </div>
                <div class="campo">
                    <label class="acessivel" for="cadastro-usuario">Usuário</label>
                    <input type="text" name="usuario" id="cadastro-usuario" placeholder="Usuário" autocomplete="username" value="<c:out value="${param.usuario}"/>">
                </div>
                <div class="campo">
                    <label class="acessivel" for="cadastro-email">E-mail</label>
                    <input type="email" name="email" id="cadastro-email" placeholder="E-mail" autocomplete="email" value="<c:out value="${param.email}"/>">
                </div>
                <div class="campo">
                    <label class="acessivel" for="senha-cadastro">Senha</label>
                    <div class="senha-campo"><input type="password" name="senha" placeholder="Senha" id="senha-cadastro" autocomplete="new-password"><button type="button" class="olho" aria-label="Mostrar senha" onclick="mostrarSenha('senha-cadastro')"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/><path d="M3 3 21 21"/></svg></button></div>
                </div>
                <div class="login-botoes">
                    <a class="botao" href="/login">Entrar</a>
                    <button class="botao" type="submit">Criar conta</button>
                </div>
            </form>
        </div>
    </main>
    <script>
        function mostrarSenha(id) {
            var campo = document.getElementById(id);
            if (campo.type == 'password') {
                campo.type = 'text';
            } else {
                campo.type = 'password';
            }
        }
    </script>
</body>
</html>
