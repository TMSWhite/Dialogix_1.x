# phpMyAdmin SQL Dump
# version 2.5.6
# http://www.phpmyadmin.net
#
# Host: psychinformatics
# Generation Time: Nov 16, 2004 at 09:06 AM
# Server version: 3.23.58
# PHP Version: 4.3.8
# 
# Database : `Dialogix`
# 

# --------------------------------------------------------

#
# Table structure for table `instruments`
#

DROP TABLE IF EXISTS `instruments`;
CREATE TABLE `instruments` (
  `Project` varchar(20) NOT NULL default '',
  `Base` varchar(100) NOT NULL default '',
  `Title` varchar(255) NOT NULL default '',
  `Version` varchar(20) NOT NULL default '',
  `DateImplemented` date NOT NULL default '0000-00-00',
  `NumLanguages` int(11) NOT NULL default '0',
  `NumQs` int(11) NOT NULL default '0',
  `NumEs` int(11) NOT NULL default '0',
  `NumAlwaysQs` int(11) NOT NULL default '0',
  `LaunchCommand` text NOT NULL
) TYPE=MyISAM;

#
# Dumping data for table `instruments`
#

INSERT INTO `instruments` VALUES ('BYS', 'BYS-Adult', 'BYS Adult Baseline (Revised 11/28/2000)', '3.2.1', '2002-03-09', 2, 1315, 217, 429, 'http://psychinformatics.nyspi.org:8080/BYS/servlet/Dialogix?schedule=BYS/WEB-INF/schedules/BYS-Adult.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('BYS', 'BYS-Child', 'BYS Youth Baseline (Revised 11/28/2000)', '3..3.0', '2002-03-09', 2, 1199, 112, 270, 'http://psychinformatics.nyspi.org:8080/BYS/servlet/Dialogix?schedule=BYS/WEB-INF/schedules/BYS-Child.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('CET', 'AutoMEQ-SA-irb', 'AutoMEQ-SA', '6.0', '2004-08-16', 1, 339, 157, 2, 'http://psychinformatics.nyspi.org:8080/CET/servlet/Dialogix?schedule=CET/WEB-INF/schedules/AutoMEQ-SA-irb.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Wave6', 'wave6-web', 'Children in the Community: Wave 6', '3.0.5', '2003-04-15', 1, 1659, 330, 618, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/wave6-web.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('CET', 'AutoPIDS-SA', 'AutoPIDS-SA', '2.0', '2003-10-28', 1, 262, 132, 34, 'http://psychinformatics.nyspi.org:8080/CET/servlet/Dialogix?schedule=CET/WEB-INF/schedules/AutoPIDS-SA.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('CET', 'MCTQv6E', 'Munich ChronoType Questionnaire', '0.1', '2002-08-17', 1, 71, 0, 47, 'http://psychinformatics.nyspi.org:8080/CET/servlet/Dialogix?schedule=CET/WEB-INF/schedules/MCTQv6E.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('CIC', 'CIC-newnumb22', 'Children in the Community: Transition Study (11/14/2000)', '0.0', '2002-03-09', 1, 1497, 286, 1028, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=CIC/WEB-INF/schedules/CIC-newnumb22.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'SCID-I-P', 'SCID I/P (v. 2.0) - Structured Clinical Interview for DSM-IV (Draft/Subset)', '0.0', '2004-10-19', 1, 87, 2, 37, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/SCID-I-P.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'AUDIT', 'AUDIT: Alcohol Use Disorders Identification Test', '0.0', '2002-03-09', 1, 12, 1, 12, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/AUDIT.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'AchievingStyles', 'Achieving Styles Individual Inventory', '0.0', '2002-03-09', 1, 73, 9, 71, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/AchievingStyles.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'BPRSa', 'BPRS - Brief Psychiatric Rating Scale', '0.0', '2002-03-09', 1, 28, 12, 28, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/BPRSa.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'Basis32', 'Basis-32 - Behavior and Symptom Identifcation Scale', '0.0', '2002-03-09', 1, 45, 7, 35, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/Basis32.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'DISC-combined', 'DISC: Interviews for ADHD, Eating, Depression, and Social Phobia', '0.0', '2003-03-07', 2, 636, 153, 90, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/DISC-combined.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'French-English-Demo', 'Dialogix is Multi-Lingual', '0.0', '2002-03-09', 2, 5, 0, 4, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/French-English-Demo.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'GAF', 'eGAF: Global Assessment of Function Using Multiple Axes', '0.0', '2002-03-09', 1, 28, 4, 28, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/GAF.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'GAFTree', 'GAFTree: Global Assessment of Function', '0.0', '2002-03-09', 1, 36, 37, 4, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/GAFTree.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'HAM-D', 'Hamilton Depression Inventory', '0.0', '2003-09-29', 1, 29, 1, 27, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/HAM-D.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'MJT-modified', 'MJT', '0.0', '2002-03-09', 1, 38, 28, 38, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/MJT-modified.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'NIDA', 'NIDA Drug Abuse Assessment', '0.0', '2002-03-09', 1, 123, 0, 123, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/NIDA.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'PHQ-Brief', 'PHQ-Brief', '0.0', '2002-03-09', 1, 49, 6, 34, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/PHQ-Brief.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'PHQ', 'PHQ', '0.0', '2002-03-09', 1, 107, 17, 60, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/PHQ.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'ParkinsonsRatingScale', 'Unified Parkinson\'s Disease Rating Scale', '0.0', '2002-03-09', 1, 14, 2, 14, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/ParkinsonsRatingScale.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'SAFTEE', 'SAFTEE', '0.0', '2002-03-09', 1, 225, 0, 123, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/SAFTEE.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'SCID-II', 'SCID II (v. 2.0) - Structured Clinical Interview for DSM-IV', '0.0', '2002-03-09', 1, 530, 42, 325, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/SCID-II.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'SF-36', 'SF-36 Health Survey', '0.0', '2002-03-09', 1, 43, 18, 43, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/SF-36.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'ShortDPS-Youth', 'Short DPS - Youth Version', '0.0', '2002-03-09', 1, 50, 22, 50, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/ShortDPS-Youth.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'TBscreen', 'NYC DOH Tuberculosis Testing & Treatment Guidline', '0.0', '2003-03-07', 1, 64, 14, 20, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/TBscreen.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'QAM', 'Quality Audit Marker', '0.0', '2004-10-19', 1, 10, 0, 10, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/QAM.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'user-eval', 'Dialogix User Evaluation', '0.0', '2002-03-09', 1, 21, 0, 21, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/user-eval.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('MU-InfoSurvey', 'musecsurvey', 'Security Survey', '0.0', '2002-03-09', 1, 64, 0, 14, 'http://psychinformatics.nyspi.org:8080/MU-InfoSurvey/servlet/Dialogix?schedule=MU-InfoSurvey/WEB-INF/schedules/musecsurvey.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'Omaha', 'Omaha Classification', '0.0', '2004-10-19', 1, 240, 0, 240, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/Omaha.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Prefs', 'Preferences-2_9a', 'CHOICEs', '3.0', '2002-04-23', 1, 609, 1, 28, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/Preferences-2_9a.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'introduction', 'A - Introduction to Using Dialogix', '0.0', '2003-03-07', 39, 30, 2, 27, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/introduction.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Clincare', 'clincare7', 'CLINCARE-D 2003 SYSTEMATIC (RESEARCH)', '0.2.0', '2003-11-04', 1, 351, 304, 224, 'http://psychinformatics.nyspi.org:8080/Clincare/servlet/Dialogix?schedule=Clincare/WEB-INF/schedules/clincare7.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Dynamed', 'DynaMed_Processing', 'DynaMed Processing', '0.0', '2003-05-22', 1, 268, 0, 3, 'http://psychinformatics.nyspi.org:8080/Dynamed/servlet/Dialogix?schedule=Dynamed/WEB-INF/schedules/DynaMed_Processing.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'LIV-HIV', 'Living with HIV', '0.0', '2004-10-19', 1, 38, 0, 38, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/LIV-HIV.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'HIV-SSC', 'HIV-SSC', '0.0', '2004-10-19', 1, 26, 0, 26, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/HIV-SSC.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('NANPCS', 'NANPCS_8', 'NANPCS (requires logon)', '1.0.0', '2003-08-02', 1, 141, 8, 109, 'http://psychinformatics.nyspi.org:8080/NANPCS/servlet/Dialogix?schedule=NANPCS/WEB-INF/schedules/NANPCS_8.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Test', 'SPOE', 'Adult SPOE (Draft/Subset)', '0.0', '2002-04-25', 1, 103, 2, 76, 'http://psychinformatics.nyspi.org:8080/Test/servlet/Dialogix?schedule=Test/WEB-INF/schedules/SPOE.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Wave6', 'EarlyEndTest', 'Wave6 Fragment (Demo)', '0.0', '2003-03-04', 1, 13, 6, 13, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Wave6/WEB-INF/schedules/EarlyEndTest.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Wave6', 'wave6-qol-web', 'Wave 6 Quality of Life - Web Version', '3..1', '2002-07-16', 1, 322, 2, 144, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Wave6/WEB-INF/schedules/wave6-qol-web.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Wave6', 'wave6-sa-web', 'Wave 6 Self Assessment - Web Version', '3..1', '2002-07-16', 1, 1347, 327, 512, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Wave6/WEB-INF/schedules/wave6-sa-web.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'HHCC', 'Home Health Care Classification', '0.0', '2004-10-19', 1, 156, 0, 156, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/HHCC.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'MHSS2004', 'Mental Health Services Survey 2004', '1.0', '2004-10-19', 1, 88, 0, 82, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/MHSS2004.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Wave6', 'wave6-web', 'Children in the Community: Wave 6 (requires logon)', '3.0.5', '2003-04-15', 1, 1659, 330, 618, 'http://psychinformatics.nyspi.org:8080/Wave6/servlet/Dialogix?schedule=Wave6/WEB-INF/schedules/wave6-web.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('keeping', 'Keeping_Up_Estimation_Full', 'Keeping Up Estimation', '0.0', '2003-06-30', 1, 239, 0, 7, 'http://psychinformatics.nyspi.org:8080/keeping/servlet/Dialogix?schedule=keeping/WEB-INF/schedules/Keeping_Up_Estimation_Full.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('NANPCS', 'NANPCS_8', 'NANPCS', '1.0.0', '2003-08-02', 1, 141, 8, 109, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/NANPCS_8.jar&DIRECTIVE=START');
INSERT INTO `instruments` VALUES ('Demos', 'NYSPI-EOS', 'New York State Psychiatric Institute - Employee Opinion Survey', '1', '2004-11-12', 1, 104, 0, 104, 'http://psychinformatics.nyspi.org:8080/Demos/servlet/Dialogix?schedule=Demos/WEB-INF/schedules/NYSPI-EOS.jar&DIRECTIVE=START');
    

# phpMyAdmin SQL Dump
# version 2.5.6
# http://www.phpmyadmin.net
#
# Host: psychinformatics
# Generation Time: Nov 16, 2004 at 09:06 AM
# Server version: 3.23.58
# PHP Version: 4.3.8
# 
# Database : `Dialogix`
# 

# --------------------------------------------------------

#
# Table structure for table `publications`
#

DROP TABLE IF EXISTS `publications`;
CREATE TABLE `publications` (
  `Authors` varchar(255) NOT NULL default '',
  `Title` text NOT NULL,
  `Journal` varchar(60) NOT NULL default '',
  `Year` int(11) NOT NULL default '0',
  `JournalRef` varchar(100) NOT NULL default '',
  `PubMed` text NOT NULL,
  `Topic` varchar(50) NOT NULL default '',
  `Type` varchar(50) NOT NULL default ''
) TYPE=MyISAM;

#
# Dumping data for table `publications`
#

INSERT INTO `publications` VALUES ('White TM, Hauan MJ.', 'Using client-side event logging and path tracing to assess and improve the quality of web-based surveys.', 'Proc AMIA Symp', 2002, 'Proc AMIA Symp. 2002:894-8.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=12463954', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('White TM, Hauan MJ.', 'Extending the LOINC conceptual schema to support standardized assessment instruments.', 'J Am Med Inform Assoc', 2002, 'J Am Med Inform Assoc. 2002 Nov-Dec;9(6):586-99.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=12386110', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('White TM, Hauan MJ.', 'The capture and use of detailed process information in the Dialogix system for structured web-based interactions.', 'Proc AMIA Symp.', 2001, 'Proc AMIA Symp. 2001:761-5.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=11825288', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('Jenkins ML, White T, Lin S, Choi J, Du E.', 'Piloting web-based NAMCS data collection for nurse-managed centers.', 'AMIA Annu Symp Proc.', 2003, 'AMIA Annu Symp Proc. 2003:880.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=14728385', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('Ruland CM, White T, Stevens M, Fanciullo G, Khilani SM.', 'Effects of a computerized system to support shared decision making in symptom management of cancer patients: preliminary results.', 'J Am Med Inform Assoc.', 2003, 'J Am Med Inform Assoc. 2003 Nov-Dec;10(6):573-9.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=12925545', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('Finnerty M, Altmansberger R, Bopp J, Carpinello S, Docherty JP, Fisher W, Jensen P, Krishnan P, Mittleman M, Olfson M, Tricarico J, White T, Felton C.', 'Using state administrative and pharmacy data bases to develop a clinical decision support tool for schizophrenia guidelines.', 'Schizophr Bull.', 2002, 'Schizophr Bull. 2002;28(1):85-94.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=12047025', 'PSYCKES', 'Paper');
INSERT INTO `publications` VALUES ('Gardner D, Knuth KH, Abato M, Erde SM, White T, DeBellis R, Gardner EP.', 'Common data model for neuroscience data and data model exchange', 'J Am Med Inform Assoc.', 2001, 'J Am Med Inform Assoc. 2001 Jan-Feb;8(1):17-33.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=11141510', 'Informatics', 'Paper');
INSERT INTO `publications` VALUES ('Blumberg HP, Stern E, Martinez D, Ricketts S, de Asis J, White T, Epstein J, McBride PA, Eidelberg D, Kocsis JH, Silbersweig DA.', 'Increased anterior cingulate and caudate activity in bipolar mania.', 'Biol Psychiatry.', 2000, 'Biol Psychiatry. 2000 Dec 1;48(11):1045-52', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=11094137', 'NeuroImaging', 'Paper');
INSERT INTO `publications` VALUES ('Starren J, Chan S, Tahil F, White T.', 'When seconds are counted: tools for mobile, high-resolution time-motion studies.', 'Proc AMIA Symp.', 2000, 'Proc AMIA Symp. 2000:833-7.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=11080001', 'Informatics', 'Paper');
INSERT INTO `publications` VALUES ('Bremner JD, Innis RB, White T, Fujita M, Silbersweig D, Goddard AW, Staib L, Stern E, Cappiello A, Woods S, Baldwin R, Charney DS.', 'SPECT [I-123]iomazenil measurement of the benzodiazepine receptor in panic disorder.', 'Biol Psychiatry.', 2000, 'Biol Psychiatry. 2000 Jan 15;47(2):96-106.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=10664825', 'NeuroImaging', 'Paper');
INSERT INTO `publications` VALUES ('Blumberg HP, Stern E, Ricketts S, Martinez D, de Asis J, White T, Epstein J, Isenberg N, McBride PA, Kemperman I, Emmerich S, Dhawan V, Eidelberg D, Kocsis JH, Silbersweig DA.', 'Rostral and orbital prefrontal cortex dysfunction in the manic state of bipolar disorder.', 'Am J Psychiatry.', 1999, 'Am J Psychiatry. 1999 Dec;156(12):1986-8.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=10588416', 'NeuroImaging', 'Paper');
INSERT INTO `publications` VALUES ('White TM, Terman M', 'Effects of Light Pigmentation and Latitude on Chronotype and Sleep Timing', 'Chronobiology International', 2003, 'Chronobiology International 20: 1993-1995, 2003', '', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('White TM, Terman M.', 'The Global Seasonality Score Reconsidered:  Convergence on Diagnosis of Winter Depression', 'Chronobiology International', 2004, 'Chronobiology International 21: 805, 2004', '', 'Dialogix', 'Paper');
INSERT INTO `publications` VALUES ('Cohen T, Kaufman D, White T, Segal G, Bennett Staub A, Patel V, Finnerty M.', 'Cognitive evaluation of an innovative psychiatric clinical knowledge enhancement system.', 'Medinfo.', 2004, 'Medinfo. 2004; 1295-9, 2004.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=15361023', 'PSYCKES', 'Paper');
INSERT INTO `publications` VALUES ('White TM, Finnerty M, Felton C.', 'Implementation of a Novel, Psychiatric Clinical Knowledge Enhancement System to Improve Quality of Care and Reduce Pharmacy Expenditures,', 'MedInfo.', 2004, 'Medinfo. 2004; 1906, 2004.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=15360734', 'PSYCKES', 'Paper');
    

