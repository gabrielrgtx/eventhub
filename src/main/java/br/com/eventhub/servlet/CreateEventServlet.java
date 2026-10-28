package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.model.Endereco;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/create-event")
public class CreateEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        Event evento = new Event();
        evento.setNome(req.getParameter("nome"));
        evento.setSobre(req.getParameter("sobre"));
        evento.setData(LocalDate.parse(req.getParameter("data")));
        evento.setInicio(LocalTime.parse(req.getParameter("inicio")));
        String fim = req.getParameter("fim");
        if (fim != null && !fim.isEmpty()) {
            evento.setFim(LocalTime.parse(fim));
        }
        evento.setVagas(Integer.parseInt(req.getParameter("vagas")));
        evento.setPublico(req.getParameter("publico") != null);
        Endereco endereco = new Endereco();
        endereco.setRua(req.getParameter("rua"));
        endereco.setNumero(req.getParameter("numero"));
        endereco.setBairro(req.getParameter("bairro"));
        endereco.setCidade(req.getParameter("cidade"));
        endereco.setEstado(req.getParameter("estado"));
        endereco.setCep(req.getParameter("cep"));
        evento.setEndereco(endereco);
        if (id == null || id.isEmpty()) {
            User criador = new User();
            criador.setId(1);
            evento.setCriador(criador);
            new EventDao().createEvent(evento);
        } else {
            evento.setId(Integer.parseInt(id));
            evento.setCancelado(new EventDao().findEventById(evento.getId()).isCancelado());
            new EventDao().updateEvent(evento);
        }
        resp.sendRedirect("/listar-eventos");
    }
}