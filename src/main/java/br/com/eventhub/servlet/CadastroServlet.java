package br.com.eventhub.servlet;

import br.com.eventhub.dao.UserDao;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("cadastro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nome = req.getParameter("nome");
        String login = req.getParameter("usuario");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        if (nome == null || nome.isEmpty()
                || login == null || login.isEmpty()
                || email == null || email.isEmpty()
                || senha == null || senha.isEmpty()) {
            req.setAttribute("erro", "Preencha todos os campos.");
            req.getRequestDispatcher("cadastro.jsp").forward(req, resp);
            return;
        }

        User usuario = new User();
        usuario.setNome(nome);
        usuario.setUsuario(login);
        usuario.setEmail(email);
        usuario.setSenha(senha);

        new UserDao().insert(usuario);
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}