package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/painel")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int usuarioId = usuario.getId();
        req.setAttribute("criados", new EventDao().findByCriador(usuarioId));
        List<Event> vou = new ArrayList<>();
        List<Event> fui = new ArrayList<>();
        for (Event evento : new EventDao().findByInscrito(usuarioId)) {
            if (evento.getData().isBefore(LocalDate.now())) {
                fui.add(evento);
            } else {
                vou.add(evento);
            }
        }
        req.setAttribute("vou", vou);
        req.setAttribute("fui", fui);
        req.setAttribute("favoritos", new EventDao().findByFavorito(usuarioId));
        req.getRequestDispatcher("/painel.jsp").forward(req, resp);
    }
}