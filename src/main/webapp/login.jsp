<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <main class="login-pagina">
        <svg class="login-onda onda-cima" viewBox="0 0 1280 390" preserveAspectRatio="none" aria-hidden="true"><path d="M-50 380C240 95 414 138 646 191S1077 330 1340-10"/></svg>
        <svg class="login-onda onda-baixo" viewBox="0 0 1280 470" preserveAspectRatio="none" aria-hidden="true"><path d="M-90 50C206 14 529 154 585 302S498 491 438 416 475 241 691 248 1061 325 1360 468"/></svg>
        <div class="login-caixa">
            <a class="logo" href="/listar-eventos">EventHub</a>

            <c:if test="${not empty erro}">
                <p class="mensagem" role="alert"><c:out value="${erro}"/></p>
            </c:if>
            <c:if test="${param.cadastro == 'sucesso'}"><p class="mensagem" role="status">Conta criada! Entre com seu usuário ou e-mail.</p></c:if>

            <form action="/login" method="post">
                <div class="campo">
                    <label class="acessivel" for="identificador-login">Usuário ou e-mail</label>
                    <input type="text" name="identificador" id="identificador-login" placeholder="Usuário ou e-mail" autocomplete="username" value="<c:out value="${param.identificador}"/>">
                </div>
                <div class="campo">
                    <label class="acessivel" for="senha-login">Senha</label>
                    <div class="senha-campo"><input type="password" name="senha" placeholder="Senha" id="senha-login" autocomplete="current-password"><button type="button" class="olho" aria-label="Mostrar senha" onclick="mostrarSenha('senha-login')"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/><path d="M3 3 21 21"/></svg></button></div>
                </div>
                <div class="login-botoes">
                    <button class="botao" type="submit">Entrar</button>
                    <a class="botao" href="/cadastro">Criar conta</a>
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
