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

@WebServlet("/delete-event")
public class DeleteEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String eventId = req.getParameter("id");
        Event evento;
        try {
            evento = new EventDao().findEventById(Integer.parseInt(eventId));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        if (evento == null || evento.getCriador().getId() != usuario.getId()) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        new EventDao().deleteEventById(eventId);
        resp.sendRedirect("/listar-eventos");
    }
}