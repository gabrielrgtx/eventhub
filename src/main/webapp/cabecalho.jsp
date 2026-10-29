<header class="topo">
    <div class="topo-barra">
        <a class="logo" href="/listar-eventos">EventHub</a>
        <nav class="topo-links">
            <form class="topo-busca ${not empty param.nome ? 'aberta' : ''}" id="topo-busca" action="/listar-eventos" method="get" role="search">
                <input type="search" name="nome" id="busca-campo" placeholder="Buscar pelo nome do evento" autocomplete="off" aria-label="Buscar pelo nome do evento" value="<c:out value="${param.nome}"/>">
                <button class="busca-icone" type="button" id="busca-botao" aria-label="Buscar eventos" aria-controls="busca-campo" aria-expanded="${not empty param.nome}"><svg viewBox="0 0 32 32" aria-hidden="true"><circle cx="13" cy="13" r="9"/><path d="m20 20 9 9"/></svg></button>
            </form>
            <c:choose>
                <c:when test="${empty usuarioLogado}">
                    <a class="botao pequeno claro topo-cadastro" href="/cadastro">Cadastre-se</a>
                    <a class="botao pequeno" href="/login">Entrar</a>
                </c:when>
                <c:otherwise>
                    <a href="/listar-eventos?favoritos=1">Favoritos</a>
                    <a href="/painel">Dashboard</a>
                    <a href="/novo-evento">Criar evento</a>
                    <a class="botao pequeno topo-perfil" href="/perfil"><c:out value="${usuarioLogado.nome}"/><c:choose><c:when test="${not empty usuarioLogado.foto}"><img class="topo-avatar" src="<c:out value="${usuarioLogado.foto}"/>" alt=""></c:when><c:otherwise><svg viewBox="0 0 32 32" aria-hidden="true"><circle cx="16" cy="16" r="13"/><circle cx="16" cy="12" r="4"/><path d="M7 25c2-7 16-7 18 0"/></svg></c:otherwise></c:choose></a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
    <script>
        (function () {
            var form = document.getElementById('topo-busca');
            var botao = document.getElementById('busca-botao');
            var campo = document.getElementById('busca-campo');
            var levouAteOsCards = false;

            function normalizar(texto) {
                return texto.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().trim();
            }

            function filtrar() {
                var cards = document.querySelectorAll('[data-nome]');
                if (cards.length == 0) {
                    return;
                }
                var busca = normalizar(campo.value);
                var visiveis = 0;
                for (var i = 0; i < cards.length; i++) {
                    var combina = normalizar(cards[i].getAttribute('data-nome')).indexOf(busca) != -1;
                    cards[i].hidden = !combina;
                    if (combina) {
                        visiveis++;
                    }
                }
                var aviso = document.getElementById('busca-vazio');
                if (aviso != null) {
                    aviso.hidden = visiveis > 0;
                }
                if (!levouAteOsCards && busca != '') {
                    levouAteOsCards = true;
                    cards[0].parentNode.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }

            function fechar() {
                form.classList.remove('aberta');
                botao.setAttribute('aria-expanded', 'false');
                campo.value = '';
                filtrar();
            }

            botao.addEventListener('click', function () {
                if (form.classList.contains('aberta')) {
                    fechar();
                    botao.focus();
                } else {
                    form.classList.add('aberta');
                    botao.setAttribute('aria-expanded', 'true');
                    campo.focus();
                }
            });

            campo.addEventListener('input', filtrar);

            campo.addEventListener('keydown', function (evento) {
                if (evento.key == 'Escape') {
                    fechar();
                    botao.focus();
                }
            });

            form.addEventListener('submit', function (evento) {
                if (document.querySelectorAll('[data-nome]').length > 0) {
                    evento.preventDefault();
                    filtrar();
                }
            });
        })();
    </script>
</header>
