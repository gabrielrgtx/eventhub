<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${perfil.nome}"/></title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <div class="linhas container" style="padding-bottom: 0;"><span></span><span></span></div>
    <div class="perfil-capa"></div>
    <main class="container">
        <div class="perfil-cabeca">
            <c:choose>
                <c:when test="${not empty perfil.foto}">
                    <img class="avatar" src="<c:out value="${perfil.foto}"/>" alt="">
                </c:when>
                <c:otherwise>
                    <span class="avatar avatar-padrao"><svg viewBox="0 0 100 100" aria-hidden="true"><circle cx="50" cy="36" r="19"/><path d="M14 99c3-24 18-37 36-37s33 13 36 37"/></svg></span>
                </c:otherwise>
            </c:choose>
            <h1><c:out value="${perfil.nome}"/></h1>
            <div class="arroba">
                @<c:out value="${perfil.usuario}"/>
                <c:if test="${not empty usuarioLogado and usuarioLogado.id == perfil.id}">
                    <a href="/perfil" title="Editar perfil"><svg viewBox="0 0 24 24" width="25" height="25" fill="none" stroke="currentColor" stroke-width="2"><path d="m4 17-1 4 4-1L20 7l-3-3Z"/></svg></a>
                </c:if>
            </div>
        </div>

        <section class="perfil-secao"><div class="perfil-faixa-linha"><h2 class="faixa escura">Eventos</h2>
        <c:if test="${not empty usuarioLogado and usuarioLogado.id == perfil.id}">
            <p><a class="botao" href="/novo-evento">Criar evento +</a></p>
        </c:if>
        </div>
        <c:if test="${empty eventos}">
            <p class="vazio">Nenhum evento publicado.</p>
        </c:if>
        <div class="perfil-carrossel">
            <c:forEach var="evento" items="${eventos}">
                <article class="card">
                    <a href="/evento?id=${evento.id}">
                        <c:choose>
                            <c:when test="${not empty evento.imagens}">
                                <img class="card-imagem" src="<c:out value="${evento.imagens[0].caminho}"/>" alt="">
                            </c:when>
                            <c:otherwise>
                                <span class="card-imagem"></span>
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <a class="card-titulo" href="/evento?id=${evento.id}"><c:out value="${evento.nome}"/></a>
                    <div class="card-info">
                        <span>${evento.data}</span>
                        <span><c:out value="${evento.endereco.cidade}"/></span>
                        <c:choose><c:when test="${empty usuarioLogado}"><a class="card-coracao" href="/login" aria-label="Entrar para favoritar"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 21 3 12C-3 5 6-2 12 5c6-7 15 0 9 7Z"/></svg></a></c:when><c:otherwise><form class="coracao-form" action="/favorito" method="post"><input type="hidden" name="eventoId" value="${evento.id}"><input type="hidden" name="acao" value="${evento.favoritado ? 'desfavoritar' : 'favoritar'}"><button class="card-coracao ${evento.favoritado ? 'favoritado' : ''}" type="submit" aria-label="${evento.favoritado ? 'Desfavoritar evento' : 'Favoritar evento'}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 21 3 12C-3 5 6-2 12 5c6-7 15 0 9 7Z"/></svg></button></form></c:otherwise></c:choose>
                    </div>
                    <c:if test="${evento.cancelado}">
                        <span class="status">Cancelado</span>
                    </c:if>
                </article>
            </c:forEach>
        </div>
        <button class="perfil-proximo" type="button" aria-label="Próximos eventos" onclick="proximosEventos(this)">›</button>
        </section>

        <section class="perfil-secao"><h2 class="faixa escura">Comentários</h2>
        <c:if test="${empty avaliacoes}">
            <p class="vazio">Nenhuma avaliação feita.</p>
        </c:if>
        <c:forEach var="avaliacao" items="${avaliacoes}">
            <div class="perfil-comentario"><div class="card"><a class="card-titulo" href="/evento?id=${avaliacao.evento.id}"><c:out value="${avaliacao.evento.nome}"/></a></div><div class="comentario">
                <div class="comentario-topo">
                    <a href="/evento?id=${avaliacao.evento.id}"><c:out value="${avaliacao.evento.nome}"/></a>
                    <span class="estrelas">
                        <c:forEach var="i" items="1,2,3,4,5">
                            <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="${i <= avaliacao.nota ? 'currentColor' : 'none'}" aria-hidden="true"><path d="m12 2 3.1 6.3 7 1-5.1 5 .9 7-5.9-3.3-5.9 3.3.9-7-5.1-5 7-1Z"/></svg>
                        </c:forEach>
                    </span>
                </div>
                <p><c:out value="${avaliacao.comentario}"/></p>
            </div></div>
        </c:forEach>
        </section>
    </main>
    <script>
        function proximosEventos(botao) {
            var carrossel = botao.previousElementSibling;
            carrossel.scrollLeft = carrossel.scrollLeft + 355;
        }
    </script>
</body>
</html>
