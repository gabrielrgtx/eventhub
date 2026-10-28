<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meu perfil</title>
</head>
<body>
    <h1>Meu perfil</h1>

    <p>${param.erro == 'eventos' ? 'Você não pode excluir a conta enquanto tiver eventos publicados.' : ''}</p>

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

    <form action="/excluir-conta" method="post" onsubmit="return confirm('Tem certeza que quer excluir sua conta?');">
        <button type="submit">Excluir conta</button>
    </form>

    <p><a href="/logout">Sair</a></p>
</body>
</html>