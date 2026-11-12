INSERT INTO USUARIO (ID, NOME, USUARIO, EMAIL, SENHA, FOTO) VALUES
(1, 'Lucas Ferreira', 'lucas', 'lucas@email.com', 'eventhub123', NULL),
(2, 'Gabriel', 'gabriel', 'gabriel@gabriel.com', 'eventhub123', NULL),
(3, 'Bob', 'bob', 'bob@email.com', 'eventhub123', NULL),
(4, 'Ana', 'ana', 'ana@email.com', 'eventhub123', NULL),
(5, 'Mariana Alves', 'mariana', 'mariana@email.com', 'eventhub123', NULL),
(6, 'Rafael Oliveira', 'rafael', 'rafael@email.com', 'eventhub123', NULL),
(7, 'Camila Rocha', 'camila', 'camila@email.com', 'eventhub123', NULL),
(8, 'Pedro Santos', 'pedro', 'pedro@email.com', 'eventhub123', NULL);

INSERT INTO CATEGORIA (ID, NOME) VALUES
(1, 'Festas'),
(2, 'Esportes'),
(3, 'Shows'),
(4, 'Palestras'),
(5, 'Gastronomia'),
(6, 'Arte e Cultura'),
(7, 'Teatro'),
(8, 'Stand-up'),
(9, 'Cursos e Workshops'),
(10, 'Infantil');

INSERT INTO EVENTO (ID, NOME, SOBRE, DATA_EVENTO, INICIO, FIM, VAGAS, PUBLICO, CANCELADO, CRIADOR_ID, RUA, NUMERO, BAIRRO, CIDADE, ESTADO, CEP) VALUES
(1, 'SP Open de Tênis', 'Torneio internacional de tênis feminino com partidas o dia todo e área de alimentação.', '2027-09-12', '10:00:00', '20:00:00', 200, TRUE, TRUE, 1, 'Av. Manuel Bandeira', '360', 'Vila Leopoldina', 'São Paulo', 'SP', '05317-020'),
(2, 'Festival de Food Trucks', 'Mais de 30 food trucks, música ao vivo e área kids.', '2027-03-20', '12:00:00', '22:00:00', 150, TRUE, TRUE, 1, 'Av. Industrial', '600', 'Jardim', 'Santo André', 'SP', '09080-500'),
(3, 'Bloquinho no Ibirapuera', 'Bloco de carnaval com marchinhas, fantasias e muita alegria no parque.', '2026-12-12', '14:00:00', '20:00:00', 300, TRUE, FALSE, 1, 'Av. Pedro Álvares Cabral', 's/n', 'Ibirapuera', 'São Paulo', 'SP', '04094-050'),
(4, '28ª Bienal do Livro', 'Encontros com autores, lançamentos e atividades para todas as idades.', '2026-12-05', '10:00:00', '22:00:00', 500, TRUE, FALSE, 2, 'Av. Olavo Fontoura', '1209', 'Santana', 'São Paulo', 'SP', '02012-021'),
(5, 'O Brasil de Tarsila', 'Exposição imersiva com obras e projeções inspiradas em Tarsila do Amaral.', '2026-09-08', '10:00:00', '18:00:00', 50, TRUE, FALSE, 4, 'Av. Paulista', '1578', 'Bela Vista', 'São Paulo', 'SP', '01310-200'),
(6, 'Réveillon Tawa Beach 2027', 'Virada do ano pé na areia na Praia da Ferradura, em Búzios. A noite começa com o pôr do sol no beach club, segue com música até a contagem regressiva e termina com a queima de fogos sobre o mar. Traje branco é bem-vindo. Classificação: 18 anos.', '2026-12-31', '20:00:00', '23:59:00', 300, TRUE, FALSE, 5, 'Praia da Ferradura', 's/n', 'Ferradura', 'Armação dos Búzios', 'RJ', '28950-000'),
(7, 'Rolê no Sesc Paulista', 'Exposições, mirante e programação cultural gratuita no coração da Paulista.', '2027-09-15', '10:00:00', '18:00:00', 10, TRUE, FALSE, 5, 'Av. Paulista', '1000', 'Bela Vista', 'São Paulo', 'SP', '01310-100'),
(8, 'Rolê no Quintal', 'Música ao vivo, comidinhas e drinks em um quintal cheio de plantas.', '2026-12-19', '16:00:00', '23:00:00', 80, TRUE, FALSE, 5, 'Rua Marechal Deodoro', '1200', 'Centro', 'SBC', 'SP', '09710-002'),
(9, 'Museu do Ipiranga', 'Visita guiada pelo museu reformado e pelos jardins do Parque da Independência.', '2020-09-06', '10:00:00', '18:00:00', 5, TRUE, FALSE, 5, 'Rua dos Patriotas', '100', 'Ipiranga', 'São Paulo', 'SP', '04207-020'),
(10, 'Feirinha e Caldo de Cana', 'Feira de rua com pastel, caldo de cana e artesanato local.', '2027-08-26', '10:00:00', '18:00:00', 8, TRUE, FALSE, 5, 'Av. Presidente Castelo Branco', 's/n', 'Boqueirão', 'Praia Grande', 'SP', '11700-000'),
(11, 'Sarau no Parque', 'Uma tarde de poesia, música acústica e piquenique ao ar livre.', '2026-10-27', '15:00:00', '17:00:00', 40, TRUE, FALSE, 6, 'Av. Pedro Álvares Cabral', 's/n', 'Ibirapuera', 'São Paulo', 'SP', '04094-050'),
(12, 'Gil - Andar com Fé - O Musical', 'A primeira biografia musical sobre a vida e a obra de Gilberto Gil, com texto de Newton Moreno e direção de Miguel Falabella. A história começa no exílio em Londres e passa pelo sertão, por Salvador e pelos encontros que mudaram a música brasileira, conduzida pelo personagem Tempo-Rei. No repertório, clássicos como ''Andar com Fé'', ''Aquele Abraço'' e ''Drão''. Classificação: 12 anos.', '2026-12-18', '20:00:00', '22:30:00', 150, TRUE, FALSE, 6, 'Av. Presidente Juscelino Kubitschek', '2041', 'Itaim Bibi', 'São Paulo', 'SP', '04543-011');

INSERT INTO EVENTO_CATEGORIA (EVENTO_ID, CATEGORIA_ID) VALUES
(1, 2), (2, 5), (3, 1), (4, 4), (4, 6), (4, 10), (5, 6), (6, 1), (7, 6), (8, 1), (9, 6), (10, 5), (11, 3), (12, 3);

INSERT INTO IMAGEM_EVENTO (EVENTO_ID, CAMINHO) VALUES
(1, '/img/eventos/sp-open-tenis.jpg'),
(2, '/img/eventos/food-trucks-1.jpg'),
(3, '/img/eventos/bloquinho-1.jpg'),
(3, '/img/eventos/bloquinho-2.png'),
(3, '/img/eventos/bloquinho-3.png'),
(4, '/img/eventos/bienal-1.jpg'),
(4, '/img/eventos/bienal-2.png'),
(4, '/img/eventos/bienal-3.png'),
(5, '/img/eventos/tarsila-1.png'),
(6, '/img/eventos/reveillon-1.png'),
(7, '/img/eventos/sesc-paulista.jpg'),
(7, '/img/eventos/sesc-paulista-vista.jpg'),
(8, '/img/eventos/role-no-quintal-1.jpg'),
(8, '/img/eventos/role-no-quintal-2.jpg'),
(8, '/img/eventos/role-no-quintal-3.jpg'),
(9, '/img/eventos/museu-do-ipiranga.jpg'),
(10, '/img/eventos/feirinha-caldo-de-cana.jpg'),
(11, '/img/eventos/sarau-no-parque.jpg'),
(12, '/img/eventos/gilberto-gil-1.png');

INSERT INTO INSCRICAO (USUARIO_ID, EVENTO_ID, DATA_INSCRICAO) VALUES
(1, 2, '2026-10-28 19:46:35'),
(3, 5, '2026-10-28 22:13:40'),
(5, 9, '2026-10-29 00:50:06'),
(7, 11, '2026-10-29 01:41:02'),
(2, 3, '2026-10-29 01:49:26');

INSERT INTO PRESENCA (USUARIO_ID, EVENTO_ID, DATA_CONFIRMACAO) VALUES
(7, 11, '2026-10-29 01:41:33');

INSERT INTO FAVORITO (USUARIO_ID, EVENTO_ID) VALUES
(2, 4), (2, 8);

INSERT INTO AVALIACAO (USUARIO_ID, EVENTO_ID, NOTA, COMENTARIO, DATA_AVALIACAO) VALUES
(5, 9, 4, 'Vale muito a pena, o prédio é lindo!', '2026-10-29 00:50:06');

ALTER TABLE USUARIO ALTER COLUMN ID RESTART WITH 100;
ALTER TABLE CATEGORIA ALTER COLUMN ID RESTART WITH 100;
ALTER TABLE EVENTO ALTER COLUMN ID RESTART WITH 100;
