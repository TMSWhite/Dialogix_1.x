-- phpMyAdmin SQL Dump
-- version 2.6.0-pl3
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generation Time: Dec 30, 2004 at 04:22 PM
-- Server version: 4.1.7
-- PHP Version: 5.0.3RC2-dev
-- 
-- Database: `dialogix2994`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `pagehitdetails`
-- 

CREATE TABLE `pagehitdetails` (
  `pageHitDetailsID` int(11) NOT NULL auto_increment,
  `pageHitID_FK` int(11) NOT NULL default '0',
  `param` varchar(40) NOT NULL default '',
  `value` varchar(254) NOT NULL default '',
  PRIMARY KEY  (`pageHitDetailsID`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `pagehitevents`
-- 

CREATE TABLE `pagehitevents` (
  `pageHitEventsID` int(11) NOT NULL auto_increment,
  `pageHitID_FK` int(11) NOT NULL default '0',
  `varName` varchar(40) NOT NULL default '',
  `actionType` varchar(18) NOT NULL default '',
  `eventType` varchar(18) NOT NULL default '',
  `timestamp` bigint(15) NOT NULL default '0',
  `duration` int(11) NOT NULL default '0',
  `value1` varchar(10) NOT NULL default '',
  `value2` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`pageHitEventsID`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `pagehits`
-- 

CREATE TABLE `pagehits` (
  `pageHitID` int(11) NOT NULL auto_increment,
  `timeStamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `accessCount` int(11) NOT NULL default '-1',
  `currentIP` varchar(16) NOT NULL default '',
  `username` varchar(15) NOT NULL default '',
  `sessionID` varchar(35) NOT NULL default '',
  `workingFile` varchar(100) NOT NULL default '',
  `javaObject` varchar(40) NOT NULL default '',
  `browser` varchar(200) NOT NULL default '',
  `instrumentName` varchar(100) NOT NULL default '',
  `currentStep` int(11) NOT NULL default '-1',
  `displayCount` int(11) NOT NULL default '-1',
  `lastAction` varchar(15) NOT NULL default '',
  `statusMsg` varchar(35) NOT NULL default '',
  `totalMemory` bigint(15) NOT NULL default '0',
  `freeMemory` bigint(15) NOT NULL default '0',
  PRIMARY KEY  (`pageHitID`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `wave6users`
-- 

CREATE TABLE `wave6users` (
  `username` varchar(25) NOT NULL default '',
  `password` varchar(25) NOT NULL default '',
  `filename` varchar(100) NOT NULL default '.',
  `instrument` varchar(100) NOT NULL default '',
  `status` varchar(20) NOT NULL default 'unstarted',
  `startingStep` varchar(5) NOT NULL default '0',
  `_clinpass` varchar(20) NOT NULL default '',
  `Dem1` varchar(20) NOT NULL default '',
  `lastAccess` varchar(30) NOT NULL default '',
  `currentStep` varchar(40) NOT NULL default '',
  `currentIP` varchar(40) NOT NULL default '',
  `lastAction` varchar(15) NOT NULL default '',
  `sessionID` varchar(40) NOT NULL default '',
  `browser` varchar(200) NOT NULL default '',
  `statusMsg` varchar(35) NOT NULL default ''
) ENGINE=MyISAM;
        