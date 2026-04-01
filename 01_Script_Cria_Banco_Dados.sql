/*
 Disciplina: Programação e Desenvolvimento em Banco de Dados
 Projeto: Banco de Dados do E-Commerce Amerikanas
 Data: 01/04/2026
 Versão: 1.0
 Observações:
 */
--------------------------------------------
/* 
 Criação do Repositório de Nome Amerikanas
 */
--------------------------------------------
create schema Amerikanas;

--------------------------------------------
/* 
 Setando/Direcionando o banco/schema Amerikanas
 */
------------------------------------
USE Amerikanas;

------------------------------------
/* Bloco Criação das Tabelas*/
------------------------------------
------------------------------------
-- 01 -  TABELA CLIENTES
------------------------------------
CREATE TABLE `clientes` (
    `id_cliente` int NOT NULL AUTO_INCREMENT,
    `nome_completo_cliente` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
    `email_cliente` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
    `telefone_cliente` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
    `rg_cliente` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
    `cpf_cliente` varchar(14) COLLATE utf8mb4_unicode_ci NOT NULL,
    `genero_cliente` enum(
        'Masculino',
        'Feminino',
        'Outro',
        'Prefiro não informar'
    ) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `dt_nasc_cliente` date NOT NULL,
    PRIMARY KEY (`id_cliente`),
    UNIQUE KEY `cpf_cliente` (`cpf_cliente`),
    KEY `idx_email` (`email_cliente`),
    KEY `idx_cpf` (`cpf_cliente`),
    KEY `idx_nome` (`nome_completo_cliente`),
    CONSTRAINT `check_cpf_valido` CHECK (
        (
            length(
                replace(
                    replace(`cpf_cliente`, _utf8mb4 '.', _utf8mb4 ''),
                    _utf8mb4 '-',
                    _utf8mb4 ''
                )
            ) = 11
        )
    ),
    CONSTRAINT `check_email_valido` CHECK ((`email_cliente` like _utf8mb4 '%_@__%.__%'))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

------------------------------------
-- 02 - TABELA ENDEREÇOS
------------------------------------
CREATE TABLE `enderecos` (
    `id_endereco` int NOT NULL AUTO_INCREMENT,
    `id_cliente` int NOT NULL,
    `cep` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
    `tipo_logradouro` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ex: Rua, Avenida, Praça, Travessa',
    `tipo_endereco` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ex: Residencial, Comercial, Cobrança, Entrega',
    `nome_logradouro` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
    `numero_logradouro` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
    `complemento_logradouro` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `ponto_referencia` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `bairro` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
    `cidade` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
    `estado` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
    `uf` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_endereco`),
    KEY `idx_cliente` (`id_cliente`),
    KEY `idx_cep` (`cep`),
    KEY `idx_cidade` (`cidade`),
    KEY `idx_uf` (`uf`),
    CONSTRAINT `fk_enderecos_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `check_cep_valido` CHECK (
        (
            length(replace(`cep`, _utf8mb4 '-', _utf8mb4 '')) = 8
        )
    ),
    CONSTRAINT `check_uf_valida` CHECK (
        (
            `uf` in (
                _utf8mb4 'AC',
                _utf8mb4 'AL',
                _utf8mb4 'AP',
                _utf8mb4 'AM',
                _utf8mb4 'BA',
                _utf8mb4 'CE',
                _utf8mb4 'DF',
                _utf8mb4 'ES',
                _utf8mb4 'GO',
                _utf8mb4 'MA',
                _utf8mb4 'MT',
                _utf8mb4 'MS',
                _utf8mb4 'MG',
                _utf8mb4 'PA',
                _utf8mb4 'PB',
                _utf8mb4 'PR',
                _utf8mb4 'PE',
                _utf8mb4 'PI',
                _utf8mb4 'RJ',
                _utf8mb4 'RN',
                _utf8mb4 'RS',
                _utf8mb4 'RO',
                _utf8mb4 'RR',
                _utf8mb4 'SC',
                _utf8mb4 'SP',
                _utf8mb4 'SE',
                _utf8mb4 'TO'
            )
        )
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

------------------------------------
-- 03 - TABELA STATUS PEDIDO
------------------------------------
CREATE TABLE status_pedido (
    id_status_pedido INT AUTO_INCREMENT PRIMARY KEY,
    nome_status VARCHAR(50) NOT NULL UNIQUE,
    descricao_status VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nome_status (nome_status)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

------------------------------------
-- 04 - TABELA ITENS PEDIDO
------------------------------------
CREATE TABLE itens_pedidos (
    id_item_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_cliente INT NOT NULL,
    dt_hr_pedido DATETIME NOT NULL,
    id_status_pedido INT NOT NULL,
    quantidade_itens INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_pedido (id_pedido),
    INDEX idx_cliente (id_cliente),
    INDEX idx_status (id_status_pedido),
    INDEX idx_dt_hr (dt_hr_pedido),
    INDEX idx_cliente_status (id_cliente, id_status_pedido),
    CONSTRAINT fk_itens_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_itens_pedidos_status FOREIGN KEY (id_status_pedido) REFERENCES status_pedido(id_status_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT check_quantidade_itens CHECK (quantidade_itens > 0) -- Constraint da data removida
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

------------------------------------
-- 05 - TABELA ITENS PEDIDO DETALHES
------------------------------------
CREATE TABLE itens_pedido_detalhes (
    id_item_detalhe INT AUTO_INCREMENT PRIMARY KEY,
    id_item_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    nome_produto VARCHAR(200) NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    preco_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_item_pedido (id_item_pedido),
    INDEX idx_produto (id_produto),
    CONSTRAINT fk_detalhes_itens_pedidos FOREIGN KEY (id_item_pedido) REFERENCES itens_pedidos(id_item_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_quantidade_detalhe CHECK (quantidade > 0),
    CONSTRAINT check_preco_unitario CHECK (preco_unitario >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

----------------------------------
-- 06 - TABELA CATEGORIA PRODUTOS
----------------------------------
CREATE TABLE categorias_produto (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL UNIQUE,
    descricao_categoria VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nome_categoria (nome_categoria)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

----------------------------------
-- 07 - TABELA PRODUTOS
----------------------------------
CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    preco_produto DECIMAL(10, 2) NOT NULL,
    descricao_produto TEXT NOT NULL,
    imagem_produto VARCHAR(500),
    som_produto VARCHAR(500),
    categoria_produto INT NOT NULL,
    cor_produto VARCHAR(50),
    -- Metadados adicionais para melhor organização
    nome_produto VARCHAR(200) NOT NULL,
    sku_produto VARCHAR(50) UNIQUE COMMENT 'Código SKU do produto',
    estoque_produto INT DEFAULT 0,
    altura_produto DECIMAL(10, 2) COMMENT 'Altura em cm',
    largura_produto DECIMAL(10, 2) COMMENT 'Largura em cm',
    profundidade_produto DECIMAL(10, 2) COMMENT 'Profundidade em cm',
    peso_produto DECIMAL(10, 2) COMMENT 'Peso em kg',
    destaque_produto BOOLEAN DEFAULT FALSE,
    ativo_produto BOOLEAN DEFAULT TRUE,
    -- Data de criação e atualização
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- Índices para melhor performance
    INDEX idx_categoria (categoria_produto),
    INDEX idx_preco (preco_produto),
    INDEX idx_destaque (destaque_produto),
    INDEX idx_ativo (ativo_produto),
    INDEX idx_nome_produto (nome_produto),
    INDEX idx_sku (sku_produto),
    INDEX idx_cor (cor_produto),
    -- Índice FULLTEXT para busca em descrições
    FULLTEXT INDEX idx_busca_produto (nome_produto, descricao_produto),
    -- Chave estrangeira
    CONSTRAINT fk_produtos_categoria FOREIGN KEY (categoria_produto) REFERENCES categorias_produto(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE,
    -- Constraints
    CONSTRAINT check_preco_positivo CHECK (preco_produto >= 0),
    CONSTRAINT check_estoque CHECK (estoque_produto >= 0),
    CONSTRAINT check_dimensoes CHECK (
        (
            altura_produto IS NULL
            OR altura_produto >= 0
        )
        AND (
            largura_produto IS NULL
            OR largura_produto >= 0
        )
        AND (
            profundidade_produto IS NULL
            OR profundidade_produto >= 0
        )
        AND (
            peso_produto IS NULL
            OR peso_produto >= 0
        )
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

------------------------------
-- 08 - TABELA IMAGENS PRODUTO
------------------------------
CREATE TABLE imagens_produto (
    id_imagem INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    url_imagem VARCHAR(500) NOT NULL,
    ordem_imagem INT DEFAULT 0,
    principal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_produto_imagem (id_produto),
    INDEX idx_ordem (ordem_imagem),
    CONSTRAINT fk_imagens_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_url_imagem CHECK (
        url_imagem LIKE 'http%://%'
        OR url_imagem LIKE '/%'
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

----------------------------
-- 09 - TABELA SONS PRODUTO
----------------------------
CREATE TABLE sons_produto (
    id_som INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    url_som VARCHAR(500) NOT NULL,
    descricao_som VARCHAR(255),
    duracao_segundos INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_produto_som (id_produto),
    CONSTRAINT fk_sons_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_url_som CHECK (
        url_som LIKE 'http%://%'
        OR url_som LIKE '/%'
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

----------------------------
-- 10 - TABELA CORES PRODUTO
----------------------------
CREATE TABLE cores_produto (
    id_cor INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    nome_cor VARCHAR(50) NOT NULL,
    codigo_cor VARCHAR(20) COMMENT 'Código hexadecimal ou RGB da cor',
    estoque_cor INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_produto_cor (id_produto),
    INDEX idx_nome_cor (nome_cor),
    CONSTRAINT fk_cores_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT check_estoque_cor CHECK (estoque_cor >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;