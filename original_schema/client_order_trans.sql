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
-- Table structure for table `client_order_trans`
--

DROP TABLE IF EXISTS `client_order_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_order_trans` (
  `rowId` int(11) NOT NULL AUTO_INCREMENT,
  `clientOrderId` varchar(20) NOT NULL,
  `amt` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `type` varchar(10) NOT NULL COMMENT 'RETURN:退款 PRE_PAY:訂金 ORDER_PAY:訂單尾款 BOUNDLE:綁定',
  `disName` varchar(45) DEFAULT NULL,
  `response` text,
  `updateDate` varchar(14) DEFAULT NULL,
  `updator` varchar(20) DEFAULT NULL,
  `returnUrl` text COMMENT '信用卡交易完成後要返回的網址',
  `moneyType` varchar(10) DEFAULT NULL COMMENT '付款類型 : CASH:現金  CREDIT:信用卡 LINEPAY',
  `payId` varchar(30) DEFAULT NULL,
  `merchantOrderNo` varchar(30) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL COMMENT '回應狀態',
  `moneyAccount` int(11) DEFAULT NULL COMMENT '資金帳戶',
  `moneyTypeExtend` varchar(10) DEFAULT NULL COMMENT '信用卡末四碼\n匯款末五碼',
  `icpRequestData` varchar(500) DEFAULT NULL COMMENT 'icashPay等待付款時候訂單最後的狀態',
  PRIMARY KEY (`rowId`),
  KEY `clientOrderId` (`clientOrderId`),
  KEY `moneyType` (`moneyType`),
  KEY `status` (`status`),
  KEY `updateDate` (`updateDate`),
  KEY `moneyAccount` (`moneyAccount`)
) ENGINE=InnoDB AUTO_INCREMENT=1294 DEFAULT CHARSET=utf8 COMMENT='交易金額';
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
