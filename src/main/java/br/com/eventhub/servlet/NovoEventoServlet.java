package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/novo-evento")
public class NovoEventoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("categorias", new CategoriaDao().findAll());
        req.setAttribute("categoriasEvento", new ArrayList<Integer>());
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
