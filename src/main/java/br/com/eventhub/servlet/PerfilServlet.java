package br.com.eventhub.servlet;

import br.com.eventhub.dao.UserDao;
import br.com.eventhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;

@WebServlet("/editar-perfil")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
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

        Part arquivo;
        try {
            arquivo = req.getPart("foto-arquivo");
        } catch (IllegalStateException e) {
            resp.sendRedirect(req.getContextPath() + "/perfil?erro=foto");
            return;
        }

        boolean somenteFoto = "foto".equals(req.getParameter("acao"));
        User atualizado = new User();
        atualizado.setId(usuario.getId());
        atualizado.setFoto(usuario.getFoto());

        if (somenteFoto) {
            atualizado.setNome(usuario.getNome());
            atualizado.setUsuario(usuario.getUsuario());
            atualizado.setEmail(usuario.getEmail());
        } else {
            String nome = req.getParameter("nome");
            String login = req.getParameter("usuario");
            String email = req.getParameter("email");
            if (nome == null || nome.isEmpty() || login == null || login.isEmpty() || email == null || email.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/editar-perfil");
                return;
            }
            atualizado.setNome(nome);
            atualizado.setUsuario(login);
            atualizado.setEmail(email);
            if (req.getParameter("remover-foto") != null) {
                atualizado.setFoto(null);
            }
        }

        if (arquivo != null && arquivo.getSize() > 0) {
            String caminho = UploadServlet.salvar(arquivo);
            if (caminho == null) {
                resp.sendRedirect(req.getContextPath() + (somenteFoto ? "/perfil?erro=foto" : "/editar-perfil?erro=foto"));
                return;
            }
            atualizado.setFoto(caminho);
        }

        int resultado = new UserDao().update(atualizado);
        if (resultado != 1) {
            resp.sendRedirect(req.getContextPath() + "/editar-perfil?erro=" + (resultado == 2 ? "duplicado" : "salvar"));
            return;
        }
        atualizado.setSenha(usuario.getSenha());
        session.setAttribute("usuarioLogado", atualizado);
        resp.sendRedirect(req.getContextPath() + (somenteFoto ? "/perfil?retorno=foto" : "/editar-perfil?retorno=salvo"));
    }
}
