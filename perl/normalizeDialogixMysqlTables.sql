/* Code for normalizing the Dialogix tables */

/*
CREATE TABLE RawData (
  RawDataID bigint(20) NOT NULL auto_increment,
  InstrumentName varchar(200) NOT NULL default '',
  InstanceName varchar(200) NOT NULL default '',
  VarName varchar(100) NOT NULL default '',
  VarNum int(11) NOT NULL default '0',
  GroupNum smallint(6) NOT NULL default '0',
  DisplayNum smallint(6) NOT NULL default '0',
  LangNum smallint(6) NOT NULL default '0',
  WhenAsMS bigint(20) NOT NULL default '0',
  TimeStamp timestamp(14) NOT NULL,
  AnswerType tinyint(4) NOT NULL default '0',
  Answer text,
  QuestionAsAsked text,
  Comment text,
  PRIMARY KEY  (RawDataID),
  KEY InstrumentName (InstrumentName)
) TYPE=MyISAM;
*/

/*
create table Dialogix.UniqueInstruments (
	ID int(11) NOT NULL auto_increment,
  	InstrumentName varchar(200) NOT NULL default '',
  	PRIMARY KEY  (ID)
) TYPE=MyISAM;

create table Dialogix.UniqueInstances (
	ID int(11) NOT NULL auto_increment,
  	InstanceName varchar(200) NOT NULL default '',
  	PRIMARY KEY  (ID)
) TYPE=MyISAM;
*/

/*
create table Dialogix.UniqueVarNames (
	ID int(11) NOT NULL auto_increment,
  	VarName varchar(100) NOT NULL default '',
  	PRIMARY KEY  (ID)
) TYPE=MyISAM;
*/

/*
insert into Dialogix.UniqueInstruments (InstrumentName)
	select distinct InstrumentName from Dialogix.RawData;
	
insert into Dialogix.UniqueInstances (InstanceName)
	select distinct InstanceName from Dialogix.RawData;
*/

/*	
insert into Dialogix.UniqueVarNames (VarName)
	select distinct VarName from Dialogix.RawData;	
*/	

/* This is the only portion of the file needed to add a set of Instances */
drop table if exists Dialogix.Instances;
CREATE TABLE Dialogix.Instances (
	ID int(11) NOT NULL auto_increment,
  	PRIMARY KEY  (ID),
	InstrumentName varchar(200) NOT NULL default '',
	InstanceName varchar(200) NOT NULL default '',
	StartDate bigint(21) default NULL,
	EndDate bigint(21) default NULL,
	NumPagesViewed bigint(21) default NULL,
	Duration bigint(17) default NULL,
	Finished int(1) NOT NULL default '0',
	KEY InstrumentName (InstrumentName),
	KEY InstanceName (InstanceName)
) TYPE=MyISAM;

insert into Dialogix.Instances
select NULL, InstrumentName, InstanceName, min(TimeStamp) as StartDate, max(TimeStamp) as EndDate, max(DisplayNum) as NumPagesViewed,
	(max(TimeStamp) - min(TimeStamp)) as Duration, (InstanceName not like "%(tri%") as Finished
from Dialogix.RawData
group by InstanceName
order by InstrumentName, StartDate;

/*   
insert into Dialogix.Instances
select NULL, InstrumentName, InstanceName, StartDate, EndDate, NumPagesViewed, Duration, Finished
from test.Instances;
*/