package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cancelar-evento")
public class CancelEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        Event evento = new EventDao().findEventById(id);
        if (evento == null || evento.getCriador().getId() != usuario.getId()) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        new EventDao().cancelEventById(id);
        resp.sendRedirect("/listar-eventos");
    }
}