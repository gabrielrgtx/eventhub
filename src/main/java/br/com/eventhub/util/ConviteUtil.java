package br.com.eventhub.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class ConviteUtil {

    private static final String SEGREDO = "eventhub-convite-privado";

    public static String gerar(int eventoId) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest((eventoId + "-" + SEGREDO).getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte parte : hash) {
                hex.append(String.format("%02x", parte));
            }
            return hex.substring(0, 12);
        } catch (Exception e) {
            System.out.println("fail in generate convite");
            return "";
        }
    }

    public static boolean valido(int eventoId, String token) {
        if (token == null || token.isEmpty()) {
            return false;
        }
        return token.equals(gerar(eventoId));
    }
}
