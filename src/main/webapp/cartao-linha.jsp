<article class="card-linha">
    <c:choose>
        <c:when test="${not empty evento.imagens}">
            <img class="card-imagem" src="<c:out value="${evento.imagens[0].caminho}"/>" alt="">
        </c:when>
        <c:otherwise>
            <span class="card-imagem"></span>
        </c:otherwise>
    </c:choose>
    <div>
        <h3><c:out value="${evento.nome}"/></h3>
        <p>${evento.data}</p>
        <p><c:out value="${evento.endereco.cidade}"/></p>
        <c:if test="${evento.cancelado}">
            <p class="status">Cancelado</p>
        </c:if>
        <a class="botao pequeno claro" href="/evento?id=${evento.id}">Ver Detalhes</a>
    </div>
</article>
