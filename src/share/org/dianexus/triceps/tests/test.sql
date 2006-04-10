-- phpMyAdmin SQL Dump
-- version 2.7.0-pl1
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generation Time: Apr 10, 2006 at 01:55 PM
-- Server version: 5.0.18
-- PHP Version: 5.1.1
-- 
-- Database: `inst_database_test`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a`
-- 

CREATE TABLE `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` (
  `session_id` int(10) unsigned NOT NULL auto_increment,
  `instrument_session_id` int(11) NOT NULL,
  `InstrumentName` varchar(200) collate latin1_general_ci NOT NULL,
  `InstanceName` varchar(200) collate latin1_general_ci NOT NULL,
  `StartTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `Intro` text collate latin1_general_ci NOT NULL,
  `speech` text collate latin1_general_ci NOT NULL,
  `facial` text collate latin1_general_ci NOT NULL,
  `tremor` text collate latin1_general_ci NOT NULL,
  `rigid_i` text collate latin1_general_ci NOT NULL,
  `neck` text collate latin1_general_ci NOT NULL,
  `Rarm` text collate latin1_general_ci NOT NULL,
  `Larm` text collate latin1_general_ci NOT NULL,
  `Rleg` text collate latin1_general_ci NOT NULL,
  `Lleg` text collate latin1_general_ci NOT NULL,
  `posture` text collate latin1_general_ci NOT NULL,
  `kinesia` text collate latin1_general_ci NOT NULL,
  `gait` text collate latin1_general_ci NOT NULL,
  `score` text collate latin1_general_ci NOT NULL,
  `sx_list` text collate latin1_general_ci NOT NULL,
  `report` text collate latin1_general_ci NOT NULL,
  `endTime` timestamp NULL default NULL,
  `firstGroup` int(10) unsigned default NULL,
  `lastGroup` int(11) default NULL,
  `lastAction` int(10) unsigned default NULL,
  `lastAccess` int(10) unsigned default NULL,
  `statusMsg` text collate latin1_general_ci,
  PRIMARY KEY  (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=28 ;

-- 
-- Dumping data for table `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a`
-- 

INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (1, 0, 'abc', 'abc', '2006-03-23 16:21:51', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '2006-03-23 16:21:51', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (2, 0, 'abc', 'abc', '2006-03-23 16:22:39', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '2006-03-23 16:22:39', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (3, 0, 'abc', 'abc', '0000-00-00 00:00:00', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '0000-00-00 00:00:00', 0, 0, 0, 0, 'N/A');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (4, 0, 'abc', 'abc', '2006-03-23 16:27:16', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '2006-03-23 16:27:16', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (5, 0, 'abc', 'abc', '2006-03-24 08:06:01', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '2006-03-24 08:06:01', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (6, 0, 'abc', 'abc', '2006-03-24 08:06:03', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '2006-03-24 08:06:03', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (7, 0, 'abc', 'abc', '2006-03-24 08:15:27', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '2006-03-24 08:15:27', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (8, 0, 'abc', 'abc', '1970-01-01 22:46:40', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (9, 0, 'abc', 'abc', '1970-01-01 22:46:40', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (10, 0, 'abc', 'abc', '1970-01-01 22:46:40', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (11, 0, 'abc', 'abc', '1970-01-01 22:46:40', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (12, 0, 'abc', 'abc', '1970-01-01 22:46:40', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (13, 0, 'abc', 'abc', '1970-01-01 22:46:40', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (14, 0, 'abc', 'abc', '2006-03-27 17:22:14', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (15, 0, 'abc', 'abc', '2006-03-27 17:22:59', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (16, 0, 'abc', 'abc', '2006-03-27 17:23:09', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (17, 0, 'abc', 'abc', '2006-03-28 14:47:48', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (18, 0, 'abc', 'abc', '2006-03-28 14:49:14', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (19, 0, 'abc', 'abc', '2006-03-28 14:49:29', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (20, 0, 'abc', 'abc', '2006-03-28 14:52:45', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (21, 0, 'abc', 'abc', '2006-03-28 14:53:12', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (22, 0, 'abc', 'abc', '2006-03-28 15:01:42', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (23, 0, 'abc', 'abc', '2006-03-28 15:02:04', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (24, 0, 'abc', 'abc', '2006-03-28 15:02:26', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
INSERT INTO `parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a` VALUES (25, 0, 'abc', 'abc', '2006-03-28 15:03:37', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc', '1970-01-01 22:46:40', 123, 123, 123, 123, 'abc');
