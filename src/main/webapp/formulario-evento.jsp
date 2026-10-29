<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${empty evento ? 'Novo Evento' : 'Editar Evento'}</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%@ include file="cabecalho.jsp" %>
    <main class="container">
        <div class="linhas"><span></span><span></span></div>
        <h1 class="titulo-pagina">${empty evento ? 'Novo Evento' : 'Editar Evento'}</h1>
        <c:if test="${not empty erro}"><p class="mensagem" role="alert"><c:out value="${erro}"/></p></c:if>

        <form class="caixa form-evento" action="/create-event" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${evento.id}">

            <div>
                <div class="area-imagem campo" id="area-imagem">
                    <label class="area-escolher" for="arquivos-evento">
                        <svg viewBox="0 0 64 64" aria-hidden="true"><path d="M10 20h11l5-6h13l5 6h10v32H10Z"/><circle cx="32" cy="35" r="9"/><path d="M50 7v14M43 14h14"/></svg>
                        <span>Imagens do evento</span>
                        <small>Clique aqui ou arraste as fotos para esta área. JPG, PNG, WEBP ou GIF, até 5 MB cada.</small>
                    </label>
                    <input class="acessivel" type="file" name="arquivos" id="arquivos-evento" accept="image/jpeg,image/png,image/webp,image/gif" multiple>
                    <p class="area-erro" id="area-erro" role="alert" hidden></p>
                    <div class="previas" id="previas"></div>
                    <details class="links-imagem">
                        <summary>Prefere usar links de imagens?</summary>
                        <label class="acessivel" for="imagens-evento">Links das imagens, um por linha</label>
                        <textarea name="imagens" id="imagens-evento" placeholder="https://site.com/imagem.jpg"><c:choose><c:when test="${formEnviado}"><c:out value="${param.imagens}"/></c:when><c:otherwise><c:forEach var="img" items="${imagensEvento}"><c:out value="${img.caminho}"/>
</c:forEach></c:otherwise></c:choose></textarea>
                    </details>
                </div>
                <div class="privacidade"><label><input type="checkbox" name="publico" ${formEnviado ? (not empty param.publico ? 'checked' : '') : (empty evento or evento.publico ? 'checked' : '')}><span class="opcao-publico"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M2 12h20M12 2c-6 5-6 15 0 20M12 2c6 5 6 15 0 20"/></svg>Público</span><span class="opcao-privado"><svg viewBox="0 0 24 24" aria-hidden="true"><rect x="5" y="10" width="14" height="12" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg>Privado</span></label></div>
                <div class="campo">
                    <label for="evento-vagas">Vagas</label>
                    <input type="number" name="vagas" id="evento-vagas" value="<c:out value="${formEnviado ? param.vagas : evento.vagas}"/>" min="1" required>
                </div>
            </div>

            <div>
                <div class="campo">
                    <label for="evento-nome">Nome do Evento</label>
                    <input type="text" name="nome" id="evento-nome" value="<c:out value="${formEnviado ? param.nome : evento.nome}"/>" required>
                </div>
                <div class="campo local-campos"><span class="rotulo-grupo">Local <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" aria-hidden="true"><path d="M12 22s8-8 8-14a8 8 0 0 0-16 0c0 6 8 14 8 14Z"/><circle cx="12" cy="8" r="2"/></svg></span><div class="linha-campos"><input type="text" name="rua" aria-label="Rua" placeholder="Rua" value="<c:out value="${formEnviado ? param.rua : evento.endereco.rua}"/>"><input type="text" name="numero" aria-label="Número" placeholder="Nº" value="<c:out value="${formEnviado ? param.numero : evento.endereco.numero}"/>"></div><div class="linha-campos"><input type="text" name="bairro" aria-label="Bairro" placeholder="Bairro" value="<c:out value="${formEnviado ? param.bairro : evento.endereco.bairro}"/>"><input type="text" name="cidade" aria-label="Cidade" placeholder="Cidade" value="<c:out value="${formEnviado ? param.cidade : evento.endereco.cidade}"/>"></div><div class="linha-campos"><input type="text" name="estado" aria-label="Estado" placeholder="UF" maxlength="2" value="<c:out value="${formEnviado ? param.estado : evento.endereco.estado}"/>"><input type="text" name="cep" aria-label="CEP" placeholder="CEP" value="<c:out value="${formEnviado ? param.cep : evento.endereco.cep}"/>"></div></div>
                <div class="campo">
                    <label for="evento-data">Quando Será? <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" aria-hidden="true"><rect x="2" y="4" width="20" height="18" rx="2"/><path d="M7 2v5M17 2v5M2 10h20"/></svg></label>
                    <input type="date" name="data" id="evento-data" value="<c:out value="${formEnviado ? param.data : evento.data}"/>" required>
                </div>
                <div class="linha-campos">
                    <div class="campo">
                        <label for="evento-inicio">Início</label>
                        <input type="time" name="inicio" id="evento-inicio" value="<c:out value="${formEnviado ? param.inicio : evento.inicio}"/>" required>
                    </div>
                    <div class="campo">
                        <label for="evento-fim">Término</label>
                        <input type="time" name="fim" id="evento-fim" value="<c:out value="${formEnviado ? param.fim : evento.fim}"/>">
                    </div>
                </div>
            </div>

            <div class="inteiro campo">
                <label for="evento-sobre">Sobre o Evento</label>
                <textarea name="sobre" id="evento-sobre"><c:out value="${formEnviado ? param.sobre : evento.sobre}"/></textarea>
            </div>

            <div class="inteiro">
                <label>Tags (Opcional)</label>
                <div class="pilulas" style="justify-content: flex-start;">
                    <c:forEach var="c" items="${categorias}">
                        <c:set var="marcado" value="false"/>
                        <c:forEach var="idEvento" items="${categoriasEvento}">
                            <c:if test="${idEvento == c.id}">
                                <c:set var="marcado" value="true"/>
                            </c:if>
                        </c:forEach>
                        <label class="pilula"><input type="checkbox" name="categorias" value="${c.id}" ${marcado ? 'checked' : ''}> <c:out value="${c.nome}"/></label>
                    </c:forEach>
                </div>
            </div>

            <div class="inteiro">
                <button class="botao largo" type="submit">Publicar Rolê!</button>
            </div>
        </form>
    </main>
    <script>
        (function () {
            var area = document.getElementById('area-imagem');
            var entrada = document.getElementById('arquivos-evento');
            var links = document.getElementById('imagens-evento');
            var previas = document.getElementById('previas');
            var erro = document.getElementById('area-erro');
            var tipos = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
            var limite = 5 * 1024 * 1024;
            var selecionadas = new DataTransfer();

            function linhas() {
                var lista = [];
                var partes = links.value.split('\n');
                for (var i = 0; i < partes.length; i++) {
                    if (partes[i].trim() != '') {
                        lista.push(partes[i].trim());
                    }
                }
                return lista;
            }

            function mostrarErro(mensagem) {
                erro.textContent = mensagem;
                erro.hidden = mensagem == '';
            }

            function adicionarPrevia(endereco, nome, remover) {
                var item = document.createElement('div');
                item.className = 'previa';
                var imagem = document.createElement('img');
                imagem.src = endereco;
                imagem.alt = nome;
                var botao = document.createElement('button');
                botao.type = 'button';
                botao.className = 'previa-remover';
                botao.setAttribute('aria-label', 'Remover ' + nome);
                botao.textContent = '×';
                botao.addEventListener('click', function (evento) {
                    evento.stopPropagation();
                    remover();
                });
                item.appendChild(imagem);
                item.appendChild(botao);
                previas.appendChild(item);
            }

            function removerLink(indice) {
                var lista = linhas();
                lista.splice(indice, 1);
                links.value = lista.join('\n');
                desenhar();
            }

            function removerArquivo(indice) {
                selecionadas.items.remove(indice);
                entrada.files = selecionadas.files;
                desenhar();
            }

            function desenhar() {
                previas.innerHTML = '';
                var lista = linhas();
                lista.forEach(function (endereco, indice) {
                    adicionarPrevia(endereco, 'imagem ' + (indice + 1), function () {
                        removerLink(indice);
                    });
                });
                Array.prototype.forEach.call(selecionadas.files, function (arquivo, indice) {
                    adicionarPrevia(URL.createObjectURL(arquivo), arquivo.name, function () {
                        removerArquivo(indice);
                    });
                });
            }

            function adicionar(arquivos) {
                var mensagem = '';
                for (var i = 0; i < arquivos.length; i++) {
                    if (tipos.indexOf(arquivos[i].type) == -1) {
                        mensagem = arquivos[i].name + ' não é uma imagem JPG, PNG, WEBP ou GIF.';
                    } else if (arquivos[i].size > limite) {
                        mensagem = arquivos[i].name + ' passa de 5 MB.';
                    } else {
                        selecionadas.items.add(arquivos[i]);
                    }
                }
                entrada.files = selecionadas.files;
                mostrarErro(mensagem);
                desenhar();
            }

            entrada.addEventListener('change', function () {
                var novos = Array.prototype.slice.call(entrada.files);
                entrada.files = selecionadas.files;
                adicionar(novos);
            });

            area.addEventListener('click', function (evento) {
                if (evento.target.closest('label, input, textarea, details, button, .previa') == null) {
                    entrada.click();
                }
            });

            area.addEventListener('dragover', function (evento) {
                evento.preventDefault();
                area.classList.add('arrastando');
            });

            area.addEventListener('dragleave', function (evento) {
                if (!area.contains(evento.relatedTarget)) {
                    area.classList.remove('arrastando');
                }
            });

            area.addEventListener('drop', function (evento) {
                evento.preventDefault();
                area.classList.remove('arrastando');
                adicionar(evento.dataTransfer.files);
            });

            links.addEventListener('input', desenhar);

            desenhar();
        })();
    </script>
</body>
</html>
