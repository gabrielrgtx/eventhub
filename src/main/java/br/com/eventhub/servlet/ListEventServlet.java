package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.FavoritoDao;
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

@WebServlet("/listar-eventos")
public class ListEventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        int usuarioId = 0;
        if (usuario != null) {
            usuarioId = usuario.getId();
        }
        String nome = req.getParameter("nome");
        if (nome == null) {
            nome = "";
        }
        String cidade = req.getParameter("cidade");
        if (cidade == null) {
            cidade = "";
        }
        String data = req.getParameter("data");
        if (data == null) {
            data = "";
        }
        int categoriaId = 0;
        String categoria = req.getParameter("categoria");
        if (categoria != null && !categoria.isEmpty()) {
            try {
                categoriaId = Integer.parseInt(categoria);
            } catch (NumberFormatException e) {
                System.out.println("categoria invalida");
            }
        }
        List<Event> eventos = new EventDao().search(nome.trim(), categoriaId, cidade.trim(), data.trim(), usuarioId);
        InscricaoDao inscricaoDao = new InscricaoDao();
        ImagemEventoDao imagemEventoDao = new ImagemEventoDao();
        FavoritoDao favoritoDao = new FavoritoDao();
        List<Event> destaques = new ArrayList<>();
        for (Event evento : eventos) {
            evento.setImagens(imagemEventoDao.findByEvento(evento.getId()));
            evento.setVagasRestantes(evento.getVagas() - inscricaoDao.countByEvento(evento.getId()));
            if (usuario != null) {
                evento.setInscrito(inscricaoDao.existsInscricao(usuarioId, evento.getId()));
                evento.setFavoritado(favoritoDao.existsFavorito(usuarioId, evento.getId()));
            }
            if (!evento.getData().isBefore(LocalDate.now()) && !evento.isCancelado()) {
                destaques.add(evento);
            }
        }
        req.setAttribute("eventos", eventos);
        req.setAttribute("destaques", destaques);
        req.setAttribute("categorias", new CategoriaDao().findAll());
        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }
}
