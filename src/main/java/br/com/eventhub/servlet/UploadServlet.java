package br.com.eventhub.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.UUID;

@WebServlet("/uploads/*")
public class UploadServlet extends HttpServlet {

    public static final File PASTA = new File(System.getProperty("user.home"), "eventhub-uploads");
    public static final String CAMINHO_VALIDO = "/uploads/[a-f0-9-]+\\.(jpg|png|webp|gif)";

    public static String salvar(Part foto) throws IOException {
        String extensao = extensao(foto.getContentType());
        if (extensao == null || foto.getSize() == 0) {
            return null;
        }
        if (!PASTA.exists() && !PASTA.mkdirs()) {
            System.out.println("fail in create upload folder");
            return null;
        }
        String nome = UUID.randomUUID().toString() + "." + extensao;
        InputStream entrada = foto.getInputStream();
        Files.copy(entrada, new File(PASTA, nome).toPath());
        entrada.close();
        System.out.println("success in save upload: " + nome);
        return "/uploads/" + nome;
    }

    private static String extensao(String tipo) {
        if ("image/jpeg".equals(tipo)) {
            return "jpg";
        }
        if ("image/png".equals(tipo)) {
            return "png";
        }
        if ("image/webp".equals(tipo)) {
            return "webp";
        }
        if ("image/gif".equals(tipo)) {
            return "gif";
        }
        return null;
    }

    private static String tipo(String nome) {
        if (nome.endsWith(".png")) {
            return "image/png";
        }
        if (nome.endsWith(".webp")) {
            return "image/webp";
        }
        if (nome.endsWith(".gif")) {
            return "image/gif";
        }
        return "image/jpeg";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String caminho = "/uploads" + req.getPathInfo();
        if (req.getPathInfo() == null || !caminho.matches(CAMINHO_VALIDO)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        File arquivo = new File(PASTA, req.getPathInfo().substring(1));
        if (!arquivo.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        resp.setContentType(tipo(arquivo.getName()));
        resp.setContentLength((int) arquivo.length());
        resp.setHeader("Cache-Control", "max-age=31536000");
        resp.setHeader("X-Content-Type-Options", "nosniff");
        Files.copy(arquivo.toPath(), resp.getOutputStream());
    }
}
