-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: test.mofuntravel.com.tw    Database: zocha_test
-- ------------------------------------------------------
-- Server version	5.7.34

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
-- Table structure for table `client_order_detail`
--

DROP TABLE IF EXISTS `client_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_order_detail` (
  `rowId` int(11) NOT NULL AUTO_INCREMENT,
  `parentDocId` varchar(45) DEFAULT NULL,
  `prodId` varchar(45) DEFAULT NULL,
  `price` int(11) DEFAULT '0',
  `qty` int(11) DEFAULT '1',
  `catId` int(11) DEFAULT NULL,
  `plusInsurance` varchar(1) DEFAULT NULL,
  `carNo` varchar(10) DEFAULT NULL,
  `prodPriceRowId` int(11) DEFAULT NULL,
  `prodStockRowId` int(11) DEFAULT NULL,
  `insurancePrice` int(11) DEFAULT NULL,
  `accessoriesHelmet` int(11) DEFAULT '1',
  `accessoriesRaincoat` int(11) DEFAULT '1',
  `accessoriesHelmetFull` int(11) DEFAULT '1' COMMENT '全罩安全帽',
  `fromVoltage` varchar(45) DEFAULT NULL,
  `toVoltage` varchar(45) DEFAULT NULL,
  `fromSoc` varchar(45) DEFAULT NULL,
  `toSoc` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`rowId`),
  KEY `parentDocId` (`parentDocId`),
  KEY `carNo` (`carNo`),
  KEY `priceId` (`prodPriceRowId`),
  KEY `stockeId` (`prodStockRowId`),
  KEY `catId` (`catId`),
  KEY `prodId` (`prodId`)
) ENGINE=InnoDB AUTO_INCREMENT=1754 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 16:22:19
