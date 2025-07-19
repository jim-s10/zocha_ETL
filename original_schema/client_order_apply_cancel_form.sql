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
-- Table structure for table `client_order_apply_cancel_form`
--

DROP TABLE IF EXISTS `client_order_apply_cancel_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_order_apply_cancel_form` (
  `clientOrderId` varchar(17) NOT NULL,
  `applyDate` varchar(14) NOT NULL,
  `applyStatus` varchar(1) NOT NULL COMMENT 'T:已處理 F:未處理',
  `moneyType` varchar(10) NOT NULL COMMENT '付訂方式 CREDIT(信用卡)  CASH(現金)',
  `note` varchar(300) DEFAULT NULL,
  `updateDate` varchar(14) DEFAULT NULL,
  `updator` varchar(20) DEFAULT NULL,
  `clientUserBankName` varchar(20) DEFAULT NULL,
  `clientUserBankAccount` varchar(25) DEFAULT NULL,
  `plusFee` varchar(1) DEFAULT 'T',
  `clientUserBankBranch` varchar(30) DEFAULT NULL,
  `clientUserName` varchar(50) DEFAULT NULL,
  `refund` int(11) DEFAULT NULL,
  `cancelReasonType` varchar(1) DEFAULT NULL,
  `userDisName` varchar(50) DEFAULT NULL,
  `userPhone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`clientOrderId`),
  KEY `status` (`applyStatus`),
  KEY `applyDate` (`applyDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客戶取消預約申請表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 16:22:16
