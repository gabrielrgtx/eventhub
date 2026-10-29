<c:choose>
    <c:when test="${empty usuarioLogado}">
        <a class="card-coracao" href="/login" aria-label="Entrar para favoritar"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 21 3 12C-3 5 6-2 12 5c6-7 15 0 9 7Z"/></svg></a>
    </c:when>
    <c:otherwise>
        <form class="coracao-form" action="/favorito" method="post">
            <input type="hidden" name="eventoId" value="${evento.id}">
            <input type="hidden" name="acao" value="${evento.favoritado ? 'desfavoritar' : 'favoritar'}">
            <input type="hidden" name="voltar" value="<c:out value="${voltar}"/>">
            <button class="card-coracao ${evento.favoritado ? 'favoritado' : ''}" type="submit" aria-label="${evento.favoritado ? 'Desfavoritar evento' : 'Favoritar evento'}" aria-pressed="${evento.favoritado}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 21 3 12C-3 5 6-2 12 5c6-7 15 0 9 7Z"/></svg></button>
        </form>
    </c:otherwise>
</c:choose>
