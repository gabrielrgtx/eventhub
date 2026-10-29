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
        <c:choose>
            <c:when test="${param.retorno == 'foto'}"><p class="mensagem" role="status">Foto de perfil atualizada.</p></c:when>
            <c:when test="${param.erro == 'foto'}"><p class="mensagem" role="alert">Não foi possível usar essa foto. Envie uma imagem JPG, PNG, WEBP ou GIF de até 5 MB.</p></c:when>
        </c:choose>
        <div class="perfil-cabeca">
            <c:choose>
                <c:when test="${proprioPerfil}">
                    <form class="avatar-form" action="/editar-perfil" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="acao" value="foto">
                        <label class="avatar-trocar" for="avatar-arquivo">
                            <c:choose>
                                <c:when test="${not empty perfil.foto}">
                                    <img class="avatar" src="<c:out value="${perfil.foto}"/>" alt="">
                                </c:when>
                                <c:otherwise>
                                    <span class="avatar avatar-padrao"><svg viewBox="0 0 100 100" aria-hidden="true"><circle cx="50" cy="36" r="19"/><path d="M14 99c3-24 18-37 36-37s33 13 36 37"/></svg></span>
                                </c:otherwise>
                            </c:choose>
                            <span class="avatar-camera" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M4 8h3l2-3h6l2 3h3v11H4Z"/><circle cx="12" cy="13" r="3.5"/></svg></span>
                            <span class="acessivel">${empty perfil.foto ? 'Adicionar foto de perfil' : 'Trocar foto de perfil'}</span>
                        </label>
                        <input class="acessivel" type="file" id="avatar-arquivo" name="foto-arquivo" accept="image/jpeg,image/png,image/webp,image/gif">
                    </form>
                </c:when>
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
                <c:if test="${proprioPerfil}">
                    <a href="/editar-perfil" title="Editar perfil" aria-label="Editar perfil"><svg viewBox="0 0 24 24" width="25" height="25" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="m4 17-1 4 4-1L20 7l-3-3Z"/></svg></a>
                </c:if>
            </div>
        </div>

        <section class="perfil-secao">
            <div class="perfil-faixa-linha">
                <h2 class="faixa escura">Eventos</h2>
                <c:if test="${proprioPerfil}">
                    <a class="botao" href="/novo-evento">Criar evento +</a>
                </c:if>
            </div>
            <c:if test="${empty eventos}">
                <p class="vazio perfil-vazio">Nenhum evento publicado.</p>
            </c:if>
            <c:if test="${not empty eventos}">
                <div class="perfil-eventos">
                    <button class="perfil-seta anterior" type="button" aria-label="Eventos anteriores" hidden><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m15 5-7 7 7 7"/></svg></button>
                    <div class="perfil-carrossel" id="perfil-carrossel">
                        <c:forEach var="evento" items="${eventos}">
                            <article class="card" id="evento-${evento.id}">
                                <a class="card-capa" href="/evento?id=${evento.id}" tabindex="-1" aria-hidden="true">
                                    <c:choose>
                                        <c:when test="${not empty evento.imagens}">
                                            <img class="card-imagem" src="<c:out value="${evento.imagens[0].caminho}"/>" alt="">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="card-imagem"></span>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${evento.cancelado}"><span class="card-selo">Cancelado</span></c:if>
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
                    <button class="perfil-seta proxima" type="button" aria-label="Próximos eventos" hidden><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m9 5 7 7-7 7"/></svg></button>
                </div>
            </c:if>
        </section>

        <section class="perfil-secao">
            <h2 class="faixa escura">Comentários</h2>
            <c:if test="${empty avaliacoes}">
                <p class="vazio perfil-vazio">Nenhum comentário feito ainda.</p>
            </c:if>
            <c:forEach var="avaliacao" items="${avaliacoes}">
                <article class="perfil-comentario">
                    <a class="card" href="/evento?id=${avaliacao.evento.id}">
                        <c:choose>
                            <c:when test="${not empty avaliacao.evento.imagens}">
                                <img class="card-imagem" src="<c:out value="${avaliacao.evento.imagens[0].caminho}"/>" alt="">
                            </c:when>
                            <c:otherwise>
                                <span class="card-imagem"></span>
                            </c:otherwise>
                        </c:choose>
                        <span class="card-titulo"><c:out value="${avaliacao.evento.nome}"/></span>
                        <span class="card-info">
                            <span>${avaliacao.evento.dataFormatada}</span>
                            <span><c:out value="${avaliacao.evento.endereco.cidade}"/></span>
                        </span>
                    </a>
                    <div class="comentario">
                        <div class="comentario-autor">
                            <c:choose>
                                <c:when test="${not empty perfil.foto}"><img class="comentario-avatar" src="<c:out value="${perfil.foto}"/>" alt=""></c:when>
                                <c:otherwise><span class="comentario-avatar"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M8 14c2 3 6 3 8 0M9 9h.01M15 9h.01"/></svg></span></c:otherwise>
                            </c:choose>
                            <div><strong><c:out value="${perfil.nome}"/></strong><small>@<c:out value="${perfil.usuario}"/></small></div>
                        </div>
                        <p class="comentario-texto"><c:out value="${avaliacao.comentario}"/></p>
                        <span class="estrelas" aria-label="Nota ${avaliacao.nota} de 5">
                            <c:forEach var="i" items="1,2,3,4,5">
                                <svg viewBox="0 0 24 24" width="30" height="30" stroke="currentColor" stroke-width="2" fill="${i <= avaliacao.nota ? 'currentColor' : 'none'}" aria-hidden="true"><path d="m12 2 3.1 6.3 7 1-5.1 5 .9 7-5.9-3.3-5.9 3.3.9-7-5.1-5 7-1Z"/></svg>
                            </c:forEach>
                        </span>
                    </div>
                </article>
            </c:forEach>
        </section>
    </main>
    <script>
        (function () {
            var arquivo = document.getElementById('avatar-arquivo');
            if (arquivo != null) {
                arquivo.addEventListener('change', function () {
                    if (arquivo.files.length == 0) {
                        return;
                    }
                    if (arquivo.files[0].size > 5 * 1024 * 1024) {
                        alert('A foto precisa ter no máximo 5 MB.');
                        arquivo.value = '';
                        return;
                    }
                    arquivo.form.submit();
                });
            }

            var carrossel = document.getElementById('perfil-carrossel');
            if (carrossel == null) {
                return;
            }
            var anterior = carrossel.parentNode.querySelector('.anterior');
            var proxima = carrossel.parentNode.querySelector('.proxima');

            function atualizarSetas() {
                var sobra = carrossel.scrollWidth - carrossel.clientWidth;
                anterior.hidden = carrossel.scrollLeft <= 4;
                proxima.hidden = carrossel.scrollLeft >= sobra - 4;
            }

            function passo() {
                var card = carrossel.querySelector('.card');
                return card.offsetWidth + parseInt(getComputedStyle(carrossel).columnGap, 10);
            }

            anterior.addEventListener('click', function () {
                carrossel.scrollBy({ left: -passo(), behavior: 'smooth' });
            });

            proxima.addEventListener('click', function () {
                carrossel.scrollBy({ left: passo(), behavior: 'smooth' });
            });

            carrossel.addEventListener('scroll', atualizarSetas);
            window.addEventListener('resize', atualizarSetas);
            atualizarSetas();
        })();
    </script>
</body>
</html>
