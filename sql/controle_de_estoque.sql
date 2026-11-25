-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: estoque_bd
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias_tb`
--

create database if not exists estoque_bd
default character set utf8mb4 
collate utf8mb4_0900_ai_ci;

use estoque_bd;

DROP TABLE IF EXISTS `categorias_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_tb` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nome_categoria` varchar(100) NOT NULL,
  `descricao_categoria` varchar(255) DEFAULT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nome_categoria` (`nome_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_tb`
--

LOCK TABLES `categorias_tb` WRITE;
/*!40000 ALTER TABLE `categorias_tb` DISABLE KEYS */;
INSERT INTO `categorias_tb` VALUES (1,'Informática','Periféricos e acessórios de informática','2026-11-24 18:26:14'),(2,'Escritório','Material utilizado em escritórios','2026-11-24 18:26:14');
/*!40000 ALTER TABLE `categorias_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historico_tb`
--

DROP TABLE IF EXISTS `historico_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_tb` (
  `id_historico` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `acao` varchar(60) NOT NULL,
  `descricao` text,
  `entidade` varchar(60) DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `resultado` enum('SUCESSO','FALHA') NOT NULL DEFAULT 'SUCESSO',
  `data_hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_acesso` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_historico`),
  KEY `idx_hist_usuario_data` (`id_usuario`,`data_hora`),
  KEY `idx_hist_acao_data` (`acao`,`data_hora`),
  CONSTRAINT `fk_hist_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios_tb` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_tb`
--

LOCK TABLES `historico_tb` WRITE;
/*!40000 ALTER TABLE `historico_tb` DISABLE KEYS */;
INSERT INTO `historico_tb` VALUES (1,1,'USUARIO_CRIADO','Conta admin criada no preparo inicial','usuarios_tb',1,'SUCESSO','2026-11-25 16:53:26',NULL),(2,2,'USUARIO_CRIADO','Conta operador criada no preparo inicial','usuarios_tb',2,'SUCESSO','2026-11-25 16:54:02',NULL),(3,1,'LOGIN_SUCESSO','Acesso ao sistema','usuarios_tb',NULL,'SUCESSO','2026-11-25 16:54:36',NULL),(4,NULL,'TESTE_CONEXAO','Teste manual sem login autenticado','sistema',NULL,'SUCESSO','2026-11-25 16:56:32',NULL);
/*!40000 ALTER TABLE `historico_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimentacoes_tb`
--

DROP TABLE IF EXISTS `movimentacoes_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimentacoes_tb` (
  `id_movimentacao` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `id_usuario` int DEFAULT NULL,
  `tipo_movimentacao` enum('ENTRADA','SAIDA') NOT NULL,
  `quantidade` int NOT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  `data_movimentacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimentacao`),
  KEY `fk_mov_produto` (`id_produto`),
  KEY `fk_mov_usuario` (`id_usuario`),
  KEY `idx_mov_data` (`data_movimentacao`),
  CONSTRAINT `fk_mov_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos_tb` (`id_produto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_mov_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios_tb` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_mov_quantidade` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimentacoes_tb`
--

LOCK TABLES `movimentacoes_tb` WRITE;
/*!40000 ALTER TABLE `movimentacoes_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `movimentacoes_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_tb`
--

DROP TABLE IF EXISTS `produtos_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos_tb` (
  `id_produto` int NOT NULL AUTO_INCREMENT,
  `id_categoria` int NOT NULL,
  `nome_produto` varchar(150) NOT NULL,
  `codigo_barras` varchar(60) DEFAULT NULL,
  `descricao_produto` text,
  `preco_custo` decimal(10,2) NOT NULL DEFAULT '0.00',
  `preco_venda` decimal(10,2) NOT NULL DEFAULT '0.00',
  `estoque_atual` int NOT NULL DEFAULT '0',
  `estoque_minimo` int NOT NULL DEFAULT '0',
  `imagem` varchar(255) DEFAULT NULL,
  `data_vencimento` date DEFAULT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_produto`),
  UNIQUE KEY `codigo_barras` (`codigo_barras`),
  KEY `fk_produto_categoria` (`id_categoria`),
  KEY `idx_produto_nome` (`nome_produto`),
  KEY `idx_produto_vencimento` (`data_vencimento`),
  CONSTRAINT `fk_produto_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_tb` (`id_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_estoque` CHECK (((`estoque_atual` >= 0) and (`estoque_minimo` >= 0))),
  CONSTRAINT `chk_precos` CHECK (((`preco_custo` >= 0) and (`preco_venda` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_tb`
--

LOCK TABLES `produtos_tb` WRITE;
/*!40000 ALTER TABLE `produtos_tb` DISABLE KEYS */;
INSERT INTO `produtos_tb` VALUES (1,2,'Papel A4','789000000002',NULL,18.00,29.90,0,5,'papel-a4.jpg',NULL,'2026-11-24 18:28:22'),(3,1,'Mouse USB','789000000001',NULL,25.00,49.90,0,3,'mouse-usb.jpg',NULL,'2026-11-24 18:28:27');
/*!40000 ALTER TABLE `produtos_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_tb`
--

DROP TABLE IF EXISTS `usuarios_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_tb` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nome_usuario` varchar(100) NOT NULL,
  `login_usuario` varchar(60) NOT NULL,
  `email_usuario` varchar(150) NOT NULL,
  `senha_usuario` varchar(255) NOT NULL,
  `foto_usuario` varchar(255) NOT NULL DEFAULT 'usuario.jpg',
  `nivel_usuario` tinyint unsigned NOT NULL DEFAULT '0',
  `ativo_usuario` tinyint NOT NULL DEFAULT '1',
  `data_cadastro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `login_usuario` (`login_usuario`),
  UNIQUE KEY `email_usuario` (`email_usuario`),
  CONSTRAINT `chk_ativo_usuario` CHECK ((`ativo_usuario` in (0,1))),
  CONSTRAINT `chk_nivel_usuario` CHECK ((`nivel_usuario` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_tb`
--

LOCK TABLES `usuarios_tb` WRITE;
/*!40000 ALTER TABLE `usuarios_tb` DISABLE KEYS */;
INSERT INTO `usuarios_tb` VALUES (1,'Admin','admin','admin@electron.com','scrypt$2f58937188e44dc10770def4b56bb10c$bed27df2bfca278fb843fcca067a0380c7c2d63d92a3cc36b759e565023c22b141742d422ef2792d752d1267f1650f40a2b492d3e208e031d57f12bf9a0b847f','usuario.jpg',1,1,'2026-11-25 16:53:26'),(2,'Usuario','operador','usuario@electron.com','scrypt$ae0bd4f042a0294e3fb66c674d157153$a3e58aaeef4851b02948aa814cccb13df95ec53fa36578e52c15f6598b7d4845e7ab3b138651d19710b2b02f43c4e92528e067b46e958a16547359d43b13af5f','usuario.jpg',0,1,'2026-11-25 16:54:02');
/*!40000 ALTER TABLE `usuarios_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-25 14:08:50
