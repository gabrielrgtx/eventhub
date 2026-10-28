package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.InscricaoDao;
import br.com.eventhub.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/inscricao")
public class InscricaoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int usuarioId = 1;
        int eventoId = Integer.parseInt(req.getParameter("eventoId"));
        String acao = req.getParameter("acao");
        InscricaoDao inscricaoDao = new InscricaoDao();
        if ("inscrever".equals(acao)) {
            Event evento = new EventDao().findEventById(eventoId);
            boolean podeInscrever = evento != null
                    && !evento.isCancelado()
                    && !inscricaoDao.existsInscricao(usuarioId, eventoId)
                    && inscricaoDao.countByEvento(eventoId) < evento.getVagas();
            if (podeInscrever) {
                inscricaoDao.insertInscricao(usuarioId, eventoId);
            }
        } else if ("cancelar".equals(acao)) {
            inscricaoDao.deleteInscricao(usuarioId, eventoId);
        }
        resp.sendRedirect("/listar-eventos");
    }
}