 
-- Criação do banco de dados
CREATE DATABASE oficina_lex;
USE oficina_lex;

-- Criação de tabelas 
CREATE TABLE cargo (
cod_cargo INT AUTO_INCREMENT PRIMARY KEY,
nome_cargo VARCHAR(40) NOT NULL UNIQUE,
salario DECIMAL(10,2) NOT NULL CHECK (salario > 0)
);

CREATE TABLE cliente (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
telefone VARCHAR(15),
email VARCHAR(100),
logradouro VARCHAR(100) NOT NULL,
numero VARCHAR(10) NOT NULL,
complemento VARCHAR(50),
bairro VARCHAR(60) NOT NULL,
cep CHAR(8) NOT NULL,
cidade VARCHAR(60) NOT NULL
);

CREATE TABLE veiculo (
placa CHAR(7) PRIMARY KEY,
id_cliente INT NOT NULL,
chassi VARCHAR(17) NOT NULL UNIQUE,
marca VARCHAR(40) NOT NULL,
modelo VARCHAR(40) NOT NULL,
cor VARCHAR(30) NOT NULL,
ano_fab YEAR NOT NULL,
quilometragem INT NOT NULL CHECK (quilometragem >= 0),
CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE funcionario (
mat_func INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
rg VARCHAR(15) NOT NULL,
data_nasc DATE NOT NULL,
data_adm DATE NOT NULL,
logradouro VARCHAR(100) NOT NULL,
numero VARCHAR(10) NOT NULL,
complemento VARCHAR(50),
bairro VARCHAR(60) NOT NULL,
cep CHAR(8) NOT NULL,
cidade VARCHAR(60) NOT NULL,
especialidade VARCHAR(40),
cod_cargo INT NOT NULL,
CONSTRAINT fk_func_cargo FOREIGN KEY (cod_cargo) REFERENCES cargo(cod_cargo)
);


CREATE TABLE servico (
id_servico INT AUTO_INCREMENT PRIMARY KEY,
descricao VARCHAR(100) NOT NULL,
valor_mao_de_obra DECIMAL(10,2) NOT NULL CHECK (valor_mao_de_obra >= 0)
);

CREATE TABLE peca (
id_peca INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(80) NOT NULL,
categoria VARCHAR(40) NOT NULL,
fornecedor VARCHAR(80) NOT NULL,
preco_custo DECIMAL(10,2) NOT NULL CHECK (preco_custo >= 0),
preco_venda DECIMAL(10,2) NOT NULL CHECK (preco_venda >= 0),
qtd_estoque INT NOT NULL CHECK (qtd_estoque >= 0),
estoque_minimo INT NOT NULL CHECK (estoque_minimo >= 0)
);


CREATE TABLE ordem_servico (
num_os INT AUTO_INCREMENT PRIMARY KEY,
placa CHAR(7) NOT NULL,
mat_func INT NOT NULL,
data DATE NOT NULL,
hora TIME NOT NULL,
defeito VARCHAR(255) NOT NULL,
forma_pag VARCHAR(20),
status VARCHAR(20) NOT NULL DEFAULT 'aberta'
CHECK (status IN ('aberta','em andamento','concluida','cancelada')),
CONSTRAINT fk_os_veiculo FOREIGN KEY (placa) REFERENCES veiculo(placa),
CONSTRAINT fk_os_func FOREIGN KEY (mat_func) REFERENCES funcionario(mat_func)
);


CREATE TABLE servico_executado (
numero INT AUTO_INCREMENT PRIMARY KEY,
num_os INT NOT NULL,
id_servico INT NOT NULL,
mat_func INT NOT NULL,
quantidade INT NOT NULL CHECK (quantidade > 0),
valor_cobrado DECIMAL(10,2) NOT NULL CHECK (valor_cobrado >= 0),
status VARCHAR(20) NOT NULL DEFAULT 'em andamento' CHECK (status IN ('em andamento','concluido')),
CONSTRAINT fk_se_os FOREIGN KEY (num_os) REFERENCES ordem_servico(num_os),
CONSTRAINT fk_se_servico FOREIGN KEY (id_servico) REFERENCES servico(id_servico),
CONSTRAINT fk_se_func FOREIGN KEY (mat_func) REFERENCES funcionario(mat_func)
);


CREATE TABLE peca_utilizada (
numero INT AUTO_INCREMENT PRIMARY KEY,
num_os INT NOT NULL,
id_peca INT NOT NULL,
qtd_usada INT NOT NULL CHECK (qtd_usada > 0),
preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
CONSTRAINT fk_pu_os FOREIGN KEY (num_os) REFERENCES ordem_servico(num_os),
CONSTRAINT fk_pu_peca FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);

-- Restrições adicionais 
ALTER TABLE cliente ADD UNIQUE (email);
ALTER TABLE servico ADD UNIQUE (descricao);
ALTER TABLE peca ADD UNIQUE (nome);


-- Inserção de dados (DML)
INSERT INTO cargo (nome_cargo, salario) VALUES
('Mecânico', 3200.00),
('Atendente', 2000.00),
('Gerente', 6000.00),
('Administrativo', 2100.00);

INSERT INTO cliente (nome, cpf, telefone, email, logradouro, numero, complemento, bairro, cep, cidade) VALUES
('Carlos Eduardo Silva',  '11111111101', '61991110001', 'carlos.silva@email.com',   'Quadra 5 Conjunto A',  '10',  'Casa',    'Asa Norte',     '70700000', 'Brasília'),
('Mariana Souza Lima',    '11111111102', '61991110002', 'mariana.lima@email.com',   'Rua das Flores',       '25',  NULL,      'Taguatinga',    '72010000', 'Taguatinga'),
('João Pedro Alves',      '11111111103', '61991110003', 'joao.alves@email.com',     'Avenida Central',      '120', 'Apto 101','Ceilândia',     '72210000', 'Ceilândia'),
('Ana Beatriz Rocha',     '11111111104', '61991110004', 'ana.rocha@email.com',      'Quadra 12 Lote 3',     '3',   NULL,      'Samambaia',     '72300000', 'Samambaia'),
('Ricardo Mendes',        '11111111105', '61991110005', 'ricardo.mendes@email.com', 'Rua dos Ipês',         '48',  'Fundos',  'Gama',          '72405000', 'Gama'),
('Fernanda Costa',        '11111111106', '61991110006', 'fernanda.costa@email.com', 'Avenida Brasil',       '300', NULL,      'Sobradinho',    '73010000', 'Sobradinho'),
('Lucas Martins',         '11111111107', '61991110007', 'lucas.martins@email.com',  'Quadra 8 Casa 7',      '7',   NULL,      'Planaltina',    '73750000', 'Planaltina'),
('Patrícia Gomes',        '11111111108', '61991110008', 'patricia.gomes@email.com', 'Rua das Palmeiras',    '89',  'Bloco B', 'Águas Claras',  '71900000', 'Águas Claras'),
('Rafael Oliveira',       '11111111109', '61991110009', 'rafael.oliveira@email.com','Setor de Chácaras',     '15',  NULL,      'Guará',         '71010000', 'Guará'),
('Juliana Ferreira',      '11111111110', '61991110010', 'juliana.ferreira@email.com','Avenida Pau Brasil',   '500', 'Sala 2',  'Águas Claras',  '71926000', 'Águas Claras');


INSERT INTO veiculo (placa, id_cliente, chassi, marca, modelo, cor, ano_fab, quilometragem) VALUES
('ABC1D23', 1,  '9BWZZZ37700000001', 'Volkswagen', 'Gol',      'Prata',    2015, 85000),
('DEF2E34', 2,  '9BD15822700000002', 'Fiat',       'Uno',      'Branco',   2012, 120000),
('GHI3F45', 3,  '9BGKS48U700000003', 'Chevrolet',  'Onix',     'Preto',    2019, 45000),
('JKL4G56', 4,  '9BFZB55P700000004', 'Ford',       'Ka',       'Vermelho', 2017, 67000),
('MNO5H67', 5,  '93HGM662700000005', 'Honda',      'Civic',    'Cinza',    2018, 52000),
('PQR6I78', 6,  '9BR53ZEC700000006', 'Toyota',     'Corolla',  'Branco',   2020, 30000),
('STU7J89', 7,  '9BHBG51C700000007', 'Hyundai',    'HB20',     'Azul',     2016, 78000),
('VWX8K90', 8,  '93YBSR7R700000008', 'Renault',    'Sandero',  'Prata',    2014, 95000),
('YZA9L01', 9,  '9BWZZZ37700000009', 'Volkswagen', 'Polo',     'Preto',    2021, 18000),
('BCD0M12', 10, '9BD15822700000010', 'Fiat',       'Argo',     'Vermelho', 2022, 12000);


INSERT INTO funcionario (nome, cpf, rg, data_nasc, data_adm, logradouro, numero, complemento, bairro, cep, cidade, especialidade, cod_cargo) VALUES
('Marcos Antônio Pereira', '22222222201', '1234567', '1985-03-12', '2015-02-01', 'Quadra 3 Conjunto B', '12', NULL,      'Taguatinga',   '72010100', 'Taguatinga',   'Motor e câmbio',       1),
('Sérgio Luiz Barbosa',    '22222222202', '2345678', '1982-07-25', '2016-05-10', 'Rua 10',               '45', 'Casa 2',  'Ceilândia',    '72210100', 'Ceilândia',    'Sistema elétrico',     1),
('Diego Ramos',            '22222222203', '3456789', '1999-11-03', '2022-01-15', 'Avenida Central',      '77', NULL,      'Samambaia',    '72300100', 'Samambaia',    'Suspensão e freios',   1),
('Camila Torres',          '22222222204', '4567890', '1995-04-18', '2020-08-03', 'Quadra 7 Lote 9',      '9',  'Apto 3',  'Guará',        '71010100', 'Guará',        NULL,                   2),
('Roberto Carvalho',       '22222222205', '5678901', '1978-09-30', '2012-03-01', 'Rua das Acácias',      '150',NULL,      'Asa Sul',      '70300000', 'Brasília',     NULL,                   3),
('Anderson Nunes',         '22222222206', '6789012', '1988-01-22', '2018-06-11', 'Rua 5',                '33', NULL,      'Gama',         '72405100', 'Gama',         'Lataria',              1),
('Thiago Menezes',         '22222222207', '7890123', '1990-12-05', '2019-09-20', 'Quadra 15 Casa 4',     '4',  NULL,      'Sobradinho',   '73010100', 'Sobradinho',   'Pintura automotiva',   1),
('Paulo Henrique Dias',    '22222222208', '8901234', '1993-06-14', '2021-02-08', 'Avenida Brasil',       '210','Fundos',  'Planaltina',   '73750100', 'Planaltina',   'Pneus',                1),
('Leandro Freitas',        '22222222209', '9012345', '1987-10-09', '2017-11-27', 'Rua das Palmeiras',    '60', NULL,      'Águas Claras', '71900100', 'Águas Claras', 'Alinhamento e balanceamento', 1),
('Vanessa Moreira',        '22222222210', '0123456', '1997-02-28', '2023-03-06', 'Quadra 2 Conjunto C',  '18', NULL,      'Taguatinga',   '72010200', 'Taguatinga',   NULL,                   4);


INSERT INTO servico (descricao, valor_mao_de_obra) VALUES
('Troca de óleo e filtro',        80.00),
('Alinhamento e balanceamento',  120.00),
('Troca de pastilhas de freio',  150.00),
('Revisão completa',             350.00),
('Troca de bateria',              50.00),
('Troca de correia dentada',     400.00),
('Troca de amortecedores',       300.00),
('Pintura de para-choque',       450.00),
('Reparo de lataria',            500.00),
('Diagnóstico eletrônico',       100.00);


INSERT INTO peca (nome, categoria, fornecedor, preco_custo, preco_venda, qtd_estoque, estoque_minimo) VALUES
('Óleo de Motor 5W30 1L',  'Lubrificantes', 'Lubrax Distribuidora',  25.00,  40.00, 100, 20),
('Filtro de Óleo',         'Filtros',       'Mann Filtros',          15.00,  30.00,  60, 10),
('Pastilha de Freio',      'Freios',        'Fras-le',               70.00, 130.00,  40, 10),
('Bateria 60Ah',           'Elétrica',      'Moura Baterias',       280.00, 450.00,  15,  5),
('Correia Dentada',        'Motor',         'Gates do Brasil',       90.00, 170.00,  25,  5),
('Amortecedor Dianteiro',  'Suspensão',     'Cofap',                180.00, 320.00,  20,  4),
('Vela de Ignição',        'Motor',         'NGK',                   20.00,  40.00,  80, 16),
('Pneu Aro 15',            'Pneus',         'Pneus Brasília',       300.00, 480.00,  24,  8),
('Lâmpada de Farol',       'Elétrica',      'Osram',                 15.00,  35.00,  50, 10),
('Fluido de Freio 500ml',  'Lubrificantes', 'Lubrax Distribuidora',  18.00,  32.00,  45, 10);

INSERT INTO ordem_servico (placa, mat_func, data, hora, defeito, forma_pag, status) VALUES
('ABC1D23', 4, '2026-10-01', '08:30:00', 'Barulho no motor e óleo vencido',   'pix',      'concluida'),
('DEF2E34', 4, '2026-10-02', '09:00:00', 'Freio fazendo ruído',               'dinheiro', 'concluida'),
('GHI3F45', 4, '2026-10-05', '10:15:00', 'Carro puxando para a direita',      'cartao',   'concluida'),
('JKL4G56', 4, '2026-10-06', '14:00:00', 'Bateria descarregando',             'pix',      'concluida'),
('MNO5H67', 4, '2026-10-10', '08:00:00', 'Revisão dos 50 mil km',             'cartao',   'concluida'),
('PQR6I78', 4, '2026-10-15', '11:00:00', 'Para-choque amassado',              NULL,       'em andamento'),
('STU7J89', 4, '2026-10-20', '13:30:00', 'Suspensão batendo',                 NULL,       'em andamento'),
('VWX8K90', 4, '2026-10-25', '09:45:00', 'Correia dentada com ruído',         NULL,       'em andamento'),
('YZA9L01', 4, '2026-11-03', '15:00:00', 'Luz do painel acesa',               'dinheiro', 'concluida'),
('BCD0M12', 4, '2026-11-05', '16:30:00', 'Risco profundo na porta',           NULL,       'cancelada');

INSERT INTO servico_executado (num_os, id_servico, mat_func, quantidade, valor_cobrado, status) VALUES
(1,  1,  1, 1,  80.00, 'concluido'),
(2,  3,  3, 1, 150.00, 'concluido'),
(3,  2,  9, 1, 120.00, 'concluido'),
(4,  5,  2, 1,  50.00, 'concluido'),
(5,  4,  1, 1, 350.00, 'concluido'),
(6,  8,  7, 1, 450.00, 'em andamento'),
(7,  7,  3, 2, 600.00, 'em andamento'),
(8,  6,  1, 1, 400.00, 'em andamento'),
(9,  10, 2, 1, 100.00, 'concluido'),
(7,  2,  3, 1, 120.00, 'em andamento');

-- 1) TRIGGER DE BAIXA DE ESTOQUE
DELIMITER $$

CREATE TRIGGER trg_baixa_estoque
AFTER INSERT ON peca_utilizada -- roda depois de gravar
FOR EACH ROW  -- roda 1x para cada linha inserida 
BEGIN
    UPDATE peca
    SET qtd_estoque = qtd_estoque - NEW.qtd_usada -- subtrai a quantidade usada
    WHERE id_peca = NEW.id_peca; 
END$$

-- 2) TRIGGER DE BLOQUEIO DE VENDA ACIMA DO ESTOQUE
DELIMITER $$

CREATE TRIGGER trg_bloqueia_venda_sem_estoque
BEFORE INSERT ON peca_utilizada -- roda antes de gravar, serve para validar e bloquear 
FOR EACH ROW 
BEGIN
    IF NEW.qtd_usada > (SELECT qtd_estoque FROM peca WHERE id_peca = NEW.id_peca) THEN -- busca noestoque atual 
        SIGNAL SQLSTATE '45000'  -- gera um erro e cancela o insert
        SET MESSAGE_TEXT = 'Estoque insuficiente para a quantidade solicitada.'; 
    END IF;
END$$

DELIMITER ;

-- 3) TRIGGER: SÓ MECÂNICO EXECUTA SERVIÇO
DELIMITER $$

CREATE TRIGGER trg_so_mecanico_executa
BEFORE INSERT ON servico_executado
FOR EACH ROW
BEGIN
    DECLARE v_cargo VARCHAR(40);

    SELECT c.nome_cargo INTO v_cargo -- descobre cargo do funcionario
    FROM funcionario f
    JOIN cargo c ON c.cod_cargo = f.cod_cargo -- liga funcionario ao cargo 
    WHERE f.mat_func = NEW.mat_func;

    IF v_cargo <> 'Mecânico' THEN -- compara o cargo, se for diferente de mecânico dispara a mensagem e bloqueia 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Apenas funcionarios com o cargo de Mecanico podem executar servicos.';
    END IF;
END$$

DELIMITER ;


-- 4) TRIGGER: LIMITE DE 5 SERVIÇOS EM ANDAMENTO POR MECÂNICO
DELIMITER $$

CREATE TRIGGER trg_limite_5_servicos
BEFORE INSERT ON servico_executado
FOR EACH ROW
BEGIN
    IF NEW.status = 'em andamento'
       AND (SELECT COUNT(*)
            FROM servico_executado
            WHERE mat_func = NEW.mat_func
              AND status = 'em andamento') >= 5 THEN -- conta se tem mais de 5 serviços, se o novo seria o 6° já bloqueia 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O mecanico ja possui 5 servicos em andamento.';
    END IF;
END$$

DELIMITER ;

INSERT INTO peca_utilizada (num_os, id_peca, qtd_usada, preco_unitario) VALUES
(1, 1,  4,  40.00),
(1, 2,  1,  30.00),
(2, 3,  1, 130.00),
(2, 10, 1,  32.00),
(4, 4,  1, 450.00),
(5, 1,  4,  40.00),
(5, 2,  1,  30.00),
(5, 7,  4,  40.00),
(7, 6,  2, 320.00),
(8, 5,  1, 170.00);


-- CONSULTAS BÁSICAS 

-- 1) Mostrar todos os clientes
SELECT * 
FROM cliente;

-- 2) Mostrar nome, telefone e e-mail dos clientes
SELECT nome, telefone, email 
FROM cliente;

-- 3) Dados principais dos veículos
SELECT placa, marca, modelo, cor 
FROM veiculo;

-- 4) Serviços oferecidos e valor da mão de obra
SELECT descricao, valor_mao_de_obra 
FROM servico;

-- 5) Peças, preço de venda e quantidade em estoque
SELECT nome, categoria, preco_venda, qtd_estoque 
FROM peca;



-- CONSULTAS INTERMEDIÁRIAS


-- 1) Quais marcas de veículos a oficina atende?
-- DISTINCT remove dados repetidos
SELECT DISTINCT marca 
FROM veiculo;

-- 2) Qual o lucro e margem de cada peça? (colunas calculadas)
SELECT nome,
       preco_custo,
       preco_venda,
       preco_venda - preco_custo AS lucro_unitario,
       ROUND((preco_venda - preco_custo) / preco_custo * 100, 1) AS margem_percentual
FROM peca;

-- 3) Quais peças com preço de venda acima de R$ 100?
SELECT nome, preco_venda 
FROM peca 
WHERE preco_venda > 100;

-- 4) Quais os veículos Volkswagen ou Fiat fabricados a partir de 2015 ?
-- OR foi usado entre parenteses para que tivesse prioridade entre o  AND
SELECT placa, marca, modelo, ano_fab
FROM veiculo
WHERE (marca = 'Volkswagen' OR marca = 'Fiat') AND ano_fab >= 2015;

-- 5) Mostar quais ordens de serviço que NÃO estão concluídas
-- NOT inverte a condição 
SELECT num_os, placa, defeito, status
FROM ordem_servico
WHERE NOT status = 'concluida';

-- 6) Qual o valor total faturado em peças?
-- SUM multiplica 
SELECT SUM(qtd_usada * preco_unitario) AS total_em_pecas
FROM peca_utilizada;

-- 7) Relação de média, maior e menor valor de mão de obra
SELECT round(AVG(valor_mao_de_obra),2) AS media,
       MAX(valor_mao_de_obra) AS maior_valor,
       MIN(valor_mao_de_obra) AS menor_valor
FROM servico;

-- 8) Quantas ordens de serviço foram abertas (exceto canceladas)?
-- COUNT conta as linhas, <> diferente de 
SELECT COUNT(*) AS total_os 
FROM ordem_servico 
WHERE status <> 'cancelada';

-- 9) Quais os clientes o nome começa com "M"
SELECT nome 
FROM cliente 
WHERE nome LIKE 'M%';

-- 10) Quais as ordens de serviço abertas entre 01/10 e 15/10/2026
-- BETWEEN filtra entre as datas fornecidas 
SELECT num_os, placa, data, defeito
FROM ordem_servico
WHERE data BETWEEN '2026-10-01' AND '2026-10-15';

-- 11) Mostrar veículos das marcas Fiat, Ford ou Honda
-- IN foi usado como atalho para nao ter varios OR
SELECT placa, marca, modelo 
FROM veiculo 
WHERE marca IN ('Fiat', 'Ford', 'Honda');

-- 12) Comparar as peças da mais cara para a mais barata
-- ORDER BY DESC ordena do maior para o menor 
SELECT nome, preco_venda 
FROM peca 
ORDER BY preco_venda DESC;

-- 13) Quantidade de ordens de serviço por status
-- Junta as linhas por status e conta quantas em cada grupo
SELECT status, COUNT(*) AS quantidade
FROM ordem_servico
GROUP BY status;

-- 14) 	Quais mecânicos executaram  2 ou mais serviços?
-- JOIN foi usado para fornecer o nome do mecanico ao invez do numero, HAVING filtra depois de agrupar
SELECT f.nome AS mecanico, COUNT(*) AS qtd_servicos
FROM servico_executado se
JOIN funcionario f ON se.mat_func = f.mat_func
GROUP BY f.nome
HAVING COUNT(*) >= 2;

-- 15) Peças com preço de venda acima da média
-- AVG para media e > para mostra apenas os que estão acima da media
SELECT nome, preco_venda
FROM peca
WHERE preco_venda > (SELECT AVG(preco_venda) FROM peca);

-- 16) Mostrar funcionários com cargo e salário
-- JOIN liga o cod_cargo a tabela cargo, para mostrar nome do cargo e salario, e ordena do maior p/ menor
SELECT f.nome, c.nome_cargo, c.salario
FROM funcionario f
JOIN cargo c ON f.cod_cargo = c.cod_cargo
ORDER BY c.salario DESC;

-- 17) Mostrar lista única de pessoas ligadas à oficina (clientes e funcionários)
-- os 2 SELECT listam em uma unica lista clientes e funcionarios, UNION garante que não haja repetidas 
SELECT nome, 'Cliente' AS tipo FROM cliente
UNION
SELECT nome, 'Funcionário' AS tipo FROM funcionario;


-- CONSULTAS AVANÇADAS 

-- 1) Trigger de baixa de estoque
-- (O trigger trg_baixa_estoque foi criado antes dos INSERTs de peca_utilizada, lá em cima)

-- Teste:

SELECT nome, qtd_estoque 
FROM peca 
WHERE id_peca = 4;

INSERT INTO peca_utilizada (num_os, id_peca, qtd_usada, preco_unitario)
VALUES (9, 4, 2, 450.00);

SELECT nome, qtd_estoque 
FROM peca 
WHERE id_peca = 4;  


-- 4) Limite de 5 serviços em andamento por mecânico
-- Teste: 

-- O mecânico 3 (Diego) já tem 2 em andamento. Estes 3 inserts funcionam (chega a 5):
INSERT INTO servico_executado (num_os, id_servico, mat_func, quantidade, valor_cobrado, status)
VALUES (7, 1, 3, 1, 80.00, 'em andamento');
INSERT INTO servico_executado (num_os, id_servico, mat_func, quantidade, valor_cobrado, status)
VALUES (7, 1, 3, 1, 80.00, 'em andamento');
INSERT INTO servico_executado (num_os, id_servico, mat_func, quantidade, valor_cobrado, status)
VALUES (7, 1, 3, 1, 80.00, 'em andamento');

-- Prova de que ele chegou a 5:
SELECT mat_func, COUNT(*) AS em_andamento
FROM servico_executado
WHERE mat_func = 3 AND status = 'em andamento'
GROUP BY mat_func;

-- o 6° já bloqueia 
INSERT INTO servico_executado (num_os, id_servico, mat_func, quantidade, valor_cobrado, status)
VALUES (7, 1, 3, 1, 80.00, 'em andamento'); 


--  Procedure para fechar a OS
DELIMITER $$

CREATE PROCEDURE fechar_os(IN p_num_os INT, IN p_forma_pag VARCHAR(20))
BEGIN
    UPDATE servico_executado
    SET status = 'concluido'
    WHERE num_os = p_num_os;

    UPDATE ordem_servico
    SET status = 'concluida',
        forma_pag = p_forma_pag
    WHERE num_os = p_num_os;
END$$
fechar_os
DELIMITER ;

-- Teste:

CALL fechar_os(6, 'pix');

SELECT num_os, status, forma_pag 
FROM ordem_servico 
WHERE num_os = 6;

SELECT num_os, status 
FROM servico_executado 
WHERE num_os = 6; 