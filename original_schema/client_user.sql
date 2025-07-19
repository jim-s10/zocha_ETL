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
-- Table structure for table `client_user`
--

DROP TABLE IF EXISTS `client_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_user` (
  `clientUserId` varchar(20) NOT NULL,
  `disName` varchar(60) CHARACTER SET utf8 NOT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `sex` varchar(300) DEFAULT NULL,
  `birthday` varchar(45) DEFAULT NULL,
  `addr` varchar(300) DEFAULT NULL,
  `pwd` varchar(255) DEFAULT NULL,
  `emrContact` varchar(255) DEFAULT NULL,
  `emrContactPhone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `updateDate` varchar(20) DEFAULT NULL,
  `updator` varchar(14) DEFAULT NULL,
  `pic1` varchar(200) DEFAULT NULL,
  `pic2` varchar(200) DEFAULT NULL,
  `pic3` varchar(200) DEFAULT NULL,
  `pic4` varchar(200) DEFAULT NULL,
  `adminNote` varchar(200) DEFAULT NULL,
  `boundleCreditCard` varchar(12) DEFAULT 'F',
  `createDate` varchar(14) DEFAULT NULL,
  `FrOrderId` varchar(45) DEFAULT NULL,
  `country` varchar(4) DEFAULT NULL COMMENT '國籍',
  `payTokenValue` varchar(120) DEFAULT NULL,
  `card4No` varchar(4) DEFAULT NULL COMMENT '綁定信用卡末4碼',
  `lineId` varchar(200) DEFAULT NULL,
  `facebookId` varchar(50) DEFAULT NULL,
  `recognizeResult` varchar(10) DEFAULT NULL COMMENT 'T:證件與cientUserId相同 F:無法辨識 N:證件與客戶資料不同',
  `recognizeDate` varchar(14) DEFAULT NULL COMMENT '最後一次辨識時間',
  `registerDate` varchar(14) DEFAULT NULL COMMENT '註冊時間',
  `createStoreId` int(11) DEFAULT NULL COMMENT '第一單租車店家',
  `motoLicense` varchar(1) DEFAULT 'M',
  `carrierNum` varchar(8) DEFAULT NULL,
  `ban` varchar(1) DEFAULT 'F',
  `banNote` varchar(255) DEFAULT NULL,
  `tokenTerm` varchar(45) DEFAULT NULL,
  `kycRatioRs` varchar(45) DEFAULT 'ENABLE',
  PRIMARY KEY (`clientUserId`),
  KEY `createDate` (`createDate`),
  KEY `createStoreId` (`createStoreId`),
  KEY `registreDate` (`registerDate`)
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

-- Dump completed on 2025-06-23 16:22:08
