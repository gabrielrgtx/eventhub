package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.EventoCategoriaDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.model.Endereco;
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
import java.time.LocalTime;

@WebServlet("/create-event")
public class CreateEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        Event evento = new Event();
        evento.setNome(req.getParameter("nome"));
        evento.setSobre(req.getParameter("sobre"));
        evento.setData(LocalDate.parse(req.getParameter("data")));
        evento.setInicio(LocalTime.parse(req.getParameter("inicio")));
        String fim = req.getParameter("fim");
        if (fim != null && !fim.isEmpty()) {
            evento.setFim(LocalTime.parse(fim));
        }
        evento.setVagas(Integer.parseInt(req.getParameter("vagas")));
        evento.setPublico(req.getParameter("publico") != null);
        Endereco endereco = new Endereco();
        endereco.setRua(req.getParameter("rua"));
        endereco.setNumero(req.getParameter("numero"));
        endereco.setBairro(req.getParameter("bairro"));
        endereco.setCidade(req.getParameter("cidade"));
        endereco.setEstado(req.getParameter("estado"));
        endereco.setCep(req.getParameter("cep"));
        evento.setEndereco(endereco);
        String[] categorias = req.getParameterValues("categorias");
        String imagens = req.getParameter("imagens");
        int eventoId;
        if (id == null || id.isEmpty()) {
            HttpSession session = req.getSession(false);
            User criador = session == null ? null : (User) session.getAttribute("usuarioLogado");
            if (criador == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            evento.setCriador(criador);
            eventoId = new EventDao().createEvent(evento);
            if (eventoId == 0) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
        } else {
            HttpSession session = req.getSession(false);
            User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
            if (usuario == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            try {
                evento.setId(Integer.parseInt(id));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
            Event atual = new EventDao().findEventById(evento.getId());
            if (atual == null || atual.getCriador().getId() != usuario.getId()) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
            evento.setCancelado(atual.isCancelado());
            new EventDao().updateEvent(evento);
            eventoId = evento.getId();
        }
        EventoCategoriaDao eventoCategoriaDao = new EventoCategoriaDao();
        CategoriaDao categoriaDao = new CategoriaDao();
        eventoCategoriaDao.deleteByEvento(eventoId);
        if (categorias != null) {
            for (String categoriaId : categorias) {
                if (categoriaId != null) {
                    try {
                        int idCategoria = Integer.parseInt(categoriaId);
                        if (categoriaDao.findById(idCategoria) != null) {
                            eventoCategoriaDao.insertCategoria(eventoId, idCategoria);
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("categoria invalida: " + categoriaId);
                    }
                }
            }
        }
        ImagemEventoDao imagemEventoDao = new ImagemEventoDao();
        imagemEventoDao.deleteByEvento(eventoId);
        if (imagens != null) {
            for (String linha : imagens.split("\n")) {
                String caminho = linha.trim();
                boolean urlValida = (caminho.startsWith("http://") || caminho.startsWith("https://")) && caminho.length() <= 500;
                if (urlValida) {
                    imagemEventoDao.insertImagem(eventoId, caminho);
                }
            }
        }
        resp.sendRedirect("/listar-eventos");
    }
}