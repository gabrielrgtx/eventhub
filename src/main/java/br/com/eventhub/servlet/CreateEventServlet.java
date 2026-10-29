package br.com.eventhub.servlet;

import br.com.eventhub.dao.CategoriaDao;
import br.com.eventhub.dao.EventDao;
import br.com.eventhub.dao.EventoCategoriaDao;
import br.com.eventhub.dao.ImagemEventoDao;
import br.com.eventhub.model.Endereco;
import br.com.eventhub.model.Event;
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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/create-event")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 30 * 1024 * 1024)
public class CreateEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User usuario = session == null ? null : (User) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        List<Part> fotos = new ArrayList<>();
        try {
            for (Part parte : req.getParts()) {
                if ("arquivos".equals(parte.getName()) && parte.getSize() > 0) {
                    fotos.add(parte);
                }
            }
        } catch (IllegalStateException e) {
            mostrarFormulario(req, resp, null, "Cada foto pode ter no máximo 5 MB, e o envio todo até 30 MB.");
            return;
        }
        String id = req.getParameter("id");
        Event atual = null;
        if (id != null && !id.isEmpty()) {
            int eventoId;
            try {
                eventoId = Integer.parseInt(id);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
            atual = new EventDao().findEventById(eventoId);
            if (atual == null || atual.getCriador().getId() != usuario.getId()) {
                resp.sendRedirect(req.getContextPath() + "/listar-eventos");
                return;
            }
        }
        Event evento = new Event();
        evento.setNome(req.getParameter("nome"));
        evento.setSobre(req.getParameter("sobre"));
        try {
            evento.setData(LocalDate.parse(req.getParameter("data")));
            evento.setInicio(LocalTime.parse(req.getParameter("inicio")));
            String fim = req.getParameter("fim");
            if (fim != null && !fim.isEmpty()) {
                evento.setFim(LocalTime.parse(fim));
            }
            evento.setVagas(Integer.parseInt(req.getParameter("vagas")));
        } catch (RuntimeException e) {
            mostrarFormulario(req, resp, atual, "Confira a data, os horários e o número de vagas.");
            return;
        }
        if (evento.getNome() == null || evento.getNome().trim().isEmpty() || evento.getVagas() < 1) {
            mostrarFormulario(req, resp, atual, "Informe o nome do evento e pelo menos uma vaga.");
            return;
        }
        if (evento.getFim() != null && !evento.getFim().isAfter(evento.getInicio())) {
            mostrarFormulario(req, resp, atual, "O término precisa ser depois do início.");
            return;
        }
        if (atual == null && !LocalDateTime.of(evento.getData(), evento.getInicio()).isAfter(LocalDateTime.now())) {
            mostrarFormulario(req, resp, atual, "Escolha uma data e um horário futuros para o evento.");
            return;
        }
        if (atual != null && evento.getVagas() < new br.com.eventhub.dao.InscricaoDao().countByEvento(atual.getId())) {
            mostrarFormulario(req, resp, atual, "O número de vagas não pode ser menor que o de pessoas inscritas.");
            return;
        }
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
        if (atual == null) {
            evento.setCriador(usuario);
            eventoId = new EventDao().createEvent(evento);
            if (eventoId == 0) {
                mostrarFormulario(req, resp, atual, "Não foi possível publicar o evento. Tente novamente.");
                return;
            }
        } else {
            evento.setId(atual.getId());
            evento.setCancelado(atual.isCancelado());
            if (!new EventDao().updateEvent(evento)) {
                mostrarFormulario(req, resp, atual, "Não foi possível salvar as alterações. Tente novamente.");
                return;
            }
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
                boolean urlValida = (caminho.startsWith("http://") || caminho.startsWith("https://") || caminho.matches(UploadServlet.CAMINHO_VALIDO) || caminho.matches("/img/eventos/[a-z0-9-]+\\.jpg")) && caminho.length() <= 500;
                if (urlValida) {
                    imagemEventoDao.insertImagem(eventoId, caminho);
                }
            }
        }
        for (Part foto : fotos) {
            String caminho = UploadServlet.salvar(foto);
            if (caminho != null) {
                imagemEventoDao.insertImagem(eventoId, caminho);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/evento?id=" + eventoId + "&retorno=" + (atual == null ? "evento-publicado" : "evento-atualizado"));
    }

    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp, Event atual, String erro) throws ServletException, IOException {
        req.setAttribute("erro", erro);
        req.setAttribute("formEnviado", true);
        req.setAttribute("evento", atual);
        req.setAttribute("categorias", new CategoriaDao().findAll());
        ArrayList<Integer> categoriasEvento = new ArrayList<>();
        String[] categorias = req.getParameterValues("categorias");
        if (categorias != null) {
            for (String categoria : categorias) {
                try {
                    categoriasEvento.add(Integer.parseInt(categoria));
                } catch (NumberFormatException e) {
                    System.out.println("categoria invalida: " + categoria);
                }
            }
        }
        req.setAttribute("categoriasEvento", categoriasEvento);
        req.getRequestDispatcher("/formulario-evento.jsp").forward(req, resp);
    }
}
