package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/create-event")
public class CreateEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        String eventName = req.getParameter("event-name");
        Event evento = new Event();
        evento.setNome(eventName);
        if (id == null || id.isEmpty()) {
            new EventDao().createEvent(evento);
        } else {
            evento.setId(Integer.parseInt(id));
            new EventDao().updateEvent(evento);
        }
        resp.sendRedirect("/listar-eventos");
    }
}