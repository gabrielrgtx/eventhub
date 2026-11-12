package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.model.Categoria;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/categorias")
public class CategoriaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CategoriaDao categoriaDao = new CategoriaDao();
        req.setAttribute("categorias", categoriaDao.findAll());

        String editar = req.getParameter("editar");
        if (editar != null) {
            int idEdicao;
            try {
                idEdicao = Integer.parseInt(editar);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/categorias");
                return;
            }
            req.setAttribute("categoriaEdicao", categoriaDao.findById(idEdicao));
        }

        req.getRequestDispatcher("/categorias.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");
        String destino = req.getContextPath() + "/categorias";
        CategoriaDao categoriaDao = new CategoriaDao();

        if ("criar".equals(acao)) {
            String nome = nomeLimpo(req.getParameter("nome"));
            if (nome.isEmpty()) {
                resp.sendRedirect(destino + "?erro=nome-vazio");
                return;
            }
            if (categoriaDao.findByNome(nome) != null) {
                resp.sendRedirect(destino + "?erro=nome-duplicado");
                return;
            }
            Categoria categoria = new Categoria();
            categoria.setNome(nome);
            categoriaDao.insert(categoria);
        } else if ("editar".equals(acao)) {
            int id;
            try {
                id = Integer.parseInt(req.getParameter("id"));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/categorias");
                return;
            }
            String nome = nomeLimpo(req.getParameter("nome"));
            if (nome.isEmpty()) {
                resp.sendRedirect(destino + "?editar=" + id + "&erro=nome-vazio");
                return;
            }
            Categoria existente = categoriaDao.findByNome(nome);
            if (existente != null && existente.getId() != id) {
                resp.sendRedirect(destino + "?editar=" + id + "&erro=nome-duplicado");
                return;
            }
            Categoria categoria = new Categoria();
            categoria.setId(id);
            categoria.setNome(nome);
            categoriaDao.update(categoria);
        } else if ("excluir".equals(acao)) {
            int id;
            try {
                id = Integer.parseInt(req.getParameter("id"));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/categorias");
                return;
            }
            categoriaDao.deleteById(id);
        }

        resp.sendRedirect(destino);
    }

    private String nomeLimpo(String nome) {
        return nome == null ? "" : nome.trim();
    }
}