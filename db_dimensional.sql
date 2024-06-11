CREATE DATABASE `db_restaurante_dimensional` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_restaurante_dimensional`;

-- Tabela de Dimensão: DimCliente
CREATE TABLE `DimCliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `cpf_cliente` varchar(14) NOT NULL,
  `nome_cliente` varchar(150) NOT NULL,
  `email_cliente` varchar(45) DEFAULT NULL,
  `telefone_cliente` varchar(45) DEFAULT NULL,
  `id_empresa` int DEFAULT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão: DimEmpresa
CREATE TABLE `DimEmpresa` (
  `id_empresa` int NOT NULL AUTO_INCREMENT,
  `nome_empresa` varchar(150) NOT NULL,
  PRIMARY KEY (`id_empresa`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão: DimMesa
CREATE TABLE `DimMesa` (
  `codigo_mesa` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `num_pessoa_mesa` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`codigo_mesa`),
  KEY `fk_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `DimCliente` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=16384 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão: DimDataHora
CREATE TABLE `DimDataHora` (
  `id_data_hora` int NOT NULL AUTO_INCREMENT,
  `data_hora` datetime NOT NULL,
  `data` date NOT NULL,
  `hora` time NOT NULL,
  `dia` int NOT NULL,
  `mes` int NOT NULL,
  `ano` int NOT NULL,
  PRIMARY KEY (`id_data_hora`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão: DimTipoPrato
CREATE TABLE `DimTipoPrato` (
  `codigo_tipo_prato` int NOT NULL AUTO_INCREMENT,
  `nome_tipo_prato` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo_tipo_prato`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão: DimPrato
CREATE TABLE `DimPrato` (
  `codigo_prato` int NOT NULL AUTO_INCREMENT,
  `codigo_tipo_prato` int NOT NULL,
  `nome_prato` varchar(45) NOT NULL,
  `preco_unitario_prato` double NOT NULL,
  `categoria_prato` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`codigo_prato`),
  KEY `fk_tipo_prato_idx` (`codigo_tipo_prato`),
  CONSTRAINT `fk_tipo_prato` FOREIGN KEY (`codigo_tipo_prato`) REFERENCES `DimTipoPrato` (`codigo_tipo_prato`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Dimensão: DimSituacaoPedido
CREATE TABLE `DimSituacaoPedido` (
  `codigo_situacao_pedido` int NOT NULL AUTO_INCREMENT,
  `nome_situacao_pedido` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo_situacao_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de Fato: FatoPedido
CREATE TABLE `FatoPedido` (
  `id_fato_pedido` int NOT NULL AUTO_INCREMENT,
  `codigo_mesa` int NOT NULL,
  `codigo_prato` int NOT NULL,
  `quantidade_pedido` int NOT NULL,
  `codigo_situacao_pedido` int NOT NULL,
  `data_hora_entrada` int NOT NULL,
  `data_hora_saida` int NOT NULL,
  `valor_total_pedido` double NOT NULL,
  PRIMARY KEY (`id_fato_pedido`),
  KEY `fk_mesa_idx` (`codigo_mesa`),
  KEY `fk_prato_idx` (`codigo_prato`),
  KEY `fk_situacao_pedido_idx` (`codigo_situacao_pedido`),
  KEY `fk_data_hora_entrada_idx` (`data_hora_entrada`),
  KEY `fk_data_hora_saida_idx` (`data_hora_saida`),
  CONSTRAINT `fk_mesa` FOREIGN KEY (`codigo_mesa`) REFERENCES `DimMesa` (`codigo_mesa`),
  CONSTRAINT `fk_prato` FOREIGN KEY (`codigo_prato`) REFERENCES `DimPrato` (`codigo_prato`),
  CONSTRAINT `fk_situacao_pedido` FOREIGN KEY (`codigo_situacao_pedido`) REFERENCES `DimSituacaoPedido` (`codigo_situacao_pedido`),
  CONSTRAINT `fk_data_hora_entrada` FOREIGN KEY (`data_hora_entrada`) REFERENCES `DimDataHora` (`id_data_hora`),
  CONSTRAINT `fk_data_hora_saida` FOREIGN KEY (`data_hora_saida`) REFERENCES `DimDataHora` (`id_data_hora`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from dimcliente;

-- Exemplo de consulta: Qual o cliente que mais fez pedidos por ano
SELECT id_cliente, nome_cliente, COUNT(id_fato_pedido) AS total_pedidos, YEAR(data_hora) AS ano
FROM FatoPedido
JOIN DimDataHora ON FatoPedido.data_hora_entrada = DimDataHora.id_data_hora
GROUP BY id_cliente, ano
ORDER BY total_pedidos DESC
LIMIT 1;
