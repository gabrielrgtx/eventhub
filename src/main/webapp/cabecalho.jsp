<header class="topo">
    <div class="topo-barra">
        <a class="logo" href="/listar-eventos">EventHub</a>
        <nav class="topo-links">
            <a class="busca-icone" href="/listar-eventos#busca" aria-label="Buscar eventos"><svg viewBox="0 0 32 32" aria-hidden="true"><circle cx="13" cy="13" r="9"/><path d="m20 20 9 9"/></svg></a>
            <c:choose>
                <c:when test="${empty usuarioLogado}">
                    <a class="botao pequeno" href="/login">Log in</a>
                </c:when>
                <c:otherwise>
                    <a href="/painel">Dashboard</a>
                    <a href="/novo-evento">Criar evento</a>
                    <a class="botao pequeno topo-perfil" href="/usuario?id=${usuarioLogado.id}"><c:out value="${usuarioLogado.nome}"/><svg viewBox="0 0 32 32" aria-hidden="true"><circle cx="16" cy="16" r="13"/><circle cx="16" cy="12" r="4"/><path d="M7 25c2-7 16-7 18 0"/></svg></a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>
