package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.EventoCategoriaDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/editar-evento")
public class EditEventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int id = Integer.parseInt(req.getParameter("id"));
        Event evento = new EventDao().findEventById(id);
        if (evento == null || evento.getCriador().getId() != usuario.getId()) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        req.setAttribute("evento", evento);
        req.setAttribute("categorias", new CategoriaDao().findAll());
        req.setAttribute("categoriasEvento", new EventoCategoriaDao().findCategoriaIdsByEvento(id));
        req.setAttribute("imagensEvento", new ImagemEventoDao().findByEvento(id));
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}