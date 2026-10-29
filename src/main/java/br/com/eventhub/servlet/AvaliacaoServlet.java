package br.com.eventhub.servlet;

import br.com.eventhub.dao.AvaliacaoDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.InscricaoDao;
import br.com.eventhub.model.Avaliacao;
import br.com.eventhub.model.Event;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/avaliacao")
public class AvaliacaoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String acao = req.getParameter("acao");
        int eventoId = Integer.parseInt(req.getParameter("eventoId"));
        String destino = req.getContextPath() + "/listar-eventos";

        AvaliacaoDao avaliacaoDao = new AvaliacaoDao();

        if ("criar".equals(acao)) {
            int nota = Integer.parseInt(req.getParameter("nota"));
            String comentario = req.getParameter("comentario");

            if (nota < 1 || nota > 5) {
                resp.sendRedirect(destino + "?erro=nota-invalida");
                return;
            }

            Event evento = new EventDao().findEventById(eventoId);
            if (evento == null || !evento.getData().isBefore(LocalDate.now())) {
                resp.sendRedirect(destino + "?erro=evento-nao-realizado");
                return;
            }

            if (!new InscricaoDao().existsInscricao(usuario.getId(), eventoId)) {
                resp.sendRedirect(destino + "?erro=sem-inscricao");
                return;
            }

            if (avaliacaoDao.existsByUsuarioEvento(usuario.getId(), eventoId)) {
                resp.sendRedirect(destino + "?erro=ja-avaliou");
                return;
            }

            Avaliacao avaliacao = new Avaliacao();
            avaliacao.setUsuario(usuario);
            avaliacao.setEvento(evento);
            avaliacao.setNota(nota);
            avaliacao.setComentario(comentario);
            avaliacaoDao.insert(avaliacao);
        } else if ("editar".equals(acao)) {
            int avaliacaoId = Integer.parseInt(req.getParameter("avaliacaoId"));
            int nota = Integer.parseInt(req.getParameter("nota"));
            String comentario = req.getParameter("comentario");

            if (nota < 1 || nota > 5) {
                resp.sendRedirect(destino + "?erro=nota-invalida");
                return;
            }

            Avaliacao avaliacao = new Avaliacao();
            avaliacao.setId(avaliacaoId);
            avaliacao.setUsuario(usuario);
            avaliacao.setNota(nota);
            avaliacao.setComentario(comentario);
            avaliacaoDao.update(avaliacao);
        } else if ("excluir".equals(acao)) {
            int avaliacaoId = Integer.parseInt(req.getParameter("avaliacaoId"));
            avaliacaoDao.deleteById(avaliacaoId, usuario.getId());
        }

        resp.sendRedirect(destino);
    }
}