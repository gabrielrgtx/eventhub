<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EventHub</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <main class="container">
        <h2 class="faixa">Quer saber qual é o próximo rolê?</h2>
        <div class="caixa">
            <p>Encontre eventos perto de você, se inscreva e acompanhe tudo pelo seu dashboard.</p>
            <p><a class="botao" href="/listar-eventos">Ver eventos</a></p>
        </div>
    </main>
</body>
</html>
