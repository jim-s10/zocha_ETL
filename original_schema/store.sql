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
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `storeId` int(11) NOT NULL AUTO_INCREMENT,
  `disName` varchar(45) NOT NULL,
  `addr` varchar(255) DEFAULT NULL,
  `areaId` int(11) NOT NULL,
  `gpsLat` varchar(20) DEFAULT NULL,
  `gpsLng` varchar(20) DEFAULT NULL,
  `createDate` varchar(8) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT '1',
  `pic` varchar(40) DEFAULT NULL,
  `updateDate` varchar(45) DEFAULT NULL,
  `updator` varchar(45) DEFAULT NULL,
  `descp` varchar(400) DEFAULT NULL,
  `payCash` varchar(1) DEFAULT 'T',
  `payCredit` varchar(1) DEFAULT 'T',
  `payLINE` varchar(1) DEFAULT 'F',
  `payIcp` varchar(1) DEFAULT 'F',
  `withoutMofunInvoice` varchar(1) DEFAULT 'F' COMMENT '不委託mofun開立電子發票',
  `payEndPriceAtRent` varchar(1) DEFAULT 'F' COMMENT '取車付全額',
  `alertEmail` varchar(200) DEFAULT NULL,
  `alertChannel` varchar(500) DEFAULT NULL,
  `priceType` varchar(20) DEFAULT NULL COMMENT '收費方式',
  `saleInsuranceAbled` varchar(1) DEFAULT 'T' COMMENT '是否販售保險 T:可 F:不可',
  `frontInsuranceDesc` varchar(500) DEFAULT NULL COMMENT '保險描述',
  `checkOnlyClientLicense` varchar(2) DEFAULT 'F' COMMENT 'L:取車只檢查是否有駕照\nID:取車只檢查是否有身分證\nF:都要檢查\n',
  `checkAdminUserCode` varchar(1) DEFAULT 'T',
  `frontDisName` varchar(45) DEFAULT NULL,
  `outsideServiceReturn` varchar(1) DEFAULT 'F',
  `frontRefundRuleDesc` varchar(500) DEFAULT NULL,
  `pdfDisName` varchar(45) DEFAULT NULL,
  `isFrontRentable` varchar(1) DEFAULT 'T',
  `keyBoxId` varchar(10) DEFAULT NULL,
  `isNoStaffStore` varchar(1) DEFAULT 'F',
  `storeGroupId` int(11) DEFAULT NULL,
  `oneDayRentAble` varchar(1) DEFAULT 'F',
  `isForeignRentOnSite` varchar(1) DEFAULT 'T',
  `isShowStoreInfoBtn` varchar(45) DEFAULT 'F',
  `isPaymentRequired` varchar(45) DEFAULT 'F',
  `entranceType` varchar(45) DEFAULT NULL,
  `exitType` varchar(45) DEFAULT NULL,
  `memoNote` varchar(45) DEFAULT NULL,
  `skipProdImgType` varchar(45) DEFAULT NULL,
  `payEndPriceAtDeposit` varchar(2) DEFAULT 'F',
  PRIMARY KEY (`storeId`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 16:22:21
