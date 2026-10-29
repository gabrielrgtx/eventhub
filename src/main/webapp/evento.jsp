<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${evento.nome}"/></title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <main class="container">
        <c:choose>
            <c:when test="${param.retorno == 'evento-publicado'}"><p class="mensagem" role="status">Evento publicado com sucesso.</p></c:when>
            <c:when test="${param.retorno == 'evento-atualizado'}"><p class="mensagem" role="status">Evento atualizado com sucesso.</p></c:when>
            <c:when test="${param.retorno == 'inscricao-confirmada'}"><p class="mensagem" role="status">Inscrição confirmada! Você encontra este evento no seu painel.</p></c:when>
            <c:when test="${param.retorno == 'inscricao-cancelada'}"><p class="mensagem" role="status">Sua inscrição foi cancelada.</p></c:when>
            <c:when test="${param.retorno == 'ja-inscrito'}"><p class="mensagem" role="status">Você já está inscrito neste evento.</p></c:when>
            <c:when test="${param.retorno == 'nao-inscrito'}"><p class="mensagem" role="alert">Não encontramos uma inscrição sua para cancelar.</p></c:when>
            <c:when test="${param.retorno == 'vagas-esgotadas'}"><p class="mensagem" role="alert">As vagas acabaram antes da sua inscrição.</p></c:when>
            <c:when test="${param.retorno == 'inscricoes-encerradas'}"><p class="mensagem" role="alert">As inscrições e cancelamentos foram encerrados porque o evento começou.</p></c:when>
            <c:when test="${param.retorno == 'evento-proprio'}"><p class="mensagem" role="alert">Você não pode se inscrever no evento que criou.</p></c:when>
            <c:when test="${param.retorno == 'evento-indisponivel'}"><p class="mensagem" role="alert">Este evento não está disponível para inscrição.</p></c:when>
            <c:when test="${param.retorno == 'falha-inscricao'}"><p class="mensagem" role="alert">Não foi possível concluir a ação. Tente novamente.</p></c:when>
        </c:choose>
        <section class="detalhe">
            <div class="galeria">
                <c:choose>
                    <c:when test="${not empty evento.imagens}">
                        <c:forEach var="img" items="${evento.imagens}">
                            <img src="<c:out value="${img.caminho}"/>" alt="">
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span class="card-imagem"></span>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${not empty evento.imagens[1]}"><button type="button" class="galeria-proxima" aria-label="Próxima imagem" onclick="proximaImagem(this)">›</button></c:if>
            <div class="detalhe-texto">
                <h1><c:out value="${evento.nome}"/></h1>
                <c:if test="${evento.cancelado}">
                    <p class="status">Evento cancelado</p>
                </c:if>
                <p>Criado por <a href="/perfil?id=${evento.criador.id}"><c:out value="${evento.criador.nome}"/></a></p>
                <c:if test="${not empty evento.categorias}">
                    <div class="pilulas">
                        <c:forEach var="categoria" items="${evento.categorias}">
                            <span class="pilula"><c:out value="${categoria.nome}"/></span>
                        </c:forEach>
                    </div>
                </c:if>

                <div class="acoes">
                    <c:choose>
                        <c:when test="${evento.cancelado}"><span class="status">Evento cancelado</span></c:when>
                        <c:when test="${evento.inscricoesEncerradas}"><span class="status">Inscrições encerradas</span></c:when>
                        <c:when test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}"><span class="status">Você criou este evento</span></c:when>
                        <c:when test="${empty usuarioLogado}">
                            <a class="botao" href="/login">Entre para se inscrever</a>
                        </c:when>
                        <c:when test="${inscrito}">
                            <form action="/inscricao" method="post">
                                <input type="hidden" name="eventoId" value="${evento.id}">
                                <input type="hidden" name="acao" value="cancelar">
                                <button class="botao claro" type="submit">Cancelar inscrição</button>
                            </form>
                        </c:when>
                        <c:when test="${not evento.cancelado and vagasRestantes > 0}">
                            <form action="/inscricao" method="post">
                                <input type="hidden" name="eventoId" value="${evento.id}">
                                <input type="hidden" name="acao" value="inscrever">
                                <button class="botao" type="submit">Inscreva-se</button>
                            </form>
                        </c:when>
                    </c:choose>

                    <c:if test="${not empty usuarioLogado}">
                        <c:choose>
                            <c:when test="${favoritado}">
                                <form action="/favorito" method="post">
                                    <input type="hidden" name="eventoId" value="${evento.id}">
                                    <input type="hidden" name="acao" value="desfavoritar">
                                    <button class="botao claro" type="submit">&#9829; Desfavoritar</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="/favorito" method="post">
                                    <input type="hidden" name="eventoId" value="${evento.id}">
                                    <input type="hidden" name="acao" value="favoritar">
                                    <button class="botao claro" type="submit">&#9825; Favoritar</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
                <c:if test="${not empty usuarioLogado and usuarioLogado.id == evento.criador.id}">
                    <div class="acoes acoes-dono">
                        <a class="botao claro" href="/editar-evento?id=${evento.id}">Editar evento</a>
                        <c:if test="${not evento.cancelado}">
                            <form action="/cancelar-evento" method="post" onsubmit="return confirm('Cancelar este evento? As pessoas inscritas vão ver o evento como cancelado.');">
                                <input type="hidden" name="id" value="${evento.id}">
                                <button class="botao claro" type="submit">Cancelar evento</button>
                            </form>
                        </c:if>
                        <form action="/delete-event" method="post" onsubmit="return confirm('Excluir este evento? Essa ação não pode ser desfeita.');">
                            <input type="hidden" name="id" value="${evento.id}">
                            <button class="botao perigo" type="submit">Excluir evento</button>
                        </form>
                    </div>
                </c:if>
                <c:if test="${not evento.inscricoesEncerradas and not evento.cancelado}">
                    <c:choose><c:when test="${vagasRestantes <= 0}"><p class="status">Esgotado</p></c:when><c:otherwise><p>${vagasRestantes} vagas restantes</p></c:otherwise></c:choose>
                </c:if>
            </div>
        </section>

        <div class="linhas"><span></span><span></span></div>
        <h2 class="subtitulo">Sobre o evento</h2>
        <p class="sobre-texto"><c:out value="${evento.sobre}"/></p>

        <div class="linhas direita"><span></span><span></span></div>
        <div class="caixa informacoes">
            <div>
            <p><strong>Data:</strong> ${evento.data}</p>
            <p><strong>Local:</strong> <c:out value="${evento.endereco.cidade}"/></p>
            <p><strong>Início:</strong> ${evento.inicio}</p>
            <c:if test="${not empty evento.fim}">
                <p><strong>Término:</strong> ${evento.fim}</p>
            </c:if>
            <p><strong>Endereço:</strong>
                <c:out value="${evento.endereco.rua}"/>, <c:out value="${evento.endereco.numero}"/> -
                <c:out value="${evento.endereco.bairro}"/>, <c:out value="${evento.endereco.cidade}"/> -
                <c:out value="${evento.endereco.estado}"/>, <c:out value="${evento.endereco.cep}"/>
            </p>
            </div>
            <div class="mapa-quadro"><svg viewBox="0 0 64 64" aria-hidden="true"><path d="M32 3C16 3 7 15 7 29c0 19 25 33 25 33s25-14 25-33C57 15 48 3 32 3Zm0 37a11 11 0 1 1 0-22 11 11 0 0 1 0 22Z"/></svg></div>
            <button type="button" class="info-compartilhar" aria-label="Compartilhar evento" onclick="copiarLink()"><svg viewBox="0 0 24 24"><circle cx="18" cy="4" r="2"/><circle cx="5" cy="12" r="2"/><circle cx="18" cy="20" r="2"/><path d="m7 11 9-6M7 13l9 6"/></svg></button>
        </div>

        <div class="comentarios-lista">
        <h2 class="subtitulo">Comentários</h2>
        <p class="vazio">Um pouco do que andam falando por aí</p>
        <c:if test="${inscrito and evento.presencaLiberada and not presencaConfirmada}"><p class="vazio">Sua avaliação fica disponível após o organizador confirmar sua presença.</p></c:if>
        <c:if test="${not empty param.erro}">
            <p class="mensagem">Não foi possível avaliar: <c:out value="${param.erro}"/></p>
        </c:if>

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
            <div class="comentario">
                <div class="comentario-topo">
                    <div class="comentario-autor">
                        <c:choose>
                            <c:when test="${not empty avaliacao.usuario.foto}"><img class="comentario-avatar" src="<c:out value="${avaliacao.usuario.foto}"/>" alt=""></c:when>
                            <c:otherwise><span class="comentario-avatar"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M8 14c2 3 6 3 8 0M9 9h.01M15 9h.01"/></svg></span></c:otherwise>
                        </c:choose>
                        <div><a href="/perfil?id=${avaliacao.usuario.id}"><c:out value="${avaliacao.usuario.nome}"/></a><small>@<c:out value="${avaliacao.usuario.usuario}"/></small></div>
                    </div>
                    <span class="estrelas">
                        <c:forEach var="i" items="1,2,3,4,5">
                            <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="${i <= avaliacao.nota ? 'currentColor' : 'none'}" aria-hidden="true"><path d="m12 2 3.1 6.3 7 1-5.1 5 .9 7-5.9-3.3-5.9 3.3.9-7-5.1-5 7-1Z"/></svg>
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

        function copiarLink() {
            navigator.clipboard.writeText(location.href);
            alert('Link do evento copiado!');
        }
    </script>
</body>
</html>
