-- MySQL dump 10.13  Distrib 5.5.7-rc, for pc-linux-gnu (i686)
--
-- Host: localhost    Database: emgauge
-- ------------------------------------------------------
-- Server version	5.5.7-rc

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bounces`
--

DROP TABLE IF EXISTS `bounces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bounces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) DEFAULT NULL,
  `recipient` varchar(128) DEFAULT NULL,
  `mailer` int(11) DEFAULT NULL,
  `schedule` int(11) DEFAULT NULL,
  `status` varchar(32) DEFAULT NULL,
  `reason` text,
  `bdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `bhost` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bounces_email_idx` (`email`),
  KEY `bounces_status_idx` (`status`),
  KEY `bounces_recipient_idx` (`recipient`)
) ENGINE=MyISAM AUTO_INCREMENT=1228259 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `campaign`
--

DROP TABLE IF EXISTS `campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `campaign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `createdon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `createdby` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=213 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailer` int(11) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `body` text,
  `score` int(11) DEFAULT NULL,
  `commentedon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `deliverylog`
--

DROP TABLE IF EXISTS `deliverylog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deliverylog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule` int(11) DEFAULT NULL,
  `recipient` int(11) DEFAULT NULL,
  `relayhost` varchar(128) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `message` varchar(256) DEFAULT NULL,
  `deliveredat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `postdeliverystatus` varchar(128) DEFAULT NULL,
  `postdeliveryreason` text,
  PRIMARY KEY (`id`),
  KEY `deliverylog_recipient_idx` (`recipient`),
  KEY `deliverylog_schedule_idx` (`schedule`)
) ENGINE=MyISAM AUTO_INCREMENT=12338142 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailer` int(11) DEFAULT NULL,
  `src` varchar(256) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `fullsrc` varchar(256) DEFAULT NULL,
  `url` varchar(256) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `alt` varchar(64) DEFAULT NULL,
  `thmb` varchar(256) DEFAULT NULL,
  `thmbw` int(11) DEFAULT NULL,
  `thmbh` int(11) DEFAULT NULL,
  `imap` varchar(32) DEFAULT NULL,
  `found` int(11) DEFAULT NULL,
  `include` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1742 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailer` int(11) DEFAULT NULL,
  `myhref` varchar(256) DEFAULT NULL,
  `href` varchar(256) DEFAULT NULL,
  `target` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `track` int(11) DEFAULT NULL,
  `imap` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `links_mailer_idx` (`mailer`)
) ENGINE=MyISAM AUTO_INCREMENT=5636 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `list`
--

DROP TABLE IF EXISTS `list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `records` int(11) DEFAULT NULL,
  `source` varchar(128) DEFAULT NULL,
  `filename` text,
  `active` int(11) DEFAULT NULL,
  `createdon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `createdby` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=485 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listlog`
--

DROP TABLE IF EXISTS `listlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `list` int(11) DEFAULT NULL,
  `action` varchar(256) DEFAULT NULL,
  `actionedon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `actionedby` varchar(16) DEFAULT NULL,
  `actionsize` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listmembers`
--

DROP TABLE IF EXISTS `listmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listmembers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `list` int(11) DEFAULT NULL,
  `recipient` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `listmembers_list_idx` (`list`),
  KEY `listmembers_recipient_idx` (`recipient`)
) ENGINE=MyISAM AUTO_INCREMENT=5634972 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailer`
--

DROP TABLE IF EXISTS `mailer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `campaign` int(11) DEFAULT NULL,
  `landingpage` varchar(256) DEFAULT NULL,
  `htmlfilepath` varchar(256) DEFAULT NULL,
  `dfilepath` varchar(256) DEFAULT NULL,
  `subject` varchar(128) DEFAULT NULL,
  `sendername` varchar(128) DEFAULT NULL,
  `senderemail` varchar(128) DEFAULT NULL,
  `replytoemail` varchar(128) DEFAULT NULL,
  `onlineurl` varchar(256) DEFAULT NULL,
  `autoaddforward` int(11) DEFAULT NULL,
  `autoaddsubscribe` int(11) DEFAULT NULL,
  `autoaddunsubscribe` int(11) DEFAULT NULL,
  `autoaddonlinelink` int(11) DEFAULT NULL,
  `attachment` varchar(256) DEFAULT NULL,
  `attachmentmimetype` varchar(64) DEFAULT NULL,
  `createdby` varchar(16) DEFAULT NULL,
  `createdon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=232 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailerlists`
--

DROP TABLE IF EXISTS `mailerlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailerlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule` int(11) DEFAULT NULL,
  `list` int(11) DEFAULT NULL,
  `assignedon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `assignedby` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mailerlists_schedule_idx` (`schedule`),
  KEY `mailerlists_list_idx` (`list`)
) ENGINE=MyISAM AUTO_INCREMENT=1456 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailerlog`
--

DROP TABLE IF EXISTS `mailerlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailerlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailer` int(11) DEFAULT NULL,
  `schedule` int(11) DEFAULT NULL,
  `scheduled` int(11) DEFAULT NULL,
  `offset` int(11) DEFAULT NULL,
  `delivered` int(11) DEFAULT NULL,
  `bounced` int(11) DEFAULT NULL,
  `opened` int(11) DEFAULT NULL,
  `clicked` int(11) DEFAULT NULL,
  `updatedon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=448 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `queuelog`
--

DROP TABLE IF EXISTS `queuelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queuelog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(16) DEFAULT NULL,
  `scheduleid` int(11) DEFAULT NULL,
  `beanstalkid` int(11) DEFAULT NULL,
  `script` varchar(32) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `status` varchar(32) DEFAULT NULL,
  `message` varchar(256) DEFAULT NULL,
  `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=51374 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recipient`
--

DROP TABLE IF EXISTS `recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recipient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ccode` varchar(32) DEFAULT NULL,
  `firstname` varchar(32) DEFAULT NULL,
  `lastname` varchar(32) DEFAULT NULL,
  `fullname` varchar(48) DEFAULT NULL,
  `prefix` varchar(8) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(16) DEFAULT NULL,
  `organization` varchar(128) DEFAULT NULL,
  `phonelandline` varchar(12) DEFAULT NULL,
  `altphonelandline` varchar(12) DEFAULT NULL,
  `phonemobile` varchar(12) DEFAULT NULL,
  `altphonemobile` varchar(12) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `custom4` text,
  `custom3` text,
  `custom2` text,
  `custom1` text,
  `unsubscribed` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recipient_email_idx` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=4526899 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `report`
--

DROP TABLE IF EXISTS `report`;
/*!50001 DROP VIEW IF EXISTS `report`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `report` (
  `mailer` int(11),
  `name` varchar(64),
  `schedules` bigint(21),
  `scheduled` decimal(32,0),
  `delivered` decimal(32,0),
  `bounced` decimal(32,0),
  `opened` decimal(32,0),
  `clicked` decimal(32,0)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `mailer` int(11) DEFAULT NULL,
  `jobid` int(11) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  `scheduled` int(11) DEFAULT NULL,
  `sess_scheduled` int(11) DEFAULT NULL,
  `scheduledfor` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `startedon` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `completedon` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) DEFAULT NULL,
  `scheduledby` varchar(16) DEFAULT NULL,
  `scheduledon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `repeated` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_mailer_idx` (`mailer`)
) ENGINE=MyISAM AUTO_INCREMENT=480 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tplvars`
--

DROP TABLE IF EXISTS `tplvars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tplvars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailer` int(11) DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tracker`
--

DROP TABLE IF EXISTS `tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipient` int(11) DEFAULT NULL,
  `mailer` int(11) DEFAULT NULL,
  `schedule` int(11) DEFAULT NULL,
  `objtype` varchar(8) DEFAULT NULL,
  `obj` int(11) DEFAULT NULL,
  `uagent` varchar(128) DEFAULT NULL,
  `reqtstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1470080 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullname` varchar(64) DEFAULT NULL,
  `username` varchar(16) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `createdon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `createdby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xlparsequeue`
--

DROP TABLE IF EXISTS `xlparsequeue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xlparsequeue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(256) DEFAULT NULL,
  `listid` int(11) DEFAULT NULL,
  `bjobid` int(11) DEFAULT NULL,
  `records` int(11) DEFAULT NULL,
  `recordsin` int(11) DEFAULT NULL,
  `schtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `importfields` text,
  `createdby` varchar(16) DEFAULT NULL,
  `starttime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `endtime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=368 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `report`
--

/*!50001 DROP TABLE IF EXISTS `report`*/;
/*!50001 DROP VIEW IF EXISTS `report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`emgauge`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `report` AS select `mailerlog`.`mailer` AS `mailer`,`mailer`.`name` AS `name`,count(`mailerlog`.`schedule`) AS `schedules`,sum(`mailerlog`.`scheduled`) AS `scheduled`,sum(`mailerlog`.`delivered`) AS `delivered`,sum(`mailerlog`.`bounced`) AS `bounced`,sum(`mailerlog`.`opened`) AS `opened`,sum(`mailerlog`.`clicked`) AS `clicked` from (`mailerlog` join `mailer`) where (`mailerlog`.`mailer` = `mailer`.`id`) group by `mailerlog`.`mailer`,`mailer`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-12-06 10:00:26
