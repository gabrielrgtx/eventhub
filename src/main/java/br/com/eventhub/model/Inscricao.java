package br.com.eventhub.model;

import java.time.LocalDateTime;

public class Inscricao {

    private int id;
    private User usuario;
    private Event evento;
    private LocalDateTime dataInscricao;
    private boolean presencaConfirmada;

    public boolean isPresencaConfirmada() {
        return presencaConfirmada;
    }

    public void setPresencaConfirmada(boolean presencaConfirmada) {
        this.presencaConfirmada = presencaConfirmada;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUsuario() {
        return usuario;
    }

    public void setUsuario(User usuario) {
        this.usuario = usuario;
    }

    public Event getEvento() {
        return evento;
    }

    public void setEvento(Event evento) {
        this.evento = evento;
    }

    public LocalDateTime getDataInscricao() {
        return dataInscricao;
    }

    public void setDataInscricao(LocalDateTime dataInscricao) {
        this.dataInscricao = dataInscricao;
    }
}
