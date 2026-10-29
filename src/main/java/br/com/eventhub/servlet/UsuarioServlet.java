package br.com.eventhub.servlet;

import br.com.eventhub.dao.AvaliacaoDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.FavoritoDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.dao.UserDao;
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

@WebServlet("/usuario")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        User perfil = new UserDao().findById(id);
        if (perfil == null) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        List<Event> eventos = new ArrayList<>();
        for (Event evento : new EventDao().findByCriador(id)) {
            if (evento.isPublico()) {
                evento.setImagens(new ImagemEventoDao().findByEvento(evento.getId()));
                if (usuario != null) {
                    evento.setFavoritado(new FavoritoDao().existsFavorito(usuario.getId(), evento.getId()));
                }
                eventos.add(evento);
            }
        }
        req.setAttribute("perfil", perfil);
        req.setAttribute("eventos", eventos);
        req.setAttribute("avaliacoes", new AvaliacaoDao().findByUsuario(id));
        req.getRequestDispatcher("/usuario.jsp").forward(req, resp);
    }
}
