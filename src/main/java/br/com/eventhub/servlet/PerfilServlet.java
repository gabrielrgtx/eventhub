package br.com.eventhub.servlet;

import br.com.eventhub.dao.UserDao;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String nome = req.getParameter("nome");
        String login = req.getParameter("usuario");
        String email = req.getParameter("email");
        String foto = req.getParameter("foto");

        if (nome == null || nome.isEmpty() || login == null || login.isEmpty() || email == null || email.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }

        usuario.setNome(nome);
        usuario.setUsuario(login);
        usuario.setEmail(email);
        if (foto != null && !foto.isEmpty()) {
            usuario.setFoto(foto);
        }

        new UserDao().update(usuario);
        session.setAttribute("usuarioLogado", usuario);
        resp.sendRedirect(req.getContextPath() + "/perfil");
    }
}