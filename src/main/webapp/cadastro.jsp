<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastre-se</title>
</head>
<body>
    <h1>Cadastre-se!</h1>

    <p>${fn:escapeXml(erro)}</p>

    <form action="/cadastro" method="post">
        <label>Nome</label>
        <input type="text" name="nome"><br>

        <label>Usuário</label>
        <input type="text" name="usuario"><br>

        <label>E-mail</label>
        <input type="email" name="email"><br>

        <label>Senha</label>
        <input type="password" name="senha"><br>

        <button type="submit">Sign in</button>
    </form>

    <a href="/login">Já tenho conta</a>
</body>
</html>