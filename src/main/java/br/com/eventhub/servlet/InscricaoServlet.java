package br.com.eventhub.servlet;

import br.com.eventhub.dao.InscricaoDao;
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
        if ("confirmar-presenca".equals(acao)) {
            int participanteId;
            try {
                participanteId = Integer.parseInt(req.getParameter("usuarioId"));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
            boolean confirmada = inscricaoDao.confirmarPresenca(usuarioId, participanteId, eventoId);
            resp.sendRedirect(req.getContextPath() + "/painel?retorno=" + (confirmada ? "presenca-confirmada" : "presenca-nao-confirmada") + "#participantes-" + eventoId);
            return;
        }
        int resultado;
        if ("inscrever".equals(acao)) {
            resultado = inscricaoDao.inscrever(usuarioId, eventoId);
        } else if ("cancelar".equals(acao)) {
            resultado = inscricaoDao.cancelar(usuarioId, eventoId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        String retorno = "falha-inscricao";
        if (resultado == InscricaoDao.SUCESSO) {
            retorno = "inscrever".equals(acao) ? "inscricao-confirmada" : "inscricao-cancelada";
        } else if (resultado == InscricaoDao.INDISPONIVEL) {
            retorno = "evento-indisponivel";
        } else if (resultado == InscricaoDao.JA_INSCRITO) {
            retorno = "inscrever".equals(acao) ? "ja-inscrito" : "nao-inscrito";
        } else if (resultado == InscricaoDao.ESGOTADO) {
            retorno = "vagas-esgotadas";
        } else if (resultado == InscricaoDao.ENCERRADO) {
            retorno = "inscricoes-encerradas";
        } else if (resultado == InscricaoDao.PROPRIO_EVENTO) {
            retorno = "evento-proprio";
        }
        resp.sendRedirect(req.getContextPath() + "/evento?id=" + eventoId + "&retorno=" + retorno);
    }
}
