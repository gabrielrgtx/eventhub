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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String identificador = req.getParameter("identificador");
        String senha = req.getParameter("senha");

        if (identificador == null || identificador.isEmpty() || senha == null || senha.isEmpty()) {
            req.setAttribute("erro", "Preencha usuário ou e-mail e senha.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        User usuario = new UserDao().findByLogin(identificador, senha);
        if (usuario == null) {
            req.setAttribute("erro", "Usuário ou senha inválidos.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("usuarioLogado", usuario);
        resp.sendRedirect(req.getContextPath() + "/listar-eventos");
    }
}