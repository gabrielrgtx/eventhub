package br.com.eventhub.servlet;

import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.dao.InscricaoDao;
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
        ImagemEventoDao imagemEventoDao = new ImagemEventoDao();
        InscricaoDao inscricaoDao = new InscricaoDao();
        List<Event> criados = new EventDao().findByCriador(usuarioId);
        for (Event evento : criados) {
            evento.setImagens(imagemEventoDao.findByEvento(evento.getId()));
            evento.setInscritos(inscricaoDao.findByEvento(evento.getId()));
            evento.setPresencaLiberada(evento.getData().isBefore(LocalDate.now()) && !evento.isCancelado());
        }
        List<Event> vou = new ArrayList<>();
        List<Event> fui = new ArrayList<>();
        List<Event> aguardandoPresenca = new ArrayList<>();
        for (Event evento : new EventDao().findByInscrito(usuarioId)) {
            evento.setImagens(imagemEventoDao.findByEvento(evento.getId()));
            if (evento.getData().isBefore(LocalDate.now())) {
                if (inscricaoDao.existsPresenca(usuarioId, evento.getId())) {
                    fui.add(evento);
                } else {
                    aguardandoPresenca.add(evento);
                }
            } else {
                vou.add(evento);
            }
        }
        List<Event> favoritos = new EventDao().findByFavorito(usuarioId);
        for (Event evento : favoritos) {
            evento.setImagens(imagemEventoDao.findByEvento(evento.getId()));
        }
        req.setAttribute("criados", criados);
        req.setAttribute("vou", vou);
        req.setAttribute("fui", fui);
        req.setAttribute("aguardandoPresenca", aguardandoPresenca);
        req.setAttribute("favoritos", favoritos);
        req.getRequestDispatcher("/painel.jsp").forward(req, resp);
    }
}
