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
-- Table structure for table `client_order`
--

DROP TABLE IF EXISTS `client_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_order` (
  `clientOrderId` varchar(45) NOT NULL,
  `clientUserId` varchar(12) NOT NULL,
  `createDate` varchar(14) NOT NULL,
  `flow` varchar(4) NOT NULL,
  `price` int(11) NOT NULL,
  `finishDate` varchar(14) DEFAULT NULL,
  `updateDate` varchar(14) DEFAULT NULL,
  `updator` varchar(45) DEFAULT NULL,
  `storeId` int(11) NOT NULL,
  `disName` varchar(45) DEFAULT NULL,
  `sDate` varchar(14) NOT NULL,
  `eDate` varchar(14) NOT NULL,
  `realStartDate` varchar(14) DEFAULT NULL,
  `realEndDate` varchar(14) DEFAULT NULL,
  `startDistance` int(11) DEFAULT NULL,
  `endDistance` int(11) DEFAULT NULL,
  `payId` varchar(45) DEFAULT NULL,
  `prePrice` int(11) DEFAULT NULL,
  `payDate` varchar(16) DEFAULT NULL,
  `plusPrice` int(11) DEFAULT NULL,
  `checkTitle` varchar(45) DEFAULT NULL,
  `checkUniNo` varchar(45) DEFAULT NULL,
  `cancelNote` varchar(200) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `clientType` varchar(3) DEFAULT '2',
  `reserveNote` varchar(200) DEFAULT NULL,
  `clientNote` varchar(200) DEFAULT NULL,
  `deposit` int(11) DEFAULT '200',
  `returnStoreId` int(11) DEFAULT NULL,
  `rentDateType` varchar(4) DEFAULT NULL,
  `vatNo` varchar(12) DEFAULT NULL,
  `vatCompanyTitle` varchar(45) DEFAULT NULL,
  `promotionCode` varchar(20) DEFAULT NULL COMMENT '優惠碼',
  `discount` int(11) DEFAULT '0',
  `depositPayMethod` varchar(10) DEFAULT NULL COMMENT '訂金付款方式[CASH,CREDIT,LINEPAY]',
  `endPayMethod` varchar(10) DEFAULT NULL COMMENT '尾款付款方式[CASH,CREDIT,LINEPAY]',
  `beforePay` varchar(1) DEFAULT 'F' COMMENT '是否預收車資',
  `beforePayMethod` varchar(10) DEFAULT NULL COMMENT '預收車資付款方式',
  `beforePrice` int(11) DEFAULT '0' COMMENT '預收款金額已折扣',
  `beforeOrginPrice` int(11) DEFAULT '0' COMMENT '未折扣的預付價格',
  `beforeDiscount` int(11) DEFAULT '0' COMMENT '預付給的折扣',
  `cancelReasonType` varchar(1) DEFAULT NULL,
  `qty` int(3) DEFAULT '1',
  `carrierNum` varchar(8) DEFAULT NULL,
  `getType` varchar(2) DEFAULT '0',
  `rentKeyBoxId` varchar(2) DEFAULT NULL,
  `returnKeyBoxId` varchar(2) DEFAULT NULL,
  `ecoNo` varchar(12) DEFAULT NULL COMMENT '車牌號碼',
  `asiaMilesId` varchar(12) DEFAULT NULL,
  `plusCancelInsurance` int(11) DEFAULT '0',
  `addonPrice` int(11) DEFAULT '0',
  PRIMARY KEY (`clientOrderId`),
  KEY `payDate` (`payDate`),
  KEY `storeId` (`storeId`),
  KEY `clientUserId` (`clientUserId`)
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
