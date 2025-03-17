-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: MonitorizareTraffic
-- ------------------------------------------------------
-- Server version	8.0.40-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `evenimente_sportive`
--

DROP TABLE IF EXISTS `evenimente_sportive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evenimente_sportive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `data` date NOT NULL,
  `descriere` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evenimente_sportive`
--

LOCK TABLES `evenimente_sportive` WRITE;
/*!40000 ALTER TABLE `evenimente_sportive` DISABLE KEYS */;
INSERT INTO `evenimente_sportive` VALUES (1,'2025-01-05','Meci de fotbal - Romania vs. Franta. Romania castiga meciul in fata Francezilor la diferenta de 2 goluri.'),(2,'2025-01-20','Meci de baschet - U-BT Cluj vs. CSU Sibiu. Urmeaza un meci greu pentru Sibieni. S-au vandut deja toate biletele.'),(3,'2025-02-05','Turneu de tenis - Bucuresti Open'),(4,'2025-04-12','Maratonul de la Viena. Pe data de 12 aprilie se da startul celui mai mare Maraton din Europa.'),(5,'2025-03-01','Meci de volei - CSM Bucuresti vs. Dinamo. Va fi un meci cu trofeul pe masa. Pe 1 martie, de ziua martisorului vom afla cine sunt campionii Romaniei la handbal.'),(6,'2025-01-28','Campionatul Mondial de Handbal - Finala. S-au vandut toate biletele pentru acest meci si vor fi spectatori din peste 20 de tari.'),(7,'2025-02-10','Meci de rugby - Steaua vs. Timisoara'),(8,'2025-04-08','Turneu de gimnastica - Campionatele Mondiale. In primavara incepe turneul mondial de gimnastica unde avem 2 romance care concureaza!'),(9,'2025-03-15','Cupa Davis - Romania vs. Spania. E timpul sa sustinem din nou sportivii romani la tenis!'),(10,'2025-02-14','Meci de fotbal - Barcelona vs. Real Madrid. Dupa 2 luni avem parte din nou de un El Clasico!'),(11,'2025-06-25','Campionatele Europene de Atletism. In vara tinem pumnii stransi pentru concurentii nostri de la atletism!'),(12,'2025-01-18','Meci de handbal - HC Zalau vs. SCM Ramnicu Valcea. Urmeaza un meci de neratat intre doua echipe cu o galerie galagioasa.'),(13,'2025-01-30','Supercupa Italiei la Fotbal. '),(14,'2025-03-05','Meci de fotbal - Manchester United vs. Liverpool. Cele doua echipe sunt la distanta de un singur punct. Urmeaza sa aflam cine urca pe primul loc in clasament.'),(15,'2025-06-03','Finala UEFA Champions League. Finala se va disputa intre Bayern Munchen si Manchester City.'),(16,'2025-05-22','Campionatul Mondial de Fotbal - Etapa preliminara'),(17,'2025-07-01','Turneu de ciclism - Turul Frantei. Este cel mai lung traseu de ciclism. Sigur nu trebuie ratat de catre cei pasionati!'),(18,'2025-03-12','Meci de baschet - Fenerbahce vs. Real Madrid'),(19,'2025-05-10','Campionatul Mondial de Formula 1 - Monaco. Max Verstappen este intr-o forma excelenta. Pare ca urmeaza sa castige din nou aceasta cursa.'),(20,'2025-01-25','Meci de volei - CSM Targoviste vs. Volei Alba Blaj. Cele doua echipe incearca sa se salveze de la retrogradare.'),(21,'2025-05-25','Turneu de tenis - Roland Garros. Urmeaza sa o vedem si pe Simona Halep in teren dupa o pauza lunga.');
/*!40000 ALTER TABLE `evenimente_sportive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidente`
--

DROP TABLE IF EXISTS `incidente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_sofer` int DEFAULT NULL,
  `detalii` varchar(255) DEFAULT NULL,
  `data_inregistrare_incident` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sofer` (`id_sofer`),
  CONSTRAINT `fk_sofer` FOREIGN KEY (`id_sofer`) REFERENCES `soferi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidente`
--

LOCK TABLES `incidente` WRITE;
/*!40000 ALTER TABLE `incidente` DISABLE KEYS */;
INSERT INTO `incidente` VALUES (1,8,'accident','2025-01-08 23:48:49'),(2,8,'ambuteiaj','2025-01-08 23:49:10'),(3,7,'masina oprita','2025-01-08 23:49:24'),(4,11,'accident','2025-01-08 23:58:48'),(5,19,'ambuteiaj','2025-01-09 00:10:12'),(6,21,'accident','2025-01-09 00:15:12'),(7,22,'ambuteiaj','2025-01-09 00:15:19'),(8,24,'masina oprita pe carosabil','2025-01-09 00:16:32'),(9,24,'groapa periculoasa','2025-01-09 00:17:38'),(10,35,'ambuteiaj','2025-01-09 02:04:19'),(11,82,'accident','2025-01-09 08:40:23'),(12,85,'ambuteiaj','2025-01-09 08:49:36'),(13,89,'accident','2025-01-09 09:00:18'),(14,153,'blocaj in trafic','2025-01-14 01:29:09'),(15,157,'blocaj in trafic','2025-01-14 01:35:38'),(23,191,'accident','2025-01-14 07:52:26'),(24,193,'blocaj in trafic','2025-01-14 08:05:35'),(25,194,'accident','2025-01-14 08:06:20'),(26,196,'accident','2025-01-14 08:22:55');
/*!40000 ALTER TABLE `incidente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `judet`
--

DROP TABLE IF EXISTS `judet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `judet` (
  `id_judet` int NOT NULL AUTO_INCREMENT,
  `nume` varchar(100) NOT NULL,
  `temperatura` int NOT NULL,
  `conditii_meteo` varchar(255) NOT NULL,
  PRIMARY KEY (`id_judet`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `judet`
--

LOCK TABLES `judet` WRITE;
/*!40000 ALTER TABLE `judet` DISABLE KEYS */;
INSERT INTO `judet` VALUES (1,'Bucuresti',5,'innorat'),(2,'Arges',8,'ploaie'),(3,'Brasov',-1,'ninsoare'),(4,'Constanta',10,'soare'),(5,'Iasi',4,'ceata'),(6,'Cluj',2,'ceata'),(7,'Timisoara',6,'innorat'),(8,'Sibiu',-3,'ninsoare'),(9,'Galati',7,'soare'),(10,'Craiova',9,'ploaie');
/*!40000 ALTER TABLE `judet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preturi_combustibil`
--

DROP TABLE IF EXISTS `preturi_combustibil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preturi_combustibil` (
  `id` int NOT NULL,
  `nume_statie` varchar(255) NOT NULL,
  `tip_combustibil` varchar(50) NOT NULL,
  `pret` decimal(10,2) NOT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preturi_combustibil`
--

LOCK TABLES `preturi_combustibil` WRITE;
/*!40000 ALTER TABLE `preturi_combustibil` DISABLE KEYS */;
INSERT INTO `preturi_combustibil` VALUES (1,'Petrom','Benzina',6.90,'2025-01-10'),(1,'Petrom','Motorina',7.21,'2025-01-10'),(1,'Petrom','GPL',3.27,'2025-01-10'),(2,'Lukoil','Benzina',7.02,'2025-01-10'),(2,'Lukoil','Motorina',7.19,'2025-01-10'),(2,'Lukoil','GPL',3.49,'2025-01-10'),(3,'OMW','Benzina',6.97,'2025-01-10'),(3,'OMW','Motorina',7.22,'2025-01-10'),(3,'OMW','GPL',3.53,'2025-01-10'),(4,'MOL','Benzina',7.04,'2025-01-10'),(4,'MOL','Motorina',7.17,'2025-01-10'),(4,'MOL','GPL',3.55,'2025-01-10'),(5,'Rompetrol','Benzina',7.07,'2025-01-10'),(5,'Rompetrol','Motorina',7.25,'2025-01-10'),(5,'Rompetrol','GPL',3.60,'2025-01-10');
/*!40000 ALTER TABLE `preturi_combustibil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soferi`
--

DROP TABLE IF EXISTS `soferi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soferi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `viteza` int DEFAULT '0',
  `strada` varchar(255) DEFAULT NULL,
  `oras` varchar(255) DEFAULT NULL,
  `vreme` tinyint(1) DEFAULT '0',
  `sport` tinyint(1) DEFAULT '0',
  `carburant` tinyint(1) DEFAULT '0',
  `data_inregistrare` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soferi`
--

LOCK TABLES `soferi` WRITE;
/*!40000 ALTER TABLE `soferi` DISABLE KEYS */;
INSERT INTO `soferi` VALUES (1,0,'90','',0,0,0,'2025-01-09 01:28:00'),(2,0,'86','',0,0,0,'2025-01-09 01:30:02'),(3,0,'134','',0,0,0,'2025-01-09 01:30:04'),(4,0,'E60','',0,0,0,'2025-01-09 01:41:15'),(5,0,'Strada Caracal','Constanta',1,0,1,'2025-01-09 01:44:56'),(6,0,'Strada Sf. Lazar','Arges',0,1,0,'2025-01-09 01:45:05'),(7,115,'Calea Victoriei','Bucuresti',1,0,0,'2025-01-09 01:48:33'),(8,84,'Strada Independentei','Arges',0,0,0,'2025-01-09 01:48:43'),(9,0,'Strada Motilor','CLuj',0,0,0,'2025-01-09 01:54:40'),(10,0,'Strada Brailei','Galati',0,0,0,'2025-01-09 01:54:48'),(11,0,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-09 01:58:31'),(12,125,'Strada Motilor','Cluj',0,0,0,'2025-01-09 01:58:43'),(13,0,'Strada Lipscani','Bucuresti',0,0,0,'2025-01-09 02:00:31'),(14,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 02:00:45'),(15,0,'Strada Lipscani','Bucuresti',0,0,0,'2025-01-09 02:04:02'),(16,0,'Strada Independentei','Arges',0,0,0,'2025-01-09 02:04:16'),(17,87,'Strada Motilor','Cluj',0,1,0,'2025-01-09 02:08:09'),(18,73,'E60','Constanta',1,0,0,'2025-01-09 02:08:17'),(19,69,'Strada Independentei','Arges',0,0,1,'2025-01-09 02:09:52'),(20,129,'Strada Caracal','Constanta',1,0,0,'2025-01-09 02:10:03'),(21,90,'Calea Victoriei','Bucuresti',0,1,0,'2025-01-09 02:14:58'),(22,140,'Strada Brailei','Galati',0,0,1,'2025-01-09 02:15:09'),(23,118,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-09 02:16:10'),(24,106,'Strada Caracal','Constanta',0,0,0,'2025-01-09 02:16:21'),(25,70,'Strada Motilor','Cluj',0,0,0,'2025-01-09 02:18:12'),(26,136,'Strada Sf. Lazar','Arges',0,0,0,'2025-01-09 02:18:19'),(27,103,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 03:06:18'),(28,101,'Strada Lipscani','Bucuresti',0,0,1,'2025-01-09 03:06:32'),(29,136,'Strada Doamnei','Constanta',0,1,0,'2025-01-09 03:39:44'),(30,61,'Calea Victoriei','Bucuresti',0,0,1,'2025-01-09 03:39:53'),(31,99,'Strada Motilor','Cluj',0,0,1,'2025-01-09 03:47:12'),(32,117,'Strada Sf. Lazar','Arges',0,1,0,'2025-01-09 03:47:23'),(33,76,'Strada Lipscani','Bucuresti',0,0,1,'2025-01-09 03:50:10'),(34,121,'E60','Constanta',0,1,0,'2025-01-09 03:50:16'),(35,116,'Calea Victoriei','Bucuresti',1,1,0,'2025-01-09 04:03:55'),(36,106,'Strada Caracal','Constanta',0,0,1,'2025-01-09 04:04:07'),(37,53,'Strada Brailei','Galati',1,0,0,'2025-01-09 04:09:21'),(38,116,'Strada Lipscani','Bucuresti',0,1,0,'2025-01-09 04:09:28'),(39,69,'Strada Motilor','Cluj',1,0,0,'2025-01-09 04:29:08'),(40,131,'Calea Victoriei','Bucuresti',0,0,1,'2025-01-09 04:29:16'),(41,51,'Strada Brailei','Galati',0,1,0,'2025-01-09 04:31:47'),(42,138,'Strada Sf. Lazar','Arges',1,0,0,'2025-01-09 04:31:55'),(43,105,'Strada Lipscani','Bucuresti',1,0,0,'2025-01-09 04:36:39'),(44,90,'Strada Independentei','Arges',0,0,1,'2025-01-09 04:36:51'),(45,59,'Strada Motilor','Cluj',1,0,0,'2025-01-09 04:41:26'),(46,98,'Strada Independentei','Arges',0,1,0,'2025-01-09 04:41:33'),(47,117,'Strada Lipscani','Bucuresti',1,0,1,'2025-01-09 04:43:29'),(48,67,'Strada Motilor','Cluj',0,1,0,'2025-01-09 04:43:36'),(49,61,'Strada Sf. Lazar','Arges',1,0,0,'2025-01-09 04:48:30'),(50,115,'E60','Constanta',0,1,0,'2025-01-09 04:48:38'),(51,145,'Strada LIpscani','Bucuresti',1,0,0,'2025-01-09 04:51:52'),(52,79,'Strada Brailei','Galati',1,0,0,'2025-01-09 04:57:13'),(53,65,'Calea VIctoriei','Bucuresti',1,0,0,'2025-01-09 05:05:24'),(54,133,'Strada Motilor','Cluj',1,0,0,'2025-01-09 05:09:09'),(55,146,'Strada Brailei','Galati',0,0,0,'2025-01-09 05:21:44'),(56,101,'Strada Motilor','Cluj',1,1,0,'2025-01-09 05:21:55'),(57,54,'Strada Doamnei','Constanta',1,1,1,'2025-01-09 05:22:48'),(58,123,'A4','Bucuresti',0,0,0,'2025-01-09 05:28:37'),(59,114,'A4','Bucuresti',0,0,0,'2025-01-09 05:29:24'),(60,136,'Strada Brailei','Galati',0,1,0,'2025-01-09 05:29:36'),(61,119,'A4','Bucuresti',1,0,0,'2025-01-09 05:38:15'),(62,56,'Strada Motilor','Cluj',0,1,0,'2025-01-09 05:38:42'),(63,116,'Strada Sf. Lazar','Arges',0,0,0,'2025-01-09 05:41:33'),(64,130,'Strada Caracal','Constanta',0,1,1,'2025-01-09 05:41:52'),(65,78,'Strada Sf. Lazar','Arges',0,0,0,'2025-01-09 05:49:25'),(66,74,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 05:54:51'),(67,65,'Calea VCalea VictoriCalea Victoriei','BUcuresti',0,1,0,'2025-01-09 05:55:21'),(68,62,'E60','Constanta',0,0,0,'2025-01-09 06:11:58'),(69,74,'Strada Brailei','Galati',0,1,0,'2025-01-09 06:12:07'),(70,77,'Strada Lipscani','Bucuresti',0,0,0,'2025-01-09 06:14:35'),(71,127,'E60','Constanta',1,1,0,'2025-01-09 06:14:59'),(72,52,'Strada Doamnei','Constanta',1,0,0,'2025-01-09 10:23:36'),(73,119,'Strada Brailei','Galati',0,1,0,'2025-01-09 10:23:49'),(74,140,'Strada Motilor','Cluj',0,0,0,'2025-01-09 10:31:26'),(75,145,'Strada Brailei','Galati',0,1,0,'2025-01-09 10:32:12'),(76,81,'Calea Victoriei','Bucuresti',1,0,1,'2025-01-09 10:32:31'),(77,71,'Strada Motilor','CLuj',0,1,0,'2025-01-09 10:36:23'),(78,127,'Strada Salciilor','Iasi',1,0,1,'2025-01-09 10:36:37'),(79,50,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 10:38:13'),(80,77,'Strada Motilor','Cluj',1,1,1,'2025-01-09 10:38:19'),(81,148,'Strada Salciilor','IAsi',1,1,1,'2025-01-09 10:39:57'),(82,120,'Strada Sf. Lazar','Arges',0,1,0,'2025-01-09 10:40:15'),(83,64,'Strada Sforii','Brasov',0,0,0,'2025-01-09 10:48:32'),(84,113,'Calea Victoriei','Bucuresti;',1,0,0,'2025-01-09 10:49:08'),(85,123,'Strada Salciilor','Iasi',0,1,0,'2025-01-09 10:49:18'),(86,100,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 10:57:37'),(87,69,'Strada Brailei','Galati',1,0,0,'2025-01-09 10:57:45'),(88,93,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 10:59:46'),(89,141,'Strada Brailei','Galati',1,1,1,'2025-01-09 11:00:02'),(90,62,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 11:08:16'),(91,72,'Strada Brailei','Galati',0,1,0,'2025-01-09 11:08:25'),(92,94,'Strada Orii','Brasov',0,0,0,'2025-01-09 11:10:36'),(93,129,'Strada Sf. Lazar','Arges',0,1,0,'2025-01-09 11:10:51'),(94,97,'Strada Sf. Lazar','Arges',0,0,0,'2025-01-09 11:13:58'),(95,95,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 11:14:50'),(96,68,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 11:15:49'),(97,81,'Strada Doamnei','Constanta',0,1,0,'2025-01-09 11:20:41'),(98,78,'Strada Salciilor','Iasi',1,0,0,'2025-01-09 11:20:56'),(99,147,'Strada Brailei','Galati',0,0,0,'2025-01-09 11:53:53'),(100,113,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 11:57:05'),(101,58,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 11:57:17'),(102,84,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 12:08:40'),(103,50,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 12:08:51'),(104,0,'Strada Salciilor','Iasi',0,0,0,'2025-01-09 12:16:45'),(105,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-09 12:16:52'),(106,54,'Strada Salciilor','Iasi',0,0,0,'2025-01-12 18:32:32'),(107,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-12 18:43:43'),(108,0,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-12 18:52:54'),(109,0,'Strada Doamnei','Constanta',0,1,0,'2025-01-12 18:53:03'),(110,0,'E60','Constanta',0,0,0,'2025-01-12 18:55:03'),(111,84,'Strada Doamnei','Constanta',0,0,0,'2025-01-12 19:44:31'),(112,0,'Strada Salciilor','Iasi',1,0,0,'2025-01-12 19:44:41'),(113,93,'Strada Salciilor','Iasi',0,0,0,'2025-01-12 19:49:16'),(114,110,'Calea Victoriei','Bucuresti',1,0,0,'2025-01-12 19:49:27'),(115,0,'Strada Salciilor','Iasi',0,0,0,'2025-01-14 01:29:06'),(116,0,'Strada DOamnei','Constanta',1,1,0,'2025-01-14 01:32:16'),(117,0,'Strada Brailei','Galati',0,0,0,'2025-01-14 01:34:21'),(118,0,'E60','Constanta',0,0,1,'2025-01-14 01:34:48'),(119,0,'Strada Sf. Lazar','Arges',1,1,0,'2025-01-14 01:35:44'),(120,0,'Strada Salcilor','Iasi',1,1,0,'2025-01-14 01:40:32'),(121,0,'Strada nucului','Bistrita',1,0,0,'2025-01-14 01:45:04'),(122,0,'Strada Salciilor','Iasi',1,1,1,'2025-01-14 01:48:38'),(123,0,'strada salciilor','iasi',0,0,0,'2025-01-14 01:56:30'),(124,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-14 01:56:54'),(125,0,'E60','Constanta',1,1,1,'2025-01-14 01:57:27'),(126,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 01:58:16'),(127,0,'Strada MOtilor','Cluj',1,0,0,'2025-01-14 02:09:45'),(128,0,'Strada Salciilor','Iasi',1,1,0,'2025-01-14 02:11:26'),(129,0,'Strada Salciilor','Iasi',1,0,1,'2025-01-14 02:18:12'),(130,0,'Strada Motilor','Cluj',0,1,0,'2025-01-14 02:18:19'),(131,0,'Strada MOtilor','Cluj',0,0,0,'2025-01-14 02:27:32'),(132,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-14 02:27:51'),(133,0,'Strada Motilor','CLuj',1,0,0,'2025-01-14 02:29:38'),(134,0,'Calea Victoriei','Bucuresti',0,1,0,'2025-01-14 02:29:47'),(135,0,'Strada Motilor','Cluj',1,0,0,'2025-01-14 02:35:26'),(136,0,'Strada Morii','Bucuresti',0,1,0,'2025-01-14 02:35:39'),(137,0,'Strada Salciilor','Iasi',1,0,0,'2025-01-14 02:37:22'),(138,0,'Strada Motilor','Cluj',1,1,1,'2025-01-14 02:37:37'),(139,0,'Strada Salciilor','Iasi',0,1,0,'2025-01-14 02:44:33'),(140,0,'Strada Motilor','Cluj',1,0,0,'2025-01-14 02:44:47'),(141,0,'Strada Salciilor','Iasi',1,0,0,'2025-01-14 03:00:09'),(142,0,'Strada Motilor','Cluj',0,1,0,'2025-01-14 03:00:21'),(143,0,'Strada Doamnei','Constanta',1,0,0,'2025-01-14 03:02:04'),(144,0,'Strada Motilor','Cluj',0,1,0,'2025-01-14 03:02:20'),(145,0,'Strada Motilor','Cluj',1,0,1,'2025-01-14 03:06:12'),(146,0,'Strada Salciilor','Iasi',1,1,0,'2025-01-14 03:06:27'),(147,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 03:12:11'),(148,0,'Strada Salciilor','Iasi',0,0,0,'2025-01-14 03:12:22'),(149,71,'Strada Doamnei','Constanta',1,0,1,'2025-01-14 03:20:20'),(150,0,'Strada Sf. Lazar','Arges',0,1,0,'2025-01-14 03:20:30'),(151,50,'Strada Salciilor','Iasi',1,0,1,'2025-01-14 03:24:35'),(152,0,'E60','Constanta',0,1,0,'2025-01-14 03:24:54'),(153,71,'Strada Motilor','Cluj',1,0,1,'2025-01-14 03:27:43'),(154,138,'E60','Constanta',0,1,0,'2025-01-14 03:27:48'),(155,72,'Strada Sf. Lazar','Arges',1,0,1,'2025-01-14 03:31:22'),(156,64,'Strada Brailei','Galati',0,1,0,'2025-01-14 03:31:29'),(157,98,'Strada Brailei','Galati',1,0,0,'2025-01-14 03:34:54'),(158,115,'Strada Motilor','Cluj',0,1,0,'2025-01-14 03:35:00'),(159,149,'Strada Motilor','Cluj',1,0,1,'2025-01-14 03:38:25'),(160,74,'Strada Salciilor','Iasi',0,1,0,'2025-01-14 03:38:32'),(161,0,'Strada Salciilor','Iasi',0,0,0,'2025-01-14 03:58:53'),(162,0,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-14 03:59:11'),(163,0,'E60','Constanta',0,0,0,'2025-01-14 04:01:05'),(164,0,'Calea Moldovei','Iasi',0,0,0,'2025-01-14 04:01:13'),(165,0,'Calea Moldovei','Iasi',0,0,0,'2025-01-14 04:14:02'),(166,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 04:14:09'),(167,0,'Calea Moldovei','Iasi',0,0,0,'2025-01-14 04:19:22'),(168,0,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-14 04:19:30'),(169,0,'Calea Moldovei','Iasi',0,0,0,'2025-01-14 04:27:31'),(170,0,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-14 04:27:38'),(171,0,'Calea Victoriei','Bucuresti',0,0,0,'2025-01-14 04:36:36'),(172,0,'Strada Doamnei','COnstanta',0,0,0,'2025-01-14 04:36:43'),(173,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-14 04:37:00'),(174,0,'Strada Sf. Lazar','Arges',0,0,0,'2025-01-14 04:41:56'),(175,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 04:42:02'),(176,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 09:32:09'),(177,0,'Strada Brailei','Galati',0,0,0,'2025-01-14 09:32:22'),(178,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 09:37:14'),(179,0,'Strada Brailei','Galati',0,0,0,'2025-01-14 09:37:24'),(180,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-14 09:40:07'),(181,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 09:40:14'),(182,0,'Strada Brailei','Galati',0,0,0,'2025-01-14 09:42:22'),(183,0,'Strada Doamnei','Constanta',0,0,0,'2025-01-14 09:42:37'),(184,0,'E60','Constanta',0,0,0,'2025-01-14 09:44:23'),(185,0,'Strada Motilor','Cluj',0,0,0,'2025-01-14 09:44:30'),(186,0,'Strada Motilor','Cluj',0,1,1,'2025-01-14 09:46:29'),(187,0,'Strada Brailei','Galati',1,0,0,'2025-01-14 09:46:35'),(188,0,'Strada Brailei','Galati',0,0,0,'2025-01-14 09:48:51'),(189,0,'E60','Constanta',0,0,0,'2025-01-14 09:49:39'),(190,0,'Strada Sf.Lazar','Arges',0,0,0,'2025-01-14 09:49:53'),(191,51,'Strada Motilor','Cluj',1,0,1,'2025-01-14 09:51:44'),(192,88,'Calea Victoriei','Bucuresti',0,1,0,'2025-01-14 09:51:53'),(193,122,'Strada Motilor','Cluj',1,0,0,'2025-01-14 10:05:13'),(194,61,'Strada Brailei','Galati',0,1,1,'2025-01-14 10:05:24'),(195,90,'Strada Brailei','Galati',1,0,1,'2025-01-14 10:22:18'),(196,83,'Strada Doamnei','COnstanta',0,1,0,'2025-01-14 10:22:29');
/*!40000 ALTER TABLE `soferi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `strada`
--

DROP TABLE IF EXISTS `strada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `strada` (
  `id_strada` int NOT NULL AUTO_INCREMENT,
  `id_judet` int DEFAULT NULL,
  `nume` varchar(255) DEFAULT NULL,
  `limita_viteza` int DEFAULT NULL,
  PRIMARY KEY (`id_strada`),
  KEY `id_judet` (`id_judet`),
  CONSTRAINT `strada_ibfk_1` FOREIGN KEY (`id_judet`) REFERENCES `judet` (`id_judet`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `strada`
--

LOCK TABLES `strada` WRITE;
/*!40000 ALTER TABLE `strada` DISABLE KEYS */;
INSERT INTO `strada` VALUES (1,1,'Calea Victoriei',50),(2,1,'Bulevardul Unirii',60),(3,1,'Strada Lipscani',40),(4,1,'Strada Magheru',50),(5,1,'Bulevardul Eroilor',40),(6,2,'Bulevardul Copou',50),(7,2,'Strada Sf. Lazar',40),(8,2,'Calea Chisinaului',60),(9,2,'Strada Independentei',40),(10,2,'Bulevardul Titu Maiorescu',50),(11,3,'Strada Aradului',50),(12,3,'Calea Victoriei',60),(13,3,'Bulevardul Revolutiei',40),(14,3,'Strada Stefan cel Mare',50),(15,3,'Calea Timisoarei',60),(16,4,'Strada Doamnei',40),(17,4,'Calea Victoriei',50),(18,4,'Bulevardul Titu Maiorescu',60),(19,4,'Strada Caracal',50),(20,4,'Bulevardul București',40),(21,5,'Calea Moldovei',50),(22,5,'Strada Unirii',60),(23,5,'Strada Mihail Sadoveanu',40),(24,5,'Bulevardul George Enescu',50),(25,5,'Strada Stefan cel Mare',40),(26,1,'DJ101',90),(27,1,'DJ102',90),(28,1,'A4',130),(29,3,'A3',130),(30,5,'E58',100),(31,4,'E60',100),(32,2,'DJ659',90),(33,2,'DJ679',90),(34,6,'Strada Memorandumului',50),(35,6,'Bulevardul Eroilor',50),(36,6,'Calea Dorobanților',50),(37,6,'Strada Motilor',50),(38,6,'Bulevardul 21 Decembrie',50),(39,7,'Bulevardul Take Ionescu',50),(40,7,'Strada Gheorghe Lazar',40),(41,7,'Calea Sever Bocu',50),(42,7,'Bulevardul Regele Carol I',50),(43,7,'Calea Torontalului',50),(44,8,'Strada Nicolae Balcescu',50),(45,8,'Calea Dumbravii',50),(46,8,'Bulevardul Corneliu Coposu',50),(47,8,'Strada Garii',50),(48,8,'Strada Stefan cel Mare',50),(49,9,'Strada Domneasca',50),(50,9,'Bulevardul George Cosbuc',50),(51,9,'Strada Brailei',50),(52,9,'Calea Galati',50),(53,9,'Strada Basarabiei',50),(54,10,'Bulevardul Nicolae Titulescu',50),(55,10,'Calea Bucuresti',50),(56,10,'Strada Alexandru Ioan Cuza',50),(57,10,'Bulevardul Carol I',50),(58,10,'Strada Amaradia',50),(59,6,'DJ72',90),(60,7,'A1',130),(61,8,'DN1',90),(62,9,'DJ53',90),(63,10,'DN2',90);
/*!40000 ALTER TABLE `strada` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-14 10:49:52
