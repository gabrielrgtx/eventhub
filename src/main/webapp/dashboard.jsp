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

    <c:if test="${not empty destaques and not somenteFavoritos}">
        <section class="destaques" aria-label="Eventos em destaque" aria-roledescription="carrossel">
            <div class="carrossel" id="carrossel">
                <c:forEach var="evento" items="${destaques}">
                    <article class="destaque-card">
                        <a class="destaque-imagem" href="/evento?id=${evento.id}" aria-label="<c:out value="${evento.nome}"/>">
                            <c:choose>
                                <c:when test="${not empty evento.imagens}">
                                    <img src="<c:out value="${evento.imagens[0].caminho}"/>" alt="">
                                </c:when>
                                <c:otherwise>
                                    <span class="card-imagem"></span>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <h3><a href="/evento?id=${evento.id}"><c:out value="${evento.nome}"/></a></h3>
                        <div class="destaque-meta">
                            <span class="etiqueta">${evento.dataFormatada}</span>
                            <span class="etiqueta"><c:out value="${evento.endereco.cidade}"/></span>
                            <%@ include file="coracao.jsp" %>
                        </div>
                    </article>
                </c:forEach>
            </div>
            <button class="carrossel-seta anterior" type="button" id="carrossel-anterior" aria-label="Evento anterior"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m15 5-7 7 7 7"/></svg></button>
            <button class="carrossel-seta proxima" type="button" id="carrossel-proximo" aria-label="Próximo evento"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m9 5 7 7-7 7"/></svg></button>
        </section>
    </c:if>

    <div class="home-fundo">
        <main class="container home-conteudo">
            <h2 class="faixa">${somenteFavoritos ? 'Seus favoritos' : 'Quer saber qual é o próximo rolê?'}</h2>
            <c:if test="${erroBusca}"><p class="mensagem" role="alert">Não foi possível carregar os eventos. Atualize a página para tentar novamente.</p></c:if>

            <div class="pilulas">
                <a class="pilula ${empty param.categoria and not somenteFavoritos ? 'ativa' : ''}" href="/listar-eventos">Todos</a>
                <c:if test="${not empty usuarioLogado}">
                    <a class="pilula ${somenteFavoritos ? 'ativa' : ''}" href="/listar-eventos?favoritos=1">Favoritos</a>
                </c:if>
                <c:forEach var="c" items="${categorias}">
                    <a class="pilula ${param.categoria == c.id ? 'ativa' : ''}" href="/listar-eventos?categoria=${c.id}"><c:out value="${c.nome}"/></a>
                </c:forEach>
            </div>

            <c:if test="${not somenteFavoritos}">
                <details class="busca-recolhida" ${not empty param.cidade or not empty param.data ? 'open' : ''}>
                    <summary>Filtrar por cidade ou data</summary>
                    <form class="busca" action="/listar-eventos" method="get">
                        <input type="hidden" name="nome" value="<c:out value="${param.nome}"/>">
                        <input type="hidden" name="categoria" value="<c:out value="${param.categoria}"/>">
                        <div class="campo">
                            <label for="filtro-cidade">Cidade</label>
                            <input type="text" name="cidade" id="filtro-cidade" value="<c:out value="${param.cidade}"/>">
                        </div>
                        <div class="campo">
                            <label for="filtro-data">Data</label>
                            <input type="date" name="data" id="filtro-data" value="<c:out value="${param.data}"/>">
                        </div>
                        <div class="busca-botoes">
                            <button class="botao" type="submit">Filtrar</button>
                            <a href="/listar-eventos">Limpar</a>
                        </div>
                    </form>
                </details>
            </c:if>

            <c:if test="${empty eventos and not erroBusca}">
                <c:choose>
                    <c:when test="${somenteFavoritos}"><p class="vazio">Você ainda não favoritou nenhum evento. Toque no coração de um evento para guardar ele aqui.</p></c:when>
                    <c:otherwise><p class="vazio">Nenhum evento encontrado.</p></c:otherwise>
                </c:choose>
            </c:if>
            <p class="vazio" id="busca-vazio" hidden>Nenhum evento com esse nome.</p>

            <div class="grade">
                <c:forEach var="evento" items="${eventos}">
                    <article class="card" id="evento-${evento.id}" data-nome="<c:out value="${evento.nome}"/>">
                        <a class="card-capa" href="/evento?id=${evento.id}" tabindex="-1" aria-hidden="true">
                            <c:choose>
                                <c:when test="${not empty evento.imagens}">
                                    <img class="card-imagem" src="<c:out value="${evento.imagens[0].caminho}"/>" alt="">
                                </c:when>
                                <c:otherwise>
                                    <span class="card-imagem"></span>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${evento.cancelado}"><span class="card-selo">Cancelado</span></c:when>
                                <c:when test="${evento.inscricoesEncerradas}"><span class="card-selo">Encerrado</span></c:when>
                                <c:when test="${evento.vagasRestantes <= 0}"><span class="card-selo">Esgotado</span></c:when>
                                <c:when test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}"><span class="card-selo seu">Seu evento</span></c:when>
                                <c:when test="${evento.inscrito}"><span class="card-selo seu">Inscrito</span></c:when>
                            </c:choose>
                        </a>
                        <a class="card-titulo" href="/evento?id=${evento.id}"><c:out value="${evento.nome}"/></a>
                        <div class="card-info">
                            <span>${evento.dataFormatada}</span>
                            <span><c:out value="${evento.endereco.cidade}"/></span>
                            <%@ include file="coracao.jsp" %>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </main>
    </div>

    <script>
        (function () {
            var carrossel = document.getElementById('carrossel');
            if (carrossel == null) {
                return;
            }
            var cards = carrossel.querySelectorAll('.destaque-card');
            var anterior = document.getElementById('carrossel-anterior');
            var proximo = document.getElementById('carrossel-proximo');
            var atual = 0;
            var timer = null;
            var inicioToque = null;
            var semAnimacao = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            function posicionar() {
                var total = cards.length;
                var largura = cards[0].offsetWidth;
                for (var i = 0; i < total; i++) {
                    var distancia = i - atual;
                    if (distancia > total / 2) {
                        distancia -= total;
                    }
                    if (distancia < -total / 2) {
                        distancia += total;
                    }
                    var escala = distancia == 0 ? 1 : 0.86;
                    cards[i].style.transform = 'translateX(' + (distancia * largura * 1.22) + 'px) scale(' + escala + ')';
                    cards[i].classList.toggle('ativo', distancia == 0);
                    cards[i].classList.toggle('escondido', Math.abs(distancia) > 1);
                    cards[i].setAttribute('aria-hidden', distancia == 0 ? 'false' : 'true');
                    var focaveis = cards[i].querySelectorAll('a, button');
                    for (var j = 0; j < focaveis.length; j++) {
                        if (distancia == 0) {
                            focaveis[j].removeAttribute('tabindex');
                        } else {
                            focaveis[j].setAttribute('tabindex', '-1');
                        }
                    }
                }
            }

            function irPara(indice) {
                atual = (indice + cards.length) % cards.length;
                posicionar();
            }

            function iniciar() {
                if (semAnimacao || cards.length < 2) {
                    return;
                }
                parar();
                timer = setInterval(function () {
                    irPara(atual + 1);
                }, 6000);
            }

            function parar() {
                if (timer != null) {
                    clearInterval(timer);
                    timer = null;
                }
            }

            if (cards.length < 2) {
                anterior.hidden = true;
                proximo.hidden = true;
            }

            anterior.addEventListener('click', function () {
                irPara(atual - 1);
                iniciar();
            });

            proximo.addEventListener('click', function () {
                irPara(atual + 1);
                iniciar();
            });

            carrossel.addEventListener('click', function (evento) {
                var card = evento.target.closest('.destaque-card');
                if (card != null && !card.classList.contains('ativo')) {
                    evento.preventDefault();
                    irPara(Array.prototype.indexOf.call(cards, card));
                    iniciar();
                }
            });

            carrossel.addEventListener('touchstart', function (evento) {
                inicioToque = evento.touches[0].clientX;
            }, { passive: true });

            carrossel.addEventListener('touchend', function (evento) {
                if (inicioToque == null) {
                    return;
                }
                var diferenca = evento.changedTouches[0].clientX - inicioToque;
                if (Math.abs(diferenca) > 40) {
                    irPara(diferenca < 0 ? atual + 1 : atual - 1);
                    iniciar();
                }
                inicioToque = null;
            });

            carrossel.parentNode.addEventListener('mouseenter', parar);
            carrossel.parentNode.addEventListener('mouseleave', iniciar);
            carrossel.parentNode.addEventListener('focusin', parar);
            carrossel.parentNode.addEventListener('focusout', iniciar);
            window.addEventListener('resize', posicionar);

            posicionar();
            carrossel.classList.add('pronto');
            iniciar();
        })();
    </script>
</body>
</html>
