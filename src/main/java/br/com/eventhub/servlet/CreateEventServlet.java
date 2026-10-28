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
        String eventName = req.getParameter("event-name");
        Event evento = new Event();
        evento.setNome(eventName);
        new EventDao().createEvent(evento);
        resp.sendRedirect("/listar-eventos");
    }
}