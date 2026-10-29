package br.com.eventhub.servlet;

import br.com.eventhub.dao.AvaliacaoDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.FavoritoDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.dao.UserDao;
import br.com.eventhub.model.Avaliacao;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/perfil", "/usuario"})
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        String parametro = req.getParameter("id");
        if ("/usuario".equals(req.getServletPath())) {
            resp.sendRedirect(req.getContextPath() + "/perfil" + (parametro != null && parametro.matches("[0-9]+") ? "?id=" + parametro : ""));
            return;
        }
        int id;
        if (parametro == null || parametro.isEmpty()) {
            if (usuario == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            id = usuario.getId();
        } else {
            try {
                id = Integer.parseInt(parametro);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
        }
        User perfil = new UserDao().findById(id);
        if (perfil == null) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        ImagemEventoDao imagemEventoDao = new ImagemEventoDao();
        List<Event> eventos = new ArrayList<>();
        for (Event evento : new EventDao().findByCriador(id)) {
            if (evento.isPublico()) {
                evento.setImagens(imagemEventoDao.findByEvento(evento.getId()));
                if (usuario != null) {
                    evento.setFavoritado(new FavoritoDao().existsFavorito(usuario.getId(), evento.getId()));
                }
                eventos.add(evento);
            }
        }
        List<Avaliacao> avaliacoes = new AvaliacaoDao().findByUsuario(id);
        for (Avaliacao avaliacao : avaliacoes) {
            avaliacao.getEvento().setImagens(imagemEventoDao.findByEvento(avaliacao.getEvento().getId()));
        }
        req.setAttribute("perfil", perfil);
        req.setAttribute("proprioPerfil", usuario != null && usuario.getId() == perfil.getId());
        req.setAttribute("eventos", eventos);
        req.setAttribute("avaliacoes", avaliacoes);
        req.setAttribute("voltar", "/perfil?id=" + id);
        req.getRequestDispatcher("/usuario.jsp").forward(req, resp);
    }
}
