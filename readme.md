# EventHub

## Descrição

O projeto consiste no desenvolvimento de uma plataforma web para divulgação de eventos e registro de participação. Qualquer usuário cadastrado pode publicar eventos e se inscrever em eventos publicados por outros usuários.

Cada usuário possui um painel pessoal que organiza sua trajetória em três situações: eventos futuros em que está inscrito, eventos já realizados dos quais participou, e eventos que ele mesmo publicou.

Após a realização de um evento, os usuários que estavam inscritos podem registrar uma avaliação e um comentário sobre a experiência, formando um histórico pessoal e público de participação.

## Funcionalidades

### Conta
- Criar conta
- Entrar e sair
- Editar perfil
- Ver perfil de outro usuário

### Eventos
- Criar evento
- Editar evento
- Cancelar evento
- Ver meus eventos criados
- Definir evento como público ou privado
- Adicionar múltiplas imagens ao evento

### Buscar
- Ver lista de eventos
- Buscar por nome
- Filtrar por categoria, cidade e data
- Ver página do evento
- Favoritar evento

### Inscrição
- Se inscrever num evento
- Cancelar inscrição
- Mostrar vagas restantes e evento esgotado

### Avaliação
- Comentar e dar nota depois do evento
- Só quem foi pode avaliar
- Uma avaliação por pessoa
- Editar ou apagar seu comentário
- Ver as avaliações do evento

### Dashboard
- Eventos que vou
- Eventos que já fui
- Eventos que criei

## Como rodar

### Requisitos
- Java 8
- Maven

### Passos
1. Clonar o repositório
2. Entrar na pasta `eventhub`
3. Rodar `mvn clean compile`
4. Rodar `mvn tomcat7:run`
5. Abrir http://localhost:8080/ no navegador

### Banco de dados
- H2 em arquivo na pasta do usuário: `jdbc:h2:~/test`, usuário `sa`, senha `sa`
- O schema e os dados de exemplo são criados automaticamente na primeira execução
- Console do banco em http://localhost:8080/console
- Para recomeçar do zero, parar o servidor e apagar o arquivo `test.mv.db` da pasta do usuário

### Usuários de teste
Todos com a senha `eventhub123`:
- lucas@email.com
- gabriel@gabriel.com
- bob@email.com
- ana@email.com

### Fotos
- As fotos enviadas pelos usuários ficam na pasta `eventhub-uploads`, dentro da pasta do usuário

### Áreas
- Pública: listar eventos, ver evento, ver perfil, login e cadastro
- Logada: painel, criar, editar, cancelar e excluir evento, inscrição, favoritos, avaliação, categorias e editar perfil, protegida pelo `AuthenticationFilter`

## Protótipos

### Login
![Tela de login](imagens/01-login.png)

### Cadastro
![Tela de cadastro](imagens/02-cadastro.png)

### Home
![Página inicial com eventos em destaque](imagens/03-home.png)

### Detalhe do evento
![Página do evento com inscrição e avaliações](imagens/04-detalhe-evento.png)

### Novo evento
![Formulário de criação de evento](imagens/05-novo-evento.png)

### Dashboard
![Painel do usuário com eventos futuros, criados e passados](imagens/06-dashboard.png)

### Perfil
![Perfil do usuário com eventos e avaliações](imagens/07-perfil.png)

## Modelo Entidade-Relacionamento

![Diagrama MER do EventHub](imagens/mer-pi.png)