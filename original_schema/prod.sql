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
-- Table structure for table `prod`
--

DROP TABLE IF EXISTS `prod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod` (
  `carNo` varchar(12) NOT NULL,
  `disName` varchar(45) DEFAULT NULL,
  `catProdId` int(11) DEFAULT NULL,
  `storeId` int(11) NOT NULL,
  `plusInsurance` varchar(4) DEFAULT NULL,
  `prodId` varchar(40) NOT NULL,
  `birthday` varchar(10) DEFAULT NULL,
  `buyDate` varchar(14) DEFAULT NULL,
  `buyDistance` int(11) DEFAULT NULL,
  `nowDistance` int(11) DEFAULT NULL,
  `status` varchar(5) DEFAULT NULL,
  `updateDate` varchar(14) DEFAULT NULL,
  `updator` varchar(20) DEFAULT NULL,
  `prodCatId` varchar(255) DEFAULT NULL,
  `pic1` varchar(200) DEFAULT NULL,
  `pic2` varchar(200) DEFAULT NULL,
  `pic3` varchar(200) DEFAULT NULL,
  `pic4` varchar(200) DEFAULT NULL,
  `officeImg` varchar(200) DEFAULT NULL COMMENT '官方照片',
  `describeImg` varchar(200) DEFAULT NULL COMMENT '車況照片',
  `prodPriceRowId` int(11) DEFAULT NULL,
  `monthStartDistance` int(11) DEFAULT NULL,
  `clientOrderId` varchar(45) DEFAULT NULL,
  `contractMonthOfDate` int(11) DEFAULT '0',
  `engineId` varchar(90) DEFAULT NULL,
  `color` varchar(5) DEFAULT NULL,
  `insuranceDueDate` varchar(8) DEFAULT NULL COMMENT '保險到期日YYYYMMDD',
  `lat` varchar(20) DEFAULT NULL,
  `lng` varchar(20) DEFAULT NULL,
  `locatUpdateDate` varchar(45) DEFAULT NULL,
  `enabledDistance` varchar(1) DEFAULT 'T' COMMENT '啟用里程管理',
  `ccType` varchar(1) DEFAULT 'M',
  `carNoDisName` varchar(12) DEFAULT NULL,
  `contractMileage` int(8) DEFAULT '0' COMMENT '每月內含里程',
  `deductibleMileage` int(8) DEFAULT '0' COMMENT '可折抵里程',
  `keyBoxDoorId` varchar(2) DEFAULT NULL,
  `ecoAuto` varchar(12) DEFAULT NULL,
  `enabledEco` varchar(1) DEFAULT 'F',
  `maintainDistance` int(11) DEFAULT '0',
  `maintainDays` varchar(4) DEFAULT '0',
  `lastMaintainDistance` int(11) DEFAULT '0',
  `lastMaintainDate` varchar(20) DEFAULT NULL,
  `carOwner` varchar(20) DEFAULT NULL,
  `statusChangeMsg` text,
  `statusChangeDate` varchar(14) DEFAULT NULL,
  `iotType` varchar(45) DEFAULT NULL,
  `isPutKeyBox` varchar(2) DEFAULT 'F',
  PRIMARY KEY (`prodId`),
  UNIQUE KEY `carNo_UNIQUE` (`carNo`),
  KEY `catId` (`prodCatId`),
  KEY `storeId` (`storeId`),
  KEY `nowDistance` (`nowDistance`),
  KEY `monthStartDistance` (`monthStartDistance`),
  KEY `clientOrderId` (`clientOrderId`),
  KEY `enabledDistance` (`enabledDistance`)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 16:22:23
