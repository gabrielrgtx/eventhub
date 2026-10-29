package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.dao.EventDao;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/listar-eventos")
public class ListEventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        int usuarioId = usuario == null ? 0 : usuario.getId();
        String nome = textoOuNulo(req.getParameter("nome"));
        String cidade = textoOuNulo(req.getParameter("cidade"));
        Integer categoriaId = null;
        LocalDate data = null;
        try {
            String categoria = textoOuNulo(req.getParameter("categoria"));
            if (categoria != null) {
                categoriaId = Integer.parseInt(categoria);
            }
            String dataTexto = textoOuNulo(req.getParameter("data"));
            if (dataTexto != null) {
                data = LocalDate.parse(dataTexto);
            }
        } catch (Exception e) {
            System.out.println("filtro invalido");
        }
        List<Event> eventos = new EventDao().search(nome, categoriaId, cidade, data, usuarioId);
        InscricaoDao inscricaoDao = new InscricaoDao();
        Map<Integer, Integer> vagasRestantes = new HashMap<>();
        List<Integer> inscritos = new ArrayList<>();
        for (Event evento : eventos) {
            vagasRestantes.put(evento.getId(), evento.getVagas() - inscricaoDao.countByEvento(evento.getId()));
            if (usuario != null && inscricaoDao.existsInscricao(usuarioId, evento.getId())) {
                inscritos.add(evento.getId());
            }
        }
        req.setAttribute("eventos", eventos);
        req.setAttribute("vagasRestantes", vagasRestantes);
        req.setAttribute("inscritos", inscritos);
        req.setAttribute("categorias", new CategoriaDao().findAll());
        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }

    private String textoOuNulo(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return null;
        }
        return valor.trim();
    }
}
