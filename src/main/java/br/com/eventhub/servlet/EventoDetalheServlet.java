package br.com.eventhub.servlet;

import br.com.eventhub.dao.AvaliacaoDao;
import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.EventoCategoriaDao;
import br.com.eventhub.dao.FavoritoDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.dao.InscricaoDao;
import br.com.eventhub.dao.UserDao;
import br.com.eventhub.model.Categoria;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/evento")
public class EventoDetalheServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        Event evento = new EventDao().findEventById(id);
        if (evento == null) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        List<Integer> categoriaIds = new EventoCategoriaDao().findCategoriaIdsByEvento(id);
        for (Categoria categoria : new CategoriaDao().findAll()) {
            if (categoriaIds.contains(categoria.getId())) {
                evento.getCategorias().add(categoria);
            }
        }
        evento.setImagens(new ImagemEventoDao().findByEvento(id));
        User criador = new UserDao().findById(evento.getCriador().getId());
        if (criador != null) {
            evento.setCriador(criador);
        }
        InscricaoDao inscricaoDao = new InscricaoDao();
        int vagasRestantes = evento.getVagas() - inscricaoDao.countByEvento(id);
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        boolean inscrito = false;
        boolean podeAvaliar = false;
        AvaliacaoDao avaliacaoDao = new AvaliacaoDao();
        if (usuario != null) {
            inscrito = inscricaoDao.existsInscricao(usuario.getId(), id);
            req.setAttribute("favoritado", new FavoritoDao().existsFavorito(usuario.getId(), id));
            podeAvaliar = inscrito
                    && evento.getData().isBefore(LocalDate.now())
                    && !avaliacaoDao.existsByUsuarioEvento(usuario.getId(), id);
        }
        req.setAttribute("avaliacoes", avaliacaoDao.findByEvento(id));
        req.setAttribute("podeAvaliar", podeAvaliar);
        req.setAttribute("evento", evento);
        req.setAttribute("vagasRestantes", vagasRestantes);
        req.setAttribute("inscrito", inscrito);
        req.getRequestDispatcher("/evento.jsp").forward(req, resp);
    }
}
