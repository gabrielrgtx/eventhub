<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <main class="container">
        <div class="linhas"><span></span><span></span></div>
        <h1 class="titulo-pagina">Dashboard</h1>

        <div class="caixa painel-caixa">
            <h2>Próximos Eventos</h2>
            <div class="calendario-proximos"><div class="calendario"><header id="mes-atual"></header><div class="calendario-dias" id="calendario-dias"></div></div><div>
            <c:if test="${empty vou}">
                <p class="vazio">Você não vai a nenhum evento.</p>
            </c:if>
            <div class="lista-horizontal">
                <c:forEach var="evento" items="${vou}">
                    <%@ include file="cartao-linha.jsp" %>
                </c:forEach>
            </div>
            </div></div>

            <h2>Meus Eventos</h2>
            <c:if test="${empty criados}">
                <p class="vazio">Você ainda não criou nenhum evento. <a href="/novo-evento">Criar evento</a></p>
            </c:if>
            <div class="lista-horizontal">
                <c:forEach var="evento" items="${criados}">
                    <%@ include file="cartao-linha.jsp" %>
                </c:forEach>
            </div>

            <h2>Eventos Que Fui</h2>
            <c:if test="${empty fui}">
                <p class="vazio">Você ainda não foi a nenhum evento.</p>
            </c:if>
            <div class="lista-horizontal">
                <c:forEach var="evento" items="${fui}">
                    <%@ include file="cartao-linha.jsp" %>
                </c:forEach>
            </div>

            <h2>Meus Favoritos</h2>
            <c:if test="${empty favoritos}">
                <p class="vazio">Você ainda não favoritou nenhum evento.</p>
            </c:if>
            <div class="lista-horizontal">
                <c:forEach var="evento" items="${favoritos}">
                    <%@ include file="cartao-linha.jsp" %>
                </c:forEach>
            </div>
        </div>
    </main>
    <script>
        var meses = ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'];
        var semana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
        var hoje = new Date();
        var ano = hoje.getFullYear();
        var mes = hoje.getMonth();
        var dias = document.getElementById('calendario-dias');

        document.getElementById('mes-atual').textContent = meses[mes] + ' ' + ano;

        function adicionarDia(texto, classe) {
            var dia = document.createElement('span');
            dia.textContent = texto;
            if (classe != '') {
                dia.className = classe;
            }
            dias.appendChild(dia);
        }

        for (var i = 0; i < semana.length; i++) {
            adicionarDia(semana[i], '');
        }

        var primeiroDia = (new Date(ano, mes, 1).getDay() + 6) % 7;
        var totalDeDias = new Date(ano, mes + 1, 0).getDate();

        for (var i = 0; i < primeiroDia; i++) {
            adicionarDia('', '');
        }

        for (var d = 1; d <= totalDeDias; d++) {
            if (d == hoje.getDate()) {
                adicionarDia(d, 'hoje');
            } else {
                adicionarDia(d, '');
            }
        }
    </script>
</body>
</html>
