<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Eventos</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <c:if test="${not empty destaques}">
    <section class="destaques"><div class="destaques-trilho">
        <c:forEach var="evento" items="${destaques}"><article class="destaque-card">
            <a href="/evento?id=${evento.id}"><c:choose><c:when test="${not empty evento.imagens}"><img src="<c:out value="${evento.imagens[0].caminho}"/>" alt=""></c:when><c:otherwise><span class="card-imagem"></span></c:otherwise></c:choose></a>
            <h3><c:out value="${evento.nome}"/></h3><div class="destaque-meta"><span class="etiqueta">${evento.data}</span><span class="etiqueta"><c:out value="${evento.endereco.cidade}"/></span><svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="#a32928" stroke-width="2"><path d="M12 21 3 12C-3 5 6-2 12 5c6-7 15 0 9 7Z"/></svg></div>
        </article></c:forEach>
    </div></section>
    </c:if>
    <main class="container home-conteudo">
        <h2 class="faixa">Quer saber qual é o próximo rolê?</h2>

        <div class="pilulas">
            <a class="pilula ${empty param.categoria ? 'ativa' : ''}" href="/listar-eventos">Todos</a>
            <c:forEach var="c" items="${categorias}">
                <a class="pilula ${param.categoria == c.id ? 'ativa' : ''}" href="/listar-eventos?categoria=${c.id}"><c:out value="${c.nome}"/></a>
            </c:forEach>
        </div>

        <details class="busca-recolhida" id="busca"><summary>Buscar eventos</summary><form class="caixa busca" action="/listar-eventos" method="get">
            <div>
                <label>Nome</label>
                <input type="text" name="nome" value="<c:out value="${param.nome}"/>">
            </div>
            <div>
                <label>Categoria</label>
                <select name="categoria">
                    <option value="">Todas</option>
                    <c:forEach var="c" items="${categorias}">
                        <option value="${c.id}" ${param.categoria == c.id ? 'selected' : ''}><c:out value="${c.nome}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label>Cidade</label>
                <input type="text" name="cidade" value="<c:out value="${param.cidade}"/>">
            </div>
            <div>
                <label>Data</label>
                <input type="date" name="data" value="<c:out value="${param.data}"/>">
            </div>
            <div>
                <button class="botao" type="submit">Buscar</button>
                <a href="/listar-eventos">Limpar</a>
            </div>
        </form></details>

        <c:if test="${empty eventos}">
            <p class="vazio">Nenhum evento encontrado.</p>
        </c:if>

        <div class="grade">
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
                    <div class="card-acoes">
                        <c:choose>
                            <c:when test="${empty usuarioLogado}">
                                <a class="botao pequeno" href="/login">Entre para se inscrever</a>
                            </c:when>
                            <c:when test="${evento.inscrito}">
                                <form action="/inscricao" method="post">
                                    <input type="hidden" name="acao" value="cancelar">
                                    <input type="hidden" name="eventoId" value="${evento.id}">
                                    <button class="botao pequeno claro" type="submit">Cancelar inscrição</button>
                                </form>
                            </c:when>
                            <c:when test="${evento.cancelado}">
                                <span class="status">Cancelado</span>
                            </c:when>
                            <c:when test="${evento.vagasRestantes <= 0}">
                                <span class="status">Esgotado</span>
                            </c:when>
                            <c:otherwise>
                                <form action="/inscricao" method="post">
                                    <input type="hidden" name="acao" value="inscrever">
                                    <input type="hidden" name="eventoId" value="${evento.id}">
                                    <button class="botao pequeno" type="submit">Inscrever-se</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}">
                            <a class="botao pequeno claro" href="/editar-evento?id=${evento.id}">Editar</a>
                            <c:if test="${not evento.cancelado}">
                                <form action="/cancelar-evento" method="post">
                                    <input type="hidden" name="id" value="${evento.id}">
                                    <button class="botao pequeno claro" type="submit">Cancelar</button>
                                </form>
                            </c:if>
                            <form action="/delete-event" method="post" onsubmit="return confirm('Excluir este evento?');">
                                <input type="hidden" name="id" value="${evento.id}">
                                <button class="botao pequeno perigo" type="submit">Excluir</button>
                            </form>
                        </c:if>
                    </div>
                </article>
            </c:forEach>
        </div>
    </main>
    <script>
        var trilho = document.querySelector('.destaques-trilho');

        function marcarCardDoCentro() {
            var cards = document.querySelectorAll('.destaque-card');
            var centro = trilho.scrollLeft + trilho.clientWidth / 2;
            for (var i = 0; i < cards.length; i++) {
                var meioDoCard = cards[i].offsetLeft + cards[i].clientWidth / 2;
                if (Math.abs(meioDoCard - centro) < cards[i].clientWidth / 2) {
                    cards[i].classList.add('ativo');
                } else {
                    cards[i].classList.remove('ativo');
                }
            }
        }

        if (trilho != null) {
            var primeiro = document.querySelector('.destaque-card');
            trilho.scrollLeft = primeiro.offsetLeft - (trilho.clientWidth - primeiro.clientWidth) / 2;
            marcarCardDoCentro();
            trilho.addEventListener('scroll', marcarCardDoCentro);
        }
    </script>
</body>
</html>
