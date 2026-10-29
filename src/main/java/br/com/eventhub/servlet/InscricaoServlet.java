package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.InscricaoDao;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/inscricao")
public class InscricaoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int usuarioId = usuario.getId();
        int eventoId;
        try {
            eventoId = Integer.parseInt(req.getParameter("eventoId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
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
        resp.sendRedirect(req.getContextPath() + "/evento?id=" + eventoId);
    }
}