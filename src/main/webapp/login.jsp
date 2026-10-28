<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <h1>EventHub</h1>

    <p>${erro}</p>

    <form action="/login" method="post">
        <label>Usuário ou e-mail</label>
        <input type="text" name="identificador"><br>

        <label>Senha</label>
        <input type="password" name="senha"><br>

        <button type="submit">Log in</button>
    </form>

    <a href="/cadastro">Cadastre-se</a>
</body>
</html>