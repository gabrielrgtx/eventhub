<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meu perfil</title>
</head>
<body>
    <h1>Meu perfil</h1>

    <form action="/perfil" method="post">
        <label>Nome</label>
        <input type="text" name="nome" value="${usuarioLogado.nome}"><br>

        <label>Usuário</label>
        <input type="text" name="usuario" value="${usuarioLogado.usuario}"><br>

        <label>E-mail</label>
        <input type="email" name="email" value="${usuarioLogado.email}"><br>

        <label>Foto (caminho)</label>
        <input type="text" name="foto" value="${usuarioLogado.foto}"><br>

        <button type="submit">Salvar</button>
    </form>

    <p><a href="/logout">Sair</a></p>
</body>
</html>