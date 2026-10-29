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

        <c:choose>
            <c:when test="${param.retorno == 'presenca-confirmada'}"><p class="mensagem" role="status">Presença confirmada. A pessoa já pode avaliar o evento.</p></c:when>
            <c:when test="${param.retorno == 'presenca-nao-confirmada'}"><p class="mensagem" role="alert">Não foi possível confirmar a presença. Confira se a pessoa está inscrita e se o evento já aconteceu.</p></c:when>
        </c:choose>

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

            <c:forEach var="evento" items="${criados}">
                <details class="participantes" id="participantes-${evento.id}">
                    <summary>Inscritos em <c:out value="${evento.nome}"/></summary>
                    <c:choose>
                        <c:when test="${empty evento.inscritos}"><p class="vazio">Ainda não há inscritos neste evento.</p></c:when>
                        <c:otherwise>
                            <ul>
                                <c:forEach var="inscricao" items="${evento.inscritos}">
                                    <li><span><strong><c:out value="${inscricao.usuario.nome}"/></strong> @<c:out value="${inscricao.usuario.usuario}"/></span>
                                        <c:choose>
                                            <c:when test="${inscricao.presencaConfirmada}"><span class="status-presenca">Presença confirmada</span></c:when>
                                            <c:when test="${evento.presencaLiberada}"><form action="/inscricao" method="post"><input type="hidden" name="acao" value="confirmar-presenca"><input type="hidden" name="eventoId" value="${evento.id}"><input type="hidden" name="usuarioId" value="${inscricao.usuario.id}"><button class="botao pequeno claro" type="submit">Confirmar presença</button></form></c:when>
                                            <c:otherwise><span class="vazio">Aguardando o evento</span></c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </details>
            </c:forEach>

            <h2>Aguardando confirmação de presença</h2>
            <c:if test="${empty aguardandoPresenca}"><p class="vazio">Nenhuma presença pendente.</p></c:if>
            <div class="lista-horizontal"><c:forEach var="evento" items="${aguardandoPresenca}"><%@ include file="cartao-linha.jsp" %></c:forEach></div>

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
