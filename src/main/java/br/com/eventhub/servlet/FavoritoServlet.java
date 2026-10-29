package br.com.eventhub.servlet;

import br.com.eventhub.dao.FavoritoDao;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/favorito")
public class FavoritoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int eventoId;
        try {
            eventoId = Integer.parseInt(req.getParameter("eventoId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/listar-eventos");
            return;
        }
        String acao = req.getParameter("acao");
        FavoritoDao favoritoDao = new FavoritoDao();
        if ("favoritar".equals(acao)) {
            if (!favoritoDao.existsFavorito(usuario.getId(), eventoId)) {
                favoritoDao.insertFavorito(usuario.getId(), eventoId);
            }
        } else if ("desfavoritar".equals(acao)) {
            favoritoDao.deleteFavorito(usuario.getId(), eventoId);
        }
        resp.sendRedirect(req.getContextPath() + "/evento?id=" + eventoId);
    }
}
