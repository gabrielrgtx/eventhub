<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${evento.nome}"/></title>
    <link rel="stylesheet" href="/css/style.css?v=2">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <c:set var="iconeSucesso"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m5 12 5 5L20 7"/></svg></c:set>
    <c:set var="iconeAviso"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5.5M12 16.5h.01"/></svg></c:set>
    <main class="ev-pagina">
        <c:choose>
            <c:when test="${param.retorno == 'evento-publicado'}"><p class="ev-mensagem" role="status">${iconeSucesso}Evento publicado com sucesso.</p></c:when>
            <c:when test="${param.retorno == 'evento-atualizado'}"><p class="ev-mensagem" role="status">${iconeSucesso}Evento atualizado com sucesso.</p></c:when>
            <c:when test="${param.retorno == 'inscricao-confirmada'}"><p class="ev-mensagem" role="status">${iconeSucesso}Inscrição confirmada! Você encontra este evento no seu painel.</p></c:when>
            <c:when test="${param.retorno == 'inscricao-cancelada'}"><p class="ev-mensagem" role="status">${iconeSucesso}Sua inscrição foi cancelada.</p></c:when>
            <c:when test="${param.retorno == 'ja-inscrito'}"><p class="ev-mensagem" role="status">${iconeSucesso}Você já está inscrito neste evento.</p></c:when>
            <c:when test="${param.retorno == 'nao-inscrito'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Não encontramos uma inscrição sua para cancelar.</p></c:when>
            <c:when test="${param.retorno == 'vagas-esgotadas'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}As vagas acabaram antes da sua inscrição.</p></c:when>
            <c:when test="${param.retorno == 'inscricoes-encerradas'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}As inscrições e cancelamentos foram encerrados porque o evento começou.</p></c:when>
            <c:when test="${param.retorno == 'evento-proprio'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Você não pode se inscrever no evento que criou.</p></c:when>
            <c:when test="${param.retorno == 'evento-indisponivel'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Este evento não está disponível para inscrição.</p></c:when>
            <c:when test="${param.retorno == 'falha-inscricao'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Não foi possível concluir a ação. Tente novamente.</p></c:when>
        </c:choose>

        <section class="ev-hero">
            <div class="ev-coluna ev-midia">
                <c:choose>
                    <c:when test="${not empty evento.imagens}">
                        <div class="ev-galeria-caixa">
                            <div class="ev-galeria" id="ev-galeria">
                                <c:forEach var="img" items="${evento.imagens}">
                                    <img src="<c:out value="${img.caminho}"/>" alt="">
                                </c:forEach>
                            </div>
                            <c:if test="${not empty evento.imagens[1]}"><button type="button" class="ev-galeria-proxima" aria-label="Próxima imagem" onclick="proximaImagem(this)"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m9 5 7 7-7 7"/></svg></button></c:if>
                        </div>
                        <c:if test="${not empty evento.imagens[1]}">
                            <div class="ev-miniaturas">
                                <c:forEach var="img" items="${evento.imagens}" varStatus="posicao">
                                    <button type="button" class="ev-miniatura ${posicao.first ? 'ativa' : ''}" aria-label="Ver imagem ${posicao.count}" onclick="mostrarImagem(${posicao.index})"><img src="<c:out value="${img.caminho}"/>" alt=""></button>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="ev-sem-imagem">
                            <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="4" width="18" height="16" rx="3"/><circle cx="9" cy="10" r="2"/><path d="m21 16-5-5-9 9"/></svg>
                            <strong>Este evento ainda não tem imagens</strong>
                            <c:if test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}">
                                <a href="/editar-evento?id=${evento.id}">Adicionar imagens</a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="ev-coluna ev-lateral">
                <div class="ev-cartao">
                    <c:if test="${not empty evento.categorias}">
                        <div class="ev-categorias">
                            <c:forEach var="categoria" items="${evento.categorias}">
                                <span class="ev-categoria"><c:out value="${categoria.nome}"/></span>
                            </c:forEach>
                        </div>
                    </c:if>

                    <div class="ev-titulo">
                        <h1><c:out value="${evento.nome}"/></h1>
                        <c:if test="${evento.cancelado}">
                            <p class="ev-cancelado">Evento cancelado</p>
                        </c:if>
                        <p class="ev-criador">
                            <span class="ev-avatar ev-avatar-pequeno" aria-hidden="true">${fn:toUpperCase(fn:substring(evento.criador.nome, 0, 1))}</span>
                            Criado por <a href="/perfil?id=${evento.criador.id}"><c:out value="${evento.criador.nome}"/></a>
                        </p>
                    </div>

                    <div class="ev-divisor"></div>

                    <ul class="ev-dados">
                        <li>
                            <span class="ev-dado-icone"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="5" width="18" height="16" rx="3"/><path d="M8 3v4M16 3v4M3 10h18"/></svg></span>
                            <span class="ev-dado-texto"><strong>${fn:substring(evento.data, 8, 10)}/${fn:substring(evento.data, 5, 7)}/${fn:substring(evento.data, 0, 4)}</strong></span>
                        </li>
                        <li>
                            <span class="ev-dado-icone"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span>
                            <span class="ev-dado-texto"><strong>${evento.inicio}<c:if test="${not empty evento.fim}"> às ${evento.fim}</c:if></strong></span>
                        </li>
                        <li>
                            <span class="ev-dado-icone"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 21s7-6 7-12a7 7 0 1 0-14 0c0 6 7 12 7 12Z"/><circle cx="12" cy="9" r="2.5"/></svg></span>
                            <span class="ev-dado-texto"><strong><c:out value="${evento.endereco.cidade}"/>, <c:out value="${evento.endereco.estado}"/></strong><small><c:out value="${evento.endereco.rua}"/>, <c:out value="${evento.endereco.numero}"/> - <c:out value="${evento.endereco.bairro}"/></small></span>
                        </li>
                    </ul>

                    <c:if test="${not evento.inscricoesEncerradas and not evento.cancelado}">
                        <c:choose>
                            <c:when test="${vagasRestantes <= 0}"><p class="ev-esgotado">Esgotado</p></c:when>
                            <c:otherwise>
                                <c:if test="${evento.vagas > 0}">
                                    <div class="ev-vagas">
                                        <div class="ev-vagas-texto"><strong>${vagasRestantes} vagas restantes</strong><span>${evento.vagas - vagasRestantes} de ${evento.vagas} inscritos</span></div>
                                        <div class="ev-vagas-trilho"><div class="ev-vagas-barra" style="width: ${(evento.vagas - vagasRestantes) * 100 / evento.vagas}%"></div></div>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <div class="ev-acoes">
                        <c:choose>
                            <c:when test="${evento.cancelado}"><span class="ev-status">Evento cancelado</span></c:when>
                            <c:when test="${evento.inscricoesEncerradas}"><span class="ev-status">Inscrições encerradas</span></c:when>
                            <c:when test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}"><span class="ev-status"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m5 12 5 5L20 7"/></svg>Você criou este evento</span></c:when>
                            <c:when test="${empty usuarioLogado}">
                                <a class="ev-botao" href="/login">Entre para se inscrever</a>
                            </c:when>
                            <c:when test="${inscrito}">
                                <form action="/inscricao" method="post">
                                    <input type="hidden" name="eventoId" value="${evento.id}">
                                    <input type="hidden" name="acao" value="cancelar">
                                    <button class="ev-botao-contorno" type="submit">Cancelar inscrição</button>
                                </form>
                            </c:when>
                            <c:when test="${not evento.cancelado and vagasRestantes > 0}">
                                <form class="ev-form-principal" action="/inscricao" method="post">
                                    <input type="hidden" name="eventoId" value="${evento.id}">
                                    <input type="hidden" name="acao" value="inscrever">
                                    <button class="ev-botao" type="submit">Inscreva-se</button>
                                </form>
                            </c:when>
                        </c:choose>

                        <c:if test="${not empty usuarioLogado}">
                            <c:choose>
                                <c:when test="${favoritado}">
                                    <form action="/favorito" method="post">
                                        <input type="hidden" name="eventoId" value="${evento.id}">
                                        <input type="hidden" name="acao" value="desfavoritar">
                                        <button class="ev-botao-contorno" type="submit"><svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 20s-8-5-8-11a4.5 4.5 0 0 1 8-2.8A4.5 4.5 0 0 1 20 9c0 6-8 11-8 11Z"/></svg>Desfavoritar</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="/favorito" method="post">
                                        <input type="hidden" name="eventoId" value="${evento.id}">
                                        <input type="hidden" name="acao" value="favoritar">
                                        <button class="ev-botao-contorno" type="submit"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 20s-8-5-8-11a4.5 4.5 0 0 1 8-2.8A4.5 4.5 0 0 1 20 9c0 6-8 11-8 11Z"/></svg>Favoritar</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </div>

                <c:if test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}">
                    <div class="ev-gerenciar">
                        <strong class="ev-gerenciar-titulo">Gerenciar evento</strong>
                        <div class="ev-gerenciar-botoes">
                            <a class="ev-botao-gerenciar" href="/editar-evento?id=${evento.id}"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg>Editar</a>
                            <c:if test="${not evento.cancelado}">
                                <form action="/cancelar-evento" method="post" onsubmit="return confirm('Cancelar este evento? As pessoas inscritas vão ver o evento como cancelado.');">
                                    <input type="hidden" name="id" value="${evento.id}">
                                    <button class="ev-botao-gerenciar" type="submit"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="m5.6 5.6 12.8 12.8"/></svg>Cancelar evento</button>
                                </form>
                            </c:if>
                            <form class="ev-form-excluir" action="/delete-event" method="post" onsubmit="return confirm('Excluir este evento? Essa ação não pode ser desfeita.');">
                                <input type="hidden" name="id" value="${evento.id}">
                                <button class="ev-botao-gerenciar ev-botao-excluir" type="submit"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13M10 11v6M14 11v6"/></svg>Excluir</button>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>

        <section class="ev-sobre">
            <div class="ev-sobre-texto">
                <h2>Sobre o evento</h2>
                <p><c:out value="${evento.sobre}"/></p>
            </div>
            <div class="ev-local">
                <div class="ev-mapa"><svg viewBox="0 0 24 24" width="44" height="44" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 21s7-6 7-12a7 7 0 1 0-14 0c0 6 7 12 7 12Z"/><circle cx="12" cy="9" r="2.5"/></svg></div>
                <div class="ev-endereco">
                    <strong><c:out value="${evento.endereco.rua}"/>, <c:out value="${evento.endereco.numero}"/></strong>
                    <span><c:out value="${evento.endereco.bairro}"/>, <c:out value="${evento.endereco.cidade}"/> - <c:out value="${evento.endereco.estado}"/></span>
                    <c:if test="${not empty evento.endereco.cep}"><span>CEP <c:out value="${evento.endereco.cep}"/></span></c:if>
                </div>
                <button type="button" class="ev-botao-contorno ev-compartilhar" onclick="copiarLink()"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="18" cy="5" r="2.5"/><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="19" r="2.5"/><path d="m8.2 10.8 7.6-4.4M8.2 13.2l7.6 4.4"/></svg>Compartilhar evento</button>
            </div>
        </section>

        <div class="comentarios-lista ev-comentarios">
        <div class="ev-comentarios-topo">
            <h2>Comentários</h2>
            <c:if test="${not empty avaliacoes}">
                <c:set var="somaNotas" value="0"/>
                <c:forEach var="avaliacao" items="${avaliacoes}"><c:set var="somaNotas" value="${somaNotas + avaliacao.nota}"/></c:forEach>
                <span class="ev-media"><svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linejoin="round" aria-hidden="true"><path d="m12 2 3.1 6.3 7 1-5.1 5 .9 7-5.9-3.3-5.9 3.3.9-7-5.1-5 7-1Z"/></svg><strong><fmt:formatNumber value="${somaNotas / fn:length(avaliacoes)}" maxFractionDigits="1" minFractionDigits="1"/></strong> · ${fn:length(avaliacoes)} ${fn:length(avaliacoes) == 1 ? 'avaliação' : 'avaliações'}</span>
            </c:if>
        </div>
        <p class="vazio">Um pouco do que andam falando por aí</p>
        <c:if test="${inscrito and evento.presencaLiberada and not presencaConfirmada}"><p class="vazio">Sua avaliação fica disponível após o organizador confirmar sua presença.</p></c:if>
        <c:choose>
            <c:when test="${param.erro == 'ja-avaliou'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Você já avaliou este evento. Para mudar, edite a sua avaliação abaixo.</p></c:when>
            <c:when test="${param.erro == 'presenca-nao-confirmada'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Só quem teve a presença confirmada pelo organizador pode avaliar.</p></c:when>
            <c:when test="${param.erro == 'evento-nao-realizado'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Este evento ainda não aconteceu. A avaliação abre depois da data do evento.</p></c:when>
            <c:when test="${param.erro == 'nota-invalida'}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Escolha uma nota de 1 a 5 estrelas.</p></c:when>
            <c:when test="${not empty param.erro}"><p class="ev-mensagem ev-mensagem-aviso" role="alert">${iconeAviso}Não foi possível registrar a avaliação. Tente novamente.</p></c:when>
        </c:choose>

        <c:if test="${podeAvaliar}">
            <form class="comentario" action="/avaliacao" method="post">
                <input type="hidden" name="eventoId" value="${evento.id}">
                <input type="hidden" name="acao" value="criar">
                <div class="comentario-topo">
                    <div class="comentario-autor"><span class="comentario-avatar"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M8 14c2 3 6 3 8 0M9 9h.01M15 9h.01"/></svg></span><div><strong><c:out value="${usuarioLogado.nome}"/></strong><small>@<c:out value="${usuarioLogado.usuario}"/></small></div></div>
                    <select name="nota" style="width: auto;">
                        <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733;</option>
                        <option value="4">&#9733;&#9733;&#9733;&#9733;&#9734;</option>
                        <option value="3">&#9733;&#9733;&#9733;&#9734;&#9734;</option>
                        <option value="2">&#9733;&#9733;&#9734;&#9734;&#9734;</option>
                        <option value="1">&#9733;&#9734;&#9734;&#9734;&#9734;</option>
                    </select>
                </div>
                <div class="campo">
                    <textarea name="comentario" maxlength="1000" placeholder="Adicione aqui seu comentário sobre esse rolê..."></textarea>
                </div>
                <button class="botao pequeno" type="submit">Avaliar</button>
            </form>
        </c:if>

        <c:if test="${empty avaliacoes}">
            <p class="vazio">Nenhuma avaliação ainda.</p>
        </c:if>
        <c:forEach var="avaliacao" items="${avaliacoes}">
            <div class="ev-comentario">
                <div class="ev-comentario-topo">
                    <div class="ev-comentario-autor">
                        <c:choose>
                            <c:when test="${not empty avaliacao.usuario.foto}"><img class="ev-avatar" src="<c:out value="${avaliacao.usuario.foto}"/>" alt=""></c:when>
                            <c:otherwise><span class="ev-avatar" aria-hidden="true">${fn:toUpperCase(fn:substring(avaliacao.usuario.nome, 0, 1))}</span></c:otherwise>
                        </c:choose>
                        <div><a href="/perfil?id=${avaliacao.usuario.id}"><c:out value="${avaliacao.usuario.nome}"/></a><small>@<c:out value="${avaliacao.usuario.usuario}"/></small></div>
                    </div>
                    <span class="ev-estrelas" aria-label="${avaliacao.nota} de 5 estrelas">
                        <c:forEach var="i" items="1,2,3,4,5">
                            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" stroke-linejoin="round" fill="${i <= avaliacao.nota ? 'currentColor' : 'none'}" aria-hidden="true"><path d="m12 2 3.1 6.3 7 1-5.1 5 .9 7-5.9-3.3-5.9 3.3.9-7-5.1-5 7-1Z"/></svg>
                        </c:forEach>
                    </span>
                </div>
                <p><c:out value="${avaliacao.comentario}"/></p>
                <c:if test="${not empty usuarioLogado and usuarioLogado.id == avaliacao.usuario.id}">
                    <details class="editar-avaliacao"><summary>Editar minha avaliação</summary>
                    <form action="/avaliacao" method="post">
                        <input type="hidden" name="eventoId" value="${evento.id}">
                        <input type="hidden" name="avaliacaoId" value="${avaliacao.id}">
                        <input type="hidden" name="acao" value="editar">
                        <div class="campo">
                            <select name="nota" style="width: auto;">
                                <option value="5" ${avaliacao.nota == 5 ? 'selected' : ''}>&#9733;&#9733;&#9733;&#9733;&#9733;</option>
                                <option value="4" ${avaliacao.nota == 4 ? 'selected' : ''}>&#9733;&#9733;&#9733;&#9733;&#9734;</option>
                                <option value="3" ${avaliacao.nota == 3 ? 'selected' : ''}>&#9733;&#9733;&#9733;&#9734;&#9734;</option>
                                <option value="2" ${avaliacao.nota == 2 ? 'selected' : ''}>&#9733;&#9733;&#9734;&#9734;&#9734;</option>
                                <option value="1" ${avaliacao.nota == 1 ? 'selected' : ''}>&#9733;&#9734;&#9734;&#9734;&#9734;</option>
                            </select>
                        </div>
                        <div class="campo">
                            <textarea name="comentario" maxlength="1000"><c:out value="${avaliacao.comentario}"/></textarea>
                        </div>
                        <button class="botao pequeno" type="submit">Salvar alteração</button>
                    </form>
                    </details>
                    <form action="/avaliacao" method="post" style="margin-top: 8px;">
                        <input type="hidden" name="eventoId" value="${evento.id}">
                        <input type="hidden" name="avaliacaoId" value="${avaliacao.id}">
                        <input type="hidden" name="acao" value="excluir">
                        <button class="botao pequeno perigo" type="submit">Excluir minha avaliação</button>
                    </form>
                </c:if>
            </div>
        </c:forEach>
        </div>
    </main>
    <script>
        function proximaImagem(botao) {
            var galeria = botao.previousElementSibling;
            galeria.scrollLeft = galeria.scrollLeft + galeria.clientWidth;
        }

        function mostrarImagem(indice) {
            var galeria = document.getElementById('ev-galeria');
            galeria.scrollTo({ left: galeria.clientWidth * indice, behavior: 'smooth' });
            var miniaturas = document.querySelectorAll('.ev-miniatura');
            for (var i = 0; i < miniaturas.length; i++) {
                miniaturas[i].classList.toggle('ativa', i == indice);
            }
        }

        function marcarMiniatura() {
            var galeria = document.getElementById('ev-galeria');
            var miniaturas = document.querySelectorAll('.ev-miniatura');
            var atual = Math.round(galeria.scrollLeft / galeria.clientWidth);
            for (var i = 0; i < miniaturas.length; i++) {
                miniaturas[i].classList.toggle('ativa', i == atual);
            }
        }

        if (document.getElementById('ev-galeria') != null) {
            document.getElementById('ev-galeria').addEventListener('scroll', marcarMiniatura);
        }

        function copiarLink() {
            navigator.clipboard.writeText(location.href);
            alert('Link do evento copiado!');
        }
    </script>
</body>
</html>
