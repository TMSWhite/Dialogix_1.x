# convert tab delimited to MySql

use strict;

my ($db, $table, $user, $passwd) = ('dialogix_users', 'wave6users', 'javauser', 'javadude');

   
print "GRANT ALL PRIVILEGES ON *.* TO $user\@localhost IDENTIFIED BY '$passwd' WITH GRANT OPTION;\n";
print "create database $db;\n";
print "use $db;\n";
print "CREATE TABLE $table (\n";
print "	username varchar(25) NOT NULL default '',\n";
print "	password varchar(25) NOT NULL default '',\n";
print "	filename varchar(100) NOT NULL default '.',\n";
print "	instrument varchar(100) NOT NULL default '',\n";
print "	status varchar(20) NOT NULL default 'unstarted',\n";
print "	startingStep varchar(5) NOT NULL default '0',\n";
print "	_clinpass varchar(20) NOT NULL default '',\n";
print "	Dem1 varchar(20) NOT NULL default '',\n";
print "	lastAccess varchar(30) NOT NULL default '',\n";
print "	currentStep varchar(40) NOT NULL default '',\n";
print "	currentIP varchar(40) NOT NULL default '',\n";
print "	lastAction varchar(15) NOT NULL default '',\n";
print "	sessionID varchar(40) NOT NULL default '',\n";
print "	browser varchar(200) NOT NULL default '',\n";
print "	statusMsg varchar(35) NOT NULL default ''\n";
print "	);\n";

while (<>) {
	chomp;
	next if (/^\s*$/);
	s/\\/\//g;
	my @args = split(/\t/);
	
	push @args, ('','','','','','','');
	
	print "INSERT INTO wave6users VALUES ('" . join("', '",@args) . "');\n";
}


CREATE TABLE sessions (
  sessionID int(11) NOT NULL auto_increment,
  PRIMARY KEY  ( sessionID ),
  sessionKEY varchar(50) NOT NULL,
  instrument varchar(100) NOT NULL default '',
  firstIP varchar(40) NOT NULL default '',
  browser varchar(200) NOT NULL default '',
  tricepsEngine varchar(40) NOT NULL default ''
  );
  
CREATE TABLE pagehits (
	pageHitID int(11) NOT NULL auto_increment,
	PRIMARY KEY  ( pageHitID ),
	timeStamp timestamp(14) NOT NULL,
	accessCount int(11) NOT NULL default '-1',
	currentIP varchar(16) NOT NULL default '',
	username varchar(15) NOT NULL default '',
	sessionID varchar(35) NOT NULL default '',
	workingFile varchar(100) NOT NULL default '',
	javaObject varchar(40) NOT NULL default '',
	browser varchar(200) NOT NULL default '',
	instrumentName varchar(100) NOT NULL default '',	
	currentStep varchar(10) NOT NULL default '',
	lastAction varchar(15) NOT NULL default '',
	statusMsg varchar(35) NOT NULL default ''
);

CREATE TABLE pageHitDetails (
	pageHitDetailsID int(11) NOT NULL auto_increment,
	PRIMARY KEY  ( pageHitDetailsID ),
	timeStamp timestamp(14) NOT NULL,
	accessCount int(11) NOT NULL default '-1',
	currentIP varchar(16) NOT NULL default '',
	currentStep varchar(10) NOT NULL default '',
	param varchar(40) NOT NULL default '',
	value varchar(254) NOT NULL default ''
);

# This tests whether there is mis-filing of files:
select distinct javaObject, username, workingFile, currentIP, instrumentName, sessionID from pagehits order by username, workingFile
select distinct username, workingFile, browser, currentIP, instrumentName from pagehits order by username, workingFile

# This tests whether a java object can span sessions
select distinct javaObject, sessionID from pagehits order by sessionID
select distinct username, workingFile, sessionID, javaObject from pagehits where username != 'null' order by username, workingFile, sessionID

SELECT DISTINCT username, workingFile, browser, currentIP, instrumentName, currentStep, lastAction FROM pagehits where workingFile like '%tri16216%' ORDER BY pageHitID;

SELECT DISTINCT browser, workingFile, instrumentName from pagehits ORDER BY workingFile

SELECT  workingFile, count(currentIP), count(username) from pagehits group by workingFile orderby workingfile.

SELECT DISTINCT timestamp, workingFile, currentStep FROM pagehits where currentStep = 0 and workingFIle like "%CET%" order by timestamp
SELECT DISTINCT timestamp, currentIP, accessCount, sessionID, javaObject, workingFile, currentStep FROM pagehits where currentStep = 11 and workingFIle like "%CET%" order by timestamp
SELECT DISTINCT timestamp, workingFile, currentStep FROM pagehits where currentStep = 36 and workingFIle like "%CET%" order by timestamp
SELECT DISTINCT timestamp, workingFile, currentStep FROM pagehits where currentStep = 52 and workingFIle like "%CET%" order by timestamp

select pageHitID, username, workingFile, sessionID, javaObject from pagehits where username != 'null' order by username, workingFile, pageHitID

select pageHitID, timestamp, username, workingFile, currentIP, currentStep, lastAction, javaObject, accessCount from pagehits where workingFile like "%wave6%" order by workingFile, pageHitID

# combine pagehit and pageHitDetails tables
select l.pageHitID, l.currentIP, l.accessCount, l.username, l.workingFile, l.currentStep, l.lastAction, r.param, r.value
from pagehits l left join pageHitDetails r
on l.accessCount = r.accessCount and l.currentIP = r.currentIP and l.timestamp = r.timestamp
order by l.pageHitID

select accessCount, currentIP, currentStep, value from pageHitDetails where param like "DIRECTIVE" order by timestamp, currentIP, accessCount;

# [] This doesn't seem to address the information I need -- having trouble connecting pageHits and pageHitDetails
# [] newer JDBC with Java 1.4 allows access to autogenerated keys, which would be the ideal
# [] mysql supports transactions, but probably not the version I'm using?

SELECT pagehitID, timestamp, currentIP, accessCount, sessionID, javaObject, workingFile, currentStep, lastAction FROM pagehits where sessionID="2C241EE3ECA523E2F95C634304E05193" order by timestamp

