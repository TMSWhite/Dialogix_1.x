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

/*
create table Dialogix.UniqueVarNames (
	ID int(11) NOT NULL auto_increment,
  	VarName varchar(100) NOT NULL default '',
  	PRIMARY KEY  (ID)
) TYPE=MyISAM;
*/

insert into Dialogix.UniqueInstruments (InstrumentName)
	select distinct InstrumentName from Dialogix.RawData;
	
insert into Dialogix.UniqueInstances (InstanceName)
	select distinct InstanceName from Dialogix.RawData;

/*	
insert into Dialogix.UniqueVarNames (VarName)
	select distinct VarName from Dialogix.RawData;	
*/	

CREATE TABLE Dialogix.RawData2 (
  RawDataID bigint(20) NOT NULL auto_increment,
  InstrumentNum int(11) NOT NULL default '0',
  InstanceNum int(11) NOT NULL default '0',
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
  PRIMARY KEY  (RawDataID)
) TYPE=MyISAM;	
	
insert into Dialogix.RawData2
select a.RawDataID,
	b.ID as InstrumentNum,
	c.ID as InstanceNum,
	a.VarNum,
	a.GroupNum,
	a.DisplayNum,
	a.LangNum,
	a.WhenAsMS,
	a.TimeStamp,
	a.AnswerType,
	a.Answer,
	a.QuestionAsAsked,
	a.Comment
from Dialogix.RawData a, Dialogix.UniqueInstruments b, Dialogix.UniqueInstances c
where a.InstrumentName = b.InstrumentName and
	a.InstanceName = c.InstanceName;