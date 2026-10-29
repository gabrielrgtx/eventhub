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

        <form class="caixa form-evento" action="/create-event" method="post">
            <input type="hidden" name="id" value="${evento.id}">

            <div>
                <div class="area-imagem campo">
                    <svg viewBox="0 0 64 64" aria-hidden="true"><path d="M10 20h11l5-6h13l5 6h10v32H10Z"/><circle cx="32" cy="35" r="9"/><path d="M50 7v14M43 14h14"/></svg>
                    <label>Arraste a foto do local/banner aqui ou clique para escolher</label>
                    <small>Informe URLs de imagens, uma por linha</small>
                    <textarea name="imagens"><c:forEach var="img" items="${imagensEvento}"><c:out value="${img.caminho}"/>
</c:forEach></textarea>
                </div>
                <div class="privacidade"><label><input type="checkbox" name="publico" ${empty evento or evento.publico ? 'checked' : ''}><span class="opcao-publico"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M2 12h20M12 2c-6 5-6 15 0 20M12 2c6 5 6 15 0 20"/></svg>Público</span><span class="opcao-privado"><svg viewBox="0 0 24 24" aria-hidden="true"><rect x="5" y="10" width="14" height="12" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg>Privado</span></label></div>
                <div class="campo">
                    <label>Vagas</label>
                    <input type="number" name="vagas" value="${evento.vagas}" min="0" required>
                </div>
            </div>

            <div>
                <div class="campo">
                    <label>Nome do Evento</label>
                    <input type="text" name="nome" value="<c:out value="${evento.nome}"/>" required>
                </div>
                <div class="campo local-campos"><label>Local <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"><path d="M12 22s8-8 8-14a8 8 0 0 0-16 0c0 6 8 14 8 14Z"/><circle cx="12" cy="8" r="2"/></svg></label><div class="linha-campos"><input type="text" name="rua" placeholder="Rua" value="<c:out value="${evento.endereco.rua}"/>"><input type="text" name="numero" placeholder="Nº" value="<c:out value="${evento.endereco.numero}"/>"></div><div class="linha-campos"><input type="text" name="bairro" placeholder="Bairro" value="<c:out value="${evento.endereco.bairro}"/>"><input type="text" name="cidade" placeholder="Cidade" value="<c:out value="${evento.endereco.cidade}"/>"></div><div class="linha-campos"><input type="text" name="estado" placeholder="UF" maxlength="2" value="<c:out value="${evento.endereco.estado}"/>"><input type="text" name="cep" placeholder="CEP" value="<c:out value="${evento.endereco.cep}"/>"></div></div>
                <div class="campo">
                    <label>Quando Será? <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"><rect x="2" y="4" width="20" height="18" rx="2"/><path d="M7 2v5M17 2v5M2 10h20"/></svg></label>
                    <input type="date" name="data" value="${evento.data}" required>
                </div>
                <div class="linha-campos">
                    <div class="campo">
                        <label>Início</label>
                        <input type="time" name="inicio" value="${evento.inicio}" required>
                    </div>
                    <div class="campo">
                        <label>Término</label>
                        <input type="time" name="fim" value="${evento.fim}">
                    </div>
                </div>
            </div>

            <div class="inteiro campo">
                <label>Sobre o Evento</label>
                <textarea name="sobre"><c:out value="${evento.sobre}"/></textarea>
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
</body>
</html>
