/*
 Disciplina: Programação e Desenvolvimento em Banco de Dados
 Projeto: Banco de Dados do E-Commerce Amerikanas
 Data: 01/04/2026
 Versão: 1.0
 Observações:
 */


----------------------------
-- Seção Índices (outros)
----------------------------

CREATE INDEX idx_cliente_tipo ON enderecos (id_cliente, tipo_endereco);


-----------------------------------
-- Seção Alterando Nomes dos Campos
------------------------------------
ALTER TABLE `amerikanas`.`tipo_logradouro` 
CHANGE COLUMN `id_tipo_logradouro` `tipo_logradouro` VARCHAR(50) NOT NULL ;


-----------------------------------
-- Seção Novas Constraints (outros)
------------------------------------
ALTER TABLE `amerikanas`.`enderecos` 
ADD CONSTRAINT `fk_tipo_logradouro`
  FOREIGN KEY (`id_tipo_logradouro`)
  REFERENCES `amerikanas`.`tipo_logradouro` (`id_tipo_logradouro`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `amerikanas`.`enderecos` 
ADD CONSTRAINT `fk_tipo_logradouro`
  FOREIGN KEY (`id_tipo_logradouro`)
  REFERENCES `amerikanas`.`tipo_logradouro` (`id_tipo_logradouro`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `amerikanas`.`itens_pedidos` 
DROP CONSTRAINT `fk_itens_pedidos_clientes`

ALTER TABLE `amerikanas`.`enderecos` 
DROP CONSTRAINT `fk_enderecos_clientes`

-----------------------------------
-- Seção Novas Triggers (outros)
------------------------------------
DELIMITER $$

CREATE TRIGGER check_data_pedido_insert
BEFORE INSERT ON itens_pedidos
FOR EACH ROW
BEGIN
    IF NEW.dt_hr_pedido > NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data/hora do pedido não pode ser futura';
    END IF;
END$$

CREATE TRIGGER check_data_pedido_update
BEFORE UPDATE ON itens_pedidos
FOR EACH ROW
BEGIN
    IF NEW.dt_hr_pedido > NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data/hora do pedido não pode ser futura';
    END IF;
END$$

DELIMITER ;









----------------------------
-- Seção carga das tabelas
----------------------------

-- Insert categorias_produto
INSERT INTO categorias_produto (nome_categoria, descricao_categoria) VALUES
('Eletrônicos', 'Produtos eletrônicos em geral'),
('Vestuário', 'Roupas e acessórios'),
('Calçados', 'Sapatos, tênis e sandálias'),
('Alimentos', 'Alimentos e bebidas'),
('Livros', 'Livros e publicações'),
('Móveis', 'Móveis para casa e escritório'),
('Esportes', 'Artigos esportivos'),
('Beleza', 'Produtos de beleza e cuidados pessoais');

-- Insert status_pedido
INSERT INTO status_pedido (nome_status, descricao_status) VALUES
('Aguardando Pagamento', 'Pedido realizado mas pagamento ainda não foi confirmado'),
('Pagamento Confirmado', 'Pagamento aprovado e confirmado'),
('Em Preparação', 'Pedido está sendo preparado'),
('Enviado', 'Pedido foi enviado ao cliente'),
('Entregue', 'Pedido entregue ao cliente'),
('Cancelado', 'Pedido cancelado'),
('Devolvido', 'Pedido foi devolvido pelo cliente');

-- Insert tipo_endereco
INSERT INTO `tipo_endereco` (`descricao_tipo_endereco`) VALUES
    -- Essenciais (uso diário)
    ('Residencial'),
    ('Comercial'),
    ('Cobrança'),
    ('Entrega'),
    ('Correspondência'),
    ('Trabalho'),
    ('Faturamento'),
    ('Principal'),
    ('Secundário'),
    
    -- Residenciais
    ('Casa'),
    ('Apartamento'),
    ('Cobertura'),
    ('Kitnet'),
    ('Studio'),
    ('Flat'),
    ('Sobrado'),
    
    -- Rurais
    ('Sítio'),
    ('Chácara'),
    ('Fazenda'),
    
    -- Comerciais
    ('Comércio'),
    ('Indústria'),
    ('Filial'),
    ('Matriz'),
    ('Depósito'),
    ('Galpão'),
    ('Loja'),
    ('Shopping'),
    ('Quiosque'),
    ('Box'),
    ('Estande'),
    
    -- Profissionais
    ('Consultório'),
    ('Clínica'),
    ('Escritório'),
    ('Sala'),
    ('Conjunto Comercial'),
    
    -- Alternativos
    ('Alternativo'),
    ('Temporário'),
    ('Permanente'),
    ('Entrega Rápida'),
    ('Retirada');


-- Insert tipo_logradouro

-- Inserir tipos de logradouro padrão
INSERT INTO `tipo_logradouro` (`descricao_tipo_logradouro`) VALUES
('Rua'),
('Avenida'),
('Alameda'),
('Travessa'),
('Praça'),
('Rodovia'),
('Estrada'),
('Viela'),
('Parque'),
('Largo'),
('Beco'),
('Passagem'),
('Vila'),
('Jardim'),
('Quadra'),
('Conjunto'),
('Bloco'),
('Sítio'),
('Chácara'),
('Fazenda'),
('Condomínio'),
('Residencial'),
('Loteamento'),
('Colônia'),
('Servidão'),
('Via'),
('Caminho'),
('Travessa'),
('Galeria'),
('Marginal'),
('Elevada'),
('Rotatória'),
('Ponte'),
('Viaduto'),
('Túnel'),
('Trecho'),
('Entrebloco'),
('Área'),
('Setor'),
('Aeroporto'),
('Estação'),
('Porto'),
('Terminal'),
('Universidade'),
('Campus'),
('Shopping'),
('Centro'),
('Complexo'),
('Núcleo'),
('Pólo'),
('Distrito');







ALTER TABLE enderecos 
MODIFY COLUMN id_endereco INT AUTO_INCREMENT COMMENT 'Chave primária da tabela',
MODIFY COLUMN id_cliente INT NOT NULL COMMENT 'Chave estrangeira referenciando o cliente',
MODIFY COLUMN cep VARCHAR(9) NOT NULL COMMENT 'CEP no formato 00000-000',
MODIFY COLUMN tipo_logradouro VARCHAR(50) NOT NULL COMMENT 'Tipo do logradouro (Rua, Avenida, etc)',
MODIFY COLUMN tipo_endereco VARCHAR(30) NOT NULL COMMENT 'Tipo de endereço (Residencial, Comercial, etc)',
MODIFY COLUMN nome_logradouro VARCHAR(200) NOT NULL COMMENT 'Nome do logradouro',
MODIFY COLUMN numero_logradouro VARCHAR(20) NOT NULL COMMENT 'Número do endereço',
MODIFY COLUMN complemento_logradouro VARCHAR(100) COMMENT 'Complemento (apartamento, sala, etc)',
MODIFY COLUMN ponto_referencia VARCHAR(200) COMMENT 'Ponto de referência',
MODIFY COLUMN bairro VARCHAR(100) NOT NULL COMMENT 'Bairro',
MODIFY COLUMN cidade VARCHAR(100) NOT NULL COMMENT 'Cidade',
MODIFY COLUMN estado VARCHAR(50) NOT NULL COMMENT 'Nome do estado',
MODIFY COLUMN uf CHAR(2) NOT NULL COMMENT 'Sigla do estado (UF)';


