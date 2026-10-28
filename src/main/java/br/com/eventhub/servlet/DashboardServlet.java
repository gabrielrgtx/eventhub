package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/painel")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int usuarioId = 1;
        req.setAttribute("criados", new EventDao().findByCriador(usuarioId));
        req.getRequestDispatcher("/painel.jsp").forward(req, resp);
    }
}