package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.UserDao;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/excluir-conta")
public class ExcluirContaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int eventos = new EventDao().countByCriador(usuario.getId());
        if (eventos > 0) {
            resp.sendRedirect(req.getContextPath() + "/editar-perfil?erro=eventos");
            return;
        }

        new UserDao().deleteById(usuario.getId());
        session.invalidate();
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}