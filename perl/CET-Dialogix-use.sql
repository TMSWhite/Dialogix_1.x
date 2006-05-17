/* SQL for MySql to measure current AutoMEQ and AutoPIDS utilization */

drop table if exists  test.uniqueCETusers;

create table test.uniqueCETusers as
select distinct 
	(case
	when instrumentName like "%AutoMEQ-SA-irb.jar" then "AutoMEQ"
	when instrumentName like "%AutoPIDS-SA.jar" then "AutoPIDS"
	else "other" end) as instrument,
	(case
	when timestamp > 20041115000000 then 6
	when timestamp > 20031028162400 then 5
	when timestamp > 20031021160000 then 4
	when timestamp > 20020729180000 then 3
	else 2.3 end) as AutoMEQversion,	
	(case
	when timestamp > 20031028160000 then 2.0
	when timestamp > 20031020113000 then 1.2
	when timestamp > 20031009100000 then 1.1
	when timestamp > 20031008150000 then 1.0
	else 0 end) as AutoPIDSversion,
	year(timestamp) as year, 
	month(timestamp) as month, 
	dayofmonth(timestamp) as day, 
	dayofyear(timestamp) as dayofyear, 
	floor(timestamp / 1000000) as date, 
	sessionID, 
	max(currentStep) as lastStep,
	max(if(currentStep=45,1,0)) as AutoMEQ5_Demos,
	max(if(currentStep=58,1,0)) as AutoMEQ5_PIDS_A,
	max(if(currentStep=67,1,0)) as AutoMEQ5_PIDS_B,
	max(if(currentStep=85,1,0)) as AutoMEQ5_PIDS_C1A,
	max(if(currentStep=117,1,0)) as AutoMEQ5_PIDS_C1B,
	max(if(currentStep=134,1,0)) as AutoMEQ5_PIDS_C2A,
	max(if(currentStep=166,1,0)) as AutoMEQ5_PIDS_C2B,
	max(if(currentStep=183,1,0)) as AutoMEQ5_PIDS_C3A,
	max(if(currentStep=215,1,0)) as AutoMEQ5_PIDS_C3B,
	max(if(currentStep=232,1,0)) as AutoMEQ5_PIDS_C4A,
	max(if(currentStep=264,1,0)) as AutoMEQ5_PIDS_C4B,
	max(if(currentStep=281,1,0)) as AutoMEQ5_PIDS_C5A,
	max(if(currentStep=313,1,0)) as AutoMEQ5_PIDS_C5B,
	max(if(currentStep=330,1,0)) as AutoMEQ5_PIDS_C6A,
	max(if(currentStep=388,1,0)) as AutoMEQ5_PIDS_C6B,
	max(if(currentStep=405,1,0)) as AutoMEQ5_PIDS_D,
	max(if(currentStep=428,1,0)) as AutoMEQ5_PIDS_Scores,
	max(if(currentStep>458,1,0)) as AutoMEQ5_Finished,	
	max(if(currentStep=45,1,0)) as AutoMEQ4_Demos,
	max(if(currentStep=56,1,0)) as AutoMEQ4_PIDS_B,
	max(if(currentStep=74,1,0)) as AutoMEQ4_PIDS_C1A,
	max(if(currentStep=106,1,0)) as AutoMEQ4_PIDS_C1B,
	max(if(currentStep=123,1,0)) as AutoMEQ4_PIDS_C2A,
	max(if(currentStep=155,1,0)) as AutoMEQ4_PIDS_C2B,
	max(if(currentStep=172,1,0)) as AutoMEQ4_PIDS_C3A,
	max(if(currentStep=204,1,0)) as AutoMEQ4_PIDS_C3B,
	max(if(currentStep=221,1,0)) as AutoMEQ4_PIDS_C4A,
	max(if(currentStep=253,1,0)) as AutoMEQ4_PIDS_C4B,
	max(if(currentStep=270,1,0)) as AutoMEQ4_PIDS_C5A,
	max(if(currentStep=302,1,0)) as AutoMEQ4_PIDS_C5B,
	max(if(currentStep=319,1,0)) as AutoMEQ4_PIDS_C6A,
	max(if(currentStep=377,1,0)) as AutoMEQ4_PIDS_C6B,
	max(if(currentStep=388,1,0)) as AutoMEQ4_PIDS_D,
	max(if(currentStep=401,1,0)) as AutoMEQ4_PIDS_Scores,
	max(if(currentStep>430,1,0)) as AutoMEQ4_Finished,
	max(if(currentStep=24,1,0)) as AutoMEQ3_Demos,
	max(if(currentStep>52,1,0)) as AutoMEQ3_Finished	
from dialogix2994.pageHits
group by sessionID
having lastStep > 2 and instrument <> "other"
order by instrument, year, month, day;

insert into test.uniqueCETusers
select distinct 
	(case
	when instrumentName like "%AutoMEQ-SA-irb.jar" then "AutoMEQ"
	when instrumentName like "%AutoPIDS-SA.jar" then "AutoPIDS"
	else "other" end) as instrument,
	(case
	when timestamp > 20041115000000 then 6
	when timestamp > 20031028162400 then 5
	when timestamp > 20031021160000 then 4
	when timestamp > 20020729180000 then 3
	else 2.3 end) as AutoMEQversion,	
	(case
	when timestamp > 20031028160000 then 2.0
	when timestamp > 20031020113000 then 1.2
	when timestamp > 20031009100000 then 1.1
	when timestamp > 20031008150000 then 1.0
	else 0 end) as AutoPIDSversion,
	year(timestamp) as year, 
	month(timestamp) as month, 
	dayofmonth(timestamp) as day, 
	dayofyear(timestamp) as dayofyear, 
	floor(timestamp / 1000000) as date, 
	sessionID, 
	max(currentStep) as lastStep,
	max(if(currentStep=45,1,0)) as AutoMEQ5_Demos,
	max(if(currentStep=58,1,0)) as AutoMEQ5_PIDS_A,
	max(if(currentStep=67,1,0)) as AutoMEQ5_PIDS_B,
	max(if(currentStep=85,1,0)) as AutoMEQ5_PIDS_C1A,
	max(if(currentStep=117,1,0)) as AutoMEQ5_PIDS_C1B,
	max(if(currentStep=134,1,0)) as AutoMEQ5_PIDS_C2A,
	max(if(currentStep=166,1,0)) as AutoMEQ5_PIDS_C2B,
	max(if(currentStep=183,1,0)) as AutoMEQ5_PIDS_C3A,
	max(if(currentStep=215,1,0)) as AutoMEQ5_PIDS_C3B,
	max(if(currentStep=232,1,0)) as AutoMEQ5_PIDS_C4A,
	max(if(currentStep=264,1,0)) as AutoMEQ5_PIDS_C4B,
	max(if(currentStep=281,1,0)) as AutoMEQ5_PIDS_C5A,
	max(if(currentStep=313,1,0)) as AutoMEQ5_PIDS_C5B,
	max(if(currentStep=330,1,0)) as AutoMEQ5_PIDS_C6A,
	max(if(currentStep=388,1,0)) as AutoMEQ5_PIDS_C6B,
	max(if(currentStep=405,1,0)) as AutoMEQ5_PIDS_D,
	max(if(currentStep=428,1,0)) as AutoMEQ5_PIDS_Scores,
	max(if(currentStep>458,1,0)) as AutoMEQ5_Finished,	
	max(if(currentStep=45,1,0)) as AutoMEQ4_Demos,
	max(if(currentStep=56,1,0)) as AutoMEQ4_PIDS_B,
	max(if(currentStep=74,1,0)) as AutoMEQ4_PIDS_C1A,
	max(if(currentStep=106,1,0)) as AutoMEQ4_PIDS_C1B,
	max(if(currentStep=123,1,0)) as AutoMEQ4_PIDS_C2A,
	max(if(currentStep=155,1,0)) as AutoMEQ4_PIDS_C2B,
	max(if(currentStep=172,1,0)) as AutoMEQ4_PIDS_C3A,
	max(if(currentStep=204,1,0)) as AutoMEQ4_PIDS_C3B,
	max(if(currentStep=221,1,0)) as AutoMEQ4_PIDS_C4A,
	max(if(currentStep=253,1,0)) as AutoMEQ4_PIDS_C4B,
	max(if(currentStep=270,1,0)) as AutoMEQ4_PIDS_C5A,
	max(if(currentStep=302,1,0)) as AutoMEQ4_PIDS_C5B,
	max(if(currentStep=319,1,0)) as AutoMEQ4_PIDS_C6A,
	max(if(currentStep=377,1,0)) as AutoMEQ4_PIDS_C6B,
	max(if(currentStep=388,1,0)) as AutoMEQ4_PIDS_D,
	max(if(currentStep=401,1,0)) as AutoMEQ4_PIDS_Scores,
	max(if(currentStep>430,1,0)) as AutoMEQ4_Finished,
	max(if(currentStep=24,1,0)) as AutoMEQ3_Demos,
	max(if(currentStep>52,1,0)) as AutoMEQ3_Finished	
from dialogix2993.pageHits
group by sessionID
having lastStep > 2 and instrument <> "other"
order by instrument, year, month, day;

insert into test.uniqueCETusers
select distinct 
	(case
	when instrumentName like "%AutoMEQ-SA-irb.jar" then "AutoMEQ"
	when instrumentName like "%AutoPIDS-SA.jar" then "AutoPIDS"
	else "other" end) as instrument,
	(case
	when timestamp > 20031028162400 then 5
	when timestamp > 20031021160000 then 4
	when timestamp > 20020729180000 then 3
	else 2.3 end) as AutoMEQversion,	
	(case
	when timestamp > 20031028160000 then 2.0
	when timestamp > 20031020113000 then 1.2
	when timestamp > 20031009100000 then 1.1
	when timestamp > 20031008150000 then 1.0
	else 0 end) as AutoPIDSversion,	
	year(timestamp) as year, 
	month(timestamp) as month, 
	dayofmonth(timestamp) as day, 
	dayofyear(timestamp) as dayofyear, 
	floor(timestamp / 1000000) as date, 
	sessionID, 
	max(currentStep) as lastStep,
	0 as AutoMEQ5_Demos,
	0 as AutoMEQ5_PIDS_A,
	0 as AutoMEQ5_PIDS_B,
	0 as AutoMEQ5_PIDS_C1A,
	0 as AutoMEQ5_PIDS_C1B,
	0 as AutoMEQ5_PIDS_C2A,
	0 as AutoMEQ5_PIDS_C2B,
	0 as AutoMEQ5_PIDS_C3A,
	0 as AutoMEQ5_PIDS_C3B,
	0 as AutoMEQ5_PIDS_C4A,
	0 as AutoMEQ5_PIDS_C4B,
	0 as AutoMEQ5_PIDS_C5A,
	0 as AutoMEQ5_PIDS_C5B,
	0 as AutoMEQ5_PIDS_C6A,
	0 as AutoMEQ5_PIDS_C6B,
	0 as AutoMEQ5_PIDS_D,
	0 as AutoMEQ5_PIDS_Scores,
	0 as AutoMEQ5_Finished,		
	0 as AutoMEQ4_Demos,
	0 as AutoMEQ4_PIDS_B,
	0 as AutoMEQ4_PIDS_C1A,
	0 as AutoMEQ4_PIDS_C1B,
	0 as AutoMEQ4_PIDS_C2A,
	0 as AutoMEQ4_PIDS_C2B,
	0 as AutoMEQ4_PIDS_C3A,
	0 as AutoMEQ4_PIDS_C3B,
	0 as AutoMEQ4_PIDS_C4A,
	0 as AutoMEQ4_PIDS_C4B,
	0 as AutoMEQ4_PIDS_C5A,
	0 as AutoMEQ4_PIDS_C5B,
	0 as AutoMEQ4_PIDS_C6A,
	0 as AutoMEQ4_PIDS_C6B,
	0 as AutoMEQ4_PIDS_D,
	0 as AutoMEQ4_PIDS_Scores,
	0 as AutoMEQ4_Finished,	
	max(if(currentStep=24,1,0)) as AutoMEQ3_Demos,
	max(if(currentStep>52,1,0)) as AutoMEQ3_Finished	
from dialogix2992.pageHits
group by sessionID
having lastStep > 2 and instrument <> "other"
order by instrument, year, month, day;

insert into test.uniqueCETusers
select distinct 
	(case
	when instrumentName like "%AutoMEQ-SA-irb.jar" then "AutoMEQ"
	when instrumentName like "%AutoPIDS-SA.jar" then "AutoPIDS"
	else "other" end) as instrument,
	(case
	when timestamp > 20031028162400 then 5
	when timestamp > 20031021160000 then 4
	when timestamp > 20020729180000 then 3
	else 2.3 end) as AutoMEQversion,	
	(case
	when timestamp > 20031028160000 then 2.0
	when timestamp > 20031020113000 then 1.2
	when timestamp > 20031009100000 then 1.1
	when timestamp > 20031008150000 then 1.0
	else 0 end) as AutoPIDSversion,
	year(timestamp) as year, 
	month(timestamp) as month, 
	dayofmonth(timestamp) as day, 
	dayofyear(timestamp) as dayofyear, 
	floor(timestamp / 1000000) as date, 
	sessionID, 
	max(currentStep) as lastStep,
	0 as AutoMEQ5_Demos,
	0 as AutoMEQ5_PIDS_A,
	0 as AutoMEQ5_PIDS_B,
	0 as AutoMEQ5_PIDS_C1A,
	0 as AutoMEQ5_PIDS_C1B,
	0 as AutoMEQ5_PIDS_C2A,
	0 as AutoMEQ5_PIDS_C2B,
	0 as AutoMEQ5_PIDS_C3A,
	0 as AutoMEQ5_PIDS_C3B,
	0 as AutoMEQ5_PIDS_C4A,
	0 as AutoMEQ5_PIDS_C4B,
	0 as AutoMEQ5_PIDS_C5A,
	0 as AutoMEQ5_PIDS_C5B,
	0 as AutoMEQ5_PIDS_C6A,
	0 as AutoMEQ5_PIDS_C6B,
	0 as AutoMEQ5_PIDS_D,
	0 as AutoMEQ5_PIDS_Scores,
	0 as AutoMEQ5_Finished,			
	0 as AutoMEQ4_Demos,
	0 as AutoMEQ4_PIDS_B,
	0 as AutoMEQ4_PIDS_C1A,
	0 as AutoMEQ4_PIDS_C1B,
	0 as AutoMEQ4_PIDS_C2A,
	0 as AutoMEQ4_PIDS_C2B,
	0 as AutoMEQ4_PIDS_C3A,
	0 as AutoMEQ4_PIDS_C3B,
	0 as AutoMEQ4_PIDS_C4A,
	0 as AutoMEQ4_PIDS_C4B,
	0 as AutoMEQ4_PIDS_C5A,
	0 as AutoMEQ4_PIDS_C5B,
	0 as AutoMEQ4_PIDS_C6A,
	0 as AutoMEQ4_PIDS_C6B,
	0 as AutoMEQ4_PIDS_D,
	0 as AutoMEQ4_PIDS_Scores,
	0 as AutoMEQ4_Finished,	
	max(if(currentStep=24,1,0)) as AutoMEQ3_Demos,
	max(if(currentStep>52,1,0)) as AutoMEQ3_Finished		
from dialogix_users.pagehits
group by sessionID
having lastStep > 2 and instrument <> "other"
order by instrument, year, month, day;

/* Collect comments */
drop table if exists  test.CETcomments;

create table test.CETcomments as
select distinct l.instrumentName, floor(l.timestamp / 1000000) as date, l.sessionID, r.value
from dialogix2994.pageHits l, dialogix2994.pageHitDetails r
where r.pageHitID_FK = l.pageHitID and r.param like "Feedback_us" and r.value <> "Type comments here." and r.value <> ""
order by date;

drop table if exists  test.CETlog;

create table test.CETlog as
	select distinct 
		instrument,
		(if (instrument like "AutoMEQ",AutoMEQversion,AutoPIDSversion)) as version,
		year,
		month,
		day,
		date,
		lastStep,
		(case 
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 then AutoMEQ5_Demos
			when instrument like "AutoMEQ" and AutoMEQversion = 4 then AutoMEQ4_Demos
			when instrument like "AutoMEQ" and AutoMEQversion = 3 then AutoMEQ3_Demos
			else 0 end) as MEQ_Demos,
		(case 
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 then AutoMEQ5_Finished
			when instrument like "AutoMEQ" and AutoMEQversion = 4 then AutoMEQ4_Finished
			when instrument like "AutoMEQ" and AutoMEQversion = 3 then AutoMEQ3_Finished
			else 0 end) as MEQ_Done,	
		(case  
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_Scores = 1 then "PIDS_Scores"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_D = 1 then "PIDS_D"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C6B = 1 then "PIDS_C6B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C6A = 1 then "PIDS_C6A"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C5B = 1 then "PIDS_C5B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C5A = 1 then "PIDS_C5A"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C4B = 1 then "PIDS_C4B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C4A = 1 then "PIDS_C4A"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C3B = 1 then "PIDS_C3B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C3A = 1 then "PIDS_C3A"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C2B = 1 then "PIDS_C2B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C2A = 1 then "PIDS_C2A"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C1B = 1 then "PIDS_C1B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and AutoMEQ5_PIDS_C1A = 1 then "PIDS_C1A"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and  AutoMEQ5_PIDS_B = 1 then "PIDS_B"
			when instrument like "AutoMEQ" and AutoMEQversion >= 5 and  AutoMEQ5_PIDS_A = 1 then "PIDS_A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_Scores = 1 then "PIDS_Scores"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_D = 1 then "PIDS_D"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C6B = 1 then "PIDS_C6B"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C6A = 1 then "PIDS_C6A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C5B = 1 then "PIDS_C5B"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C5A = 1 then "PIDS_C5A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C4B = 1 then "PIDS_C4B"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C4A = 1 then "PIDS_C4A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C3B = 1 then "PIDS_C3B"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C3A = 1 then "PIDS_C3A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C2B = 1 then "PIDS_C2B"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C2A = 1 then "PIDS_C2A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C1B = 1 then "PIDS_C1B"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and AutoMEQ4_PIDS_C1A = 1 then "PIDS_C1A"
			when instrument like "AutoMEQ" and AutoMEQversion = 4 and  AutoMEQ4_PIDS_B = 1 then "PIDS_B"
			else 0 end) as MEQ_PIDS,
		sessionID
	from test.uniqueCETusers
	order by year,month,day;	
	
/* Make summary report showing users by instrument and whether they are a subject */
drop table if exists  test.CETstats;

create table test.CETstats as
	select instrument, 
		version, 
		year,
		month,
		count(sessionID) as Started,
		sum(MEQ_Done) as Finished,
		sum(MEQ_Demos) as Subjects, 
		sum(if (MEQ_PIDS like "PIDS_Scores",1,0)) as DidPIDS,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1,1,0)) as SubjectsWhoFinished,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1 and MEQ_PIDS not like "PIDS_Scores",1,0)) as SubjectsWithMEQonly,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1 and MEQ_PIDS like "PIDS_Scores",1,0)) as SubjectsWithMEQandPIDS
	from test.CETlog
	group by instrument, version, year, month
	order by instrument, version, year, month;
	
drop table if exists  test.CETstatsDaily;
create table test.CETstatsDaily as
	select year,
		month,
		day,
		instrument, 
		version,
		count(sessionID) as Started,
		sum(MEQ_Done) as Finished,
		sum(MEQ_Demos) as Subjects, 
		sum(if (MEQ_PIDS like "PIDS_Scores",1,0)) as DidPIDS,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1,1,0)) as SubjectsWhoFinished,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1 and MEQ_PIDS not like "PIDS_Scores",1,0)) as SubjectsWithMEQonly,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1 and MEQ_PIDS like "PIDS_Scores",1,0)) as SubjectsWithMEQandPIDS
	from test.CETlog
	group by year, month, day, instrument, version
	order by year, month, day, instrument, version;
	
drop table if exists  test.CETstats_20051026;
create table test.CETstats_20051026 as
	select instrument, 
		version, 
		year,
		month,
		day,
		count(sessionID) as Started,
		sum(MEQ_Done) as Finished,
		sum(MEQ_Demos) as Subjects, 
		sum(if (MEQ_PIDS like "PIDS_Scores",1,0)) as DidPIDS,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1,1,0)) as SubjectsWhoFinished,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1 and MEQ_PIDS not like "PIDS_Scores",1,0)) as SubjectsWithMEQonly,
		sum(if(MEQ_Done = 1 and MEQ_Demos = 1 and MEQ_PIDS like "PIDS_Scores",1,0)) as SubjectsWithMEQandPIDS
	from test.CETlog
	where date = "20051026"
	group by instrument
	order by instrument;	
	
	
/* Also test use of AutoSIGH */
drop table if exists test.AutoSIGHstatus;
create table test.AutoSIGHstatus as
select distinct 
	instrumentName,
	workingFile,
	year(timestamp) as year, 
	month(timestamp) as month, 
	dayofmonth(timestamp) as day, 
	dayofyear(timestamp) as dayofyear, 
	max(currentStep) as lastStep,
	max(displayCount) as numSteps
from dialogix2994.pageHits
where instrumentName like '%AutoSIGH-rev-04-10.jar'
group by workingFile
order by dayofyear;

drop table if exists test.AutoSIGHcomments;
create table test.AutoSIGHcomments as
select distinct l.instrumentName, floor(l.timestamp / 1000000) as date, l.sessionID, r.value
from dialogix2994.pageHits l, dialogix2994.pageHitDetails r
where l.instrumentName like '%AutoSIGH-rev-04-10.jar' and r.pageHitID_FK = l.pageHitID and r.param like "Feedback_us" and r.value <> "Type comments here." and r.value <> ""
order by instrumentName, date;

/* Check status of Wave6 and 7 */
drop table if exists test.CICstatus;
create table test.CICstatus as
select distinct 
	instrumentName,
	workingFile,
	year(timestamp) as year, 
	month(timestamp) as month, 
	dayofmonth(timestamp) as day, 
	dayofyear(timestamp) as dayofyear, 
	max(currentStep) as lastStep,
	max(displayCount) as numSteps
from dialogix2994.pageHits
where instrumentName like '%ave%'
group by instrumentName, workingFile
order by instrumentName, year DESC, dayofyear DESC;
