%let helpers = C:\data\cet-irb5\analysis\AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb);

%let cet7_lib = C:\data\cet-2005-04\;

%let cet3_lib = C:\data\cet7\analysis\AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb);
%let cet4_lib = C:\data\cet7\analysis\AutoMEQ-SA-v4.0-(AutoMEQ-SA-irb);
%let cet5_lib = C:\data\cet7\analysis\AutoMEQ-SA-v5.0-(AutoMEQ-SA-irb);


libname helpers "&helpers";
libname cet7 "&cet7_lib";

libname cet3 "&cet3_lib";
libname cet4 "&cet4_lib";
libname cet5 "&cet5_lib";


%let cet7a_lib = C:\data\cet-2005-04\new;
libname cet7a "&cet7a_lib";


/* Also need to load format statements from AutoMEQ5 */

options compress=NO;

/* %include "&cet7_lib\deformat_automeq.sas"; */

/* %include "&cet5_lib\automeq_formats.sas"; */

/* 4/13/2005 - Inserted for Automeq7 */
data cet7a.automeq_all; set cet7.automeq3 cet7.automeq4 cet7.automeq5all cet7a.automeq7a;
run;
/**/


proc format;
	value phasef   
		0='morning'
		1='intermediate'
		2='evening'
		;
	
	value eyetypef
		0='light'
		1='medium'
		2='dark'
	;
	
	value seasonf
		1 = 'Winter'
		2 = 'Summer'
	;
	
	value latbinf
		0 = .
		1 = 'North'
		2 = 'South'
	;
	
	value sexf
		0 = 'male'
		1 = 'female'
		-1 = 'sex?'
	;
	
	value eyef
		-1 = 'eye color?'
		0 = 'blue'
		1 = 'gray'
		2 = 'green'
		3 = 'hazel'
		4 = 'brown'
		5 = 'black'
		6 = 'albino'
	;		
	
	value losf
		1 = '>= 2 weeks'
		0 = '< 2 weeks'
		-1 = 'los?'
	;
	
	value q19f
		0 = 'definite evening'
		2 = 'moderate evening'
		4 = 'moderate morning'
		6 = 'definite morning'
	;
	
	value $fulethf
		'White not of Hispanic Origin'		= 1
		'Black not of Hispanic Origin'		= 2
		'Hispanic'							= 3
		'Asian or Pacific Islander'			= 4
		'American Indian or Alaskan Native'	= 5
		'Other or Unknown'					= 6
		.									= 7
		OTHER								= 6
	;
		
	value ethf
		1 = 'White not of Hispanic Origin'
		2 = 'Black not of Hispanic Origin'
		3 = 'Hispanic'
		4 = 'Asian or Pacific Islander'
		5 = 'American Indian or Alaskan Native'
		6 = 'Other or Unknown'
		7 = 'Missing'
	;
run;


/* Import times mapping from txt files */
PROC IMPORT OUT=work.times 
            DATAFILE= "&helpers\times.xls"
            DBMS=EXCEL2000 REPLACE;
     GETNAMES=YES;
RUN;

data work.times; set work.times;
	format time_val time18.;
	time_val = timepart(timeval);
	/* time_num is floating point equivalent of time */
	time_num = hour(time_val) + minute(time_val) / 60;
run;

/* Import States */
PROC IMPORT OUT=work.States 
            DATAFILE= "&helpers\states.xls" 
            DBMS=EXCEL2000 REPLACE;
     GETNAMES=YES;
RUN;

/* Import zipcode information */
proc sql;
	create table zips as
	select distinct
		zipcode, 
		statecode, latitude, longitude, GMTOffset, DST
	from helpers.zipcodes
	order by zipcode;
	
/* convert the character value of zip code to a number */
data zips; set zips;
	zipnum = input(zipcode,best12.);
run;

/* backup this table */
data cet7a.zips; set zips;
run;

proc sql;
	create table automeq as
	select distinct l.*, r.*
	 from cet7a.automeq_all l left join work.states r
	 on l.d_state = r.stateid
	 order by startdat;
	 
data automeq; set automeq;
	d_awake_ = left(d_awake_workday);
	rename d_awake_workday = wakewrk_str;
	d_awake_nonworkday = left(d_awake_nonworkday);
	rename d_awake_nonworkday = wakenwk_str;
	
	d_sleep_workday = left(d_sleep_workday);
	rename d_sleep_workday = sleepwrk_str;
	d_sleep_nonworkday = left(d_sleep_nonworkday);
	rename d_sleep_nonworkday = sleepnwk_str;
	
	rename LIGHTS_ON_time = wakemeq_str;
	rename SL_ONSET_time = sleepmeq_str;
	
	rename d_abnl_sleep = abnlslep;
	rename d_country = country;
	rename d_working_days = workdays;
	rename Feedback_us = comments;
run;

proc sql;	
	create table automeq as
	select distinct l.*, r.*
	from automeq l left join work.zips r
	on r.zipnum = l.d_zip
	;
	
data automeq; set automeq;
	if country = 'Canada'  then latabout = 47;

	if (stateabr eq statecode or (statecode eq '' and d_zip = 0)) then okzip = 1; else okzip = 0;
	if (stateabr eq '') then lat_good = latabout;
	else if (okzip = 1) then lat_good = latitude;
	else lat_good = latabout;
run;

proc sql;	 
	create table automeq as
	select distinct l.*, r.time_num as wakewrk
	from automeq l left join work.times r
	on l.wakewrk_str = r.timename;
	
	create table automeq as
	select distinct l.*, r.time_num as wakenwk
	from automeq l left join work.times r
	on l.wakenwk_str = r.timename;
	
	create table automeq as
	select distinct l.*, r.time_num as wakemeq
	from automeq l left join work.times r
	on l.wakemeq_str = r.timename;
	
	create table automeq as
	select distinct l.*, r.time_num as sleepwrk
	from automeq l left join work.times r
	on l.sleepwrk_str = r.timename;
	
	create table automeq as
	select distinct l.*, r.time_num as sleepnwk
	from automeq l left join work.times r
	on l.sleepnwk_str = r.timename;
	
	create table automeq as
	select distinct l.*, r.time_num as sleepmeq
	from automeq l left join work.times r
	on l.sleepmeq_str = r.timename;	
quit;
				
	 
data automeq; set automeq;
	/* calculate start time (when the subject completed the instrument */
	startabs = int(substr(uniqueid,12,2)) + int(substr(uniqueid,15,2)) / 60;
	
	/* compute actual start time, based upon daylight savings time */
	if (startdat >= mdy(4,7,2002) and startdat < mdy(10,27,2002)) then wasDST = 1;
	else if (startdat >= mdy(10,26,2002) and startdat < mdy(4,6,2003)) then wasDST = 0;
	else if (startdat >= mdy(4,6,2003) and startdat < mdy(10,26,2003)) then wasDST = 1;
	else if (startdat >= mdy(10,26,2003) and startdat < mdy(4,4,3004)) then wasDST = 0;
	else if (startdat >= mdy(4,4,2004) and startdat < mdy(10,31,2004)) then wasDST = 1;	
	else if (startdat >= mdy(10,31,2004) and startdat < mdy(4,3,2005)) then wasDST = 0;
	else if (startdat >= mdy(4,3,2005) and startdat < mdy(10,30,2005)) then wasDST = 1;
	else if (startdat >= mdy(10,30,2005) and startdat < mdy(4,2,2006)) then wasDST = 0;
	else if (startdat >= mdy(4,2,2006)) then wasDST = 1;
	
	format zip_gis $ 5.;
	zip_gis = put(d_zip,z5.);
		
	if (DST eq "Y") then localDST = 1; else localDST = 0;
	
	/* adjust for daylight savings time, using knowledge that server is based in EST */
	startloc = startabs + GMTOffset + (5 - wasDST) - localDST;
	if (startloc < 0.) then startloc = startloc + 24.;

	if (feedback0 = . and q19  ne .) then complete = 1; else complete = 0;
	if (workdays >= 0) then joined = 1; else joined = 0;

	length eth_white eth_black eth_hispanic eth_asian eth_indian eth_other $ 35;
	length ethnicity $ 70;
	if (d_age < 21) then age_cat = 'Child'; else age_cat = 'Adult ';
	if (d_eth_wh = 1 and d_eth_his ^= 1) then eth_white = 'White not of Hispanic Origin ';
	if (d_eth_bl = 1 and d_eth_his ^= 1) then eth_black = 'Black not of Hispanic Origin ';
	if (d_eth_his = 1) then eth_hispanic = 'Hispanic ';
	if (d_eth_as = 1 or d_eth_hw = 1) then eth_asian = 'Asian or Pacific Islander ';
	if (d_eth_ai = 1) then eth_indian = 'American Indian or Alaskan Native ';
	if (eth_white = '' and eth_black = '' and eth_hispanic = '' and eth_asian = '' and eth_indian = '') then eth_other = 'Other or Unknown';

	ethnicity = compbl(eth_white || eth_black || eth_hispanic || eth_asian || eth_indian || eth_other);
	if (d_eth_wh > 33333 or d_eth_bl > 33333 or d_eth_his > 33333 or d_eth_as > 33333 or d_eth_ai > 33333) then ethnicity = '';
	
	/* Now determine final ethnicity for IRB */
	ethnicity = trim(left(ethnicity));
	format irb_ethnicity ethf.;

	irb_ethnicity = put(ethnicity,$fulethf.);	
	

	format eye_type eyetypef.;
	if (d_eye in (0,1,6)) then eye_type = 0;
	if (d_eye in (4,5)) then eye_type = 2;
	if (d_eye in (2,3)) then eye_type = 1;

	month = int(put(startdat,month.));
	
	format circphas phasef.;

	if (meq_type in ('definite morning','moderate morning')) then circphas = 0;
	else if (meq_type in ('definite evening', 'moderate evening')) then circphas = 2;
	else if (meq_type in ('intermediate')) then circphas = 1;
	else circphas = .;
	
	format season seasonf.;
	if (month >= 11 or month <= 2) then season = 1;
	else if (month >= 4 and month <= 9) then season = 2;
	else season = .;
		
	format lat_bin latbinf.;
	lat_bin = 0;
	if (lat_good >= 40) then lat_bin = 1;
	if (lat_good <= 37) then lat_bin = 2;
	
	if (lat_good >= 30 and lat_good <= 35) then latbinmd = 32.5;
	if (lat_good > 35 and lat_good <= 40) then latbinmd = 37.5;
	if (lat_good > 40 and lat_good <= 45) then latbinmd = 42.5;
	if (lat_good > 45 and lat_good <= 50) then latbinmd = 47.5;
	
	wakemeq = wakemeq + 24.;
	if (sleepmeq < 15.) then sleepmeq = sleepmeq + 24.;
	sdurmeq = (wakemeq - sleepmeq);
	smidmeq = (sleepmeq + (.5 * sdurmeq));
	
	if (wakewrk < 15.) then wakewrk = wakewrk + 24.;
	if (sleepwrk < 15.) then sleepwrk = sleepwrk + 24.;
	sdurwrk = (wakewrk - sleepwrk);
	if (sdurwrk <= 0.) then sdurwrk = .;	/* mark as non-missing if clearly an error */
	smidwrk = (sleepwrk + (.5 * sdurwrk));
	
	if (wakenwk < 15.) then wakenwk = wakenwk + 24.;
	if (sleepnwk < 15.) then sleepnwk = sleepnwk + 24.;
	sdurnwk = (wakenwk - sleepnwk);
	if (sdurnwk <= 0.) then sdurnwk = .;	/* mark as missing if clearly an error */
	smidnwk = (sleepnwk + (.5 * sdurnwk));	
	
	if (workdays = 0) then do;
		sduravg = sdurnwk;
		smidavg = smidnwk;
	end;
	else if (workdays > 0 and workdays <= 7) then do;
		sduravg = (workdays * sdurwrk + (7-workdays) * sdurnwk) / 7;
		smidavg = (workdays * smidwrk + (7-workdays) * smidnwk) / 7;	
	end;
	else do;
		sduravg = .;
		smidavg = .;
	end;
	
	format d_sex sexf.;
	format d_eye eyef.;
	format d_los losf.;
	format q19 q19f.;
	
	/* flag values with excessive sleep patterns */
	if (sdurwrk >= 15. or 
		sdurnwk >= 15.) then longslep = 1; else longslep = 0;
		
/* Additional cleaning for PIDS */
	if (d_height_meters ^= . and (d_height_meters < .5 or d_height_meters > 2.5)) then do;
		d_height_meters = .;
		d_BMI = .;
	end;
	
	if (d_weight_pounds ^= . and (d_weight_pounds < 50 or d_weight_pounds > 500)) then do;
		d_weight_pounds = .;
		d_BMI = .;
	end;
	
	if (d_weight_kg ^= . and (d_weight_kg < 20 or d_weight_kg > 200)) then do;
		d_weight_kg = .;
		d_BMI = .;
	end;
	
	d_BMI_int = floor(d_BMI);
	
	/* flag to indicate that there are missing values */
	if ((d_age > 100 or d_age < 14) or
		(meqstd > 1.5) or
		(lat_good = . or lat_good > 50 or lat_good < 30) or
		(workdays < 0) or
		(wakenwk = . or sleepnwk = .) or
		(workdays > 0 and (wakewrk = . or sleepwrk = .)) or
		(sduravg = . or smidavg = .) or
		(statenam eq 'Hawaii') or
		(meq = . or meq > 100) or
		(d_sex = -1 or d_sex > 2) or
		(eye_type = .) or
		(abnlslep = 1) or
		(longslep = 1) or
		(joined ^= 1) or
		(complete ^= 1) or
		(d_who ^= 1) or
		(okzip = 0) or 
		(d_los ^= 1) or
		(workdays > 0 and (sdurwrk < 4 or sdurwrk > 12)) or
		(sdurnwk < 4 or sdurnwk > 12) or
		(not (country = 'United States' or country = 'Canada')) 
	)
		then keep = 0;
	else keep = 1;	

	/* Attempt to determine the scores for Part 3:
		Winter Depression if score of >= 4 on A for 3-5 consecutive months starting from Sept to January:
		Also >= 4 on part B for 3-5 consecutive months starting from March - June
	*/
	
	/* A scores -- shift to start with September, since that is when the season starts */
	array Ascores(13) CscoresA1-CscoresA13;
	Ascores(1) = CscrJanA;
	Ascores(2) = CscrFebA;
	Ascores(3) = CscrMarA;
	Ascores(4) = CscrAprA;
	Ascores(5) = CscrMayA;
	Ascores(6) = CscrJunA;
	Ascores(7) = CscrJulA;
	Ascores(8) = CscrAugA;
	Ascores(9) = CscrSepA;
	Ascores(10) = CscrOctA;
	Ascores(11) = CscrNovA;
	Ascores(12) = CscrDecA;
	Ascores(13) = CscrNonA;
	
	/* B scores -- shift to start with March, since that is when the season starts */
	array Bscores(13) CscoresB1-CscoresB13;
	Bscores(1) = CscrJanB;
	Bscores(2) = CscrFebB;
	Bscores(3) = CscrMarB;
	Bscores(4) = CscrAprB;
	Bscores(5) = CscrMayB;
	Bscores(6) = CscrJunB;
	Bscores(7) = CscrJulB;
	Bscores(8) = CscrAugB;
	Bscores(9) = CscrSepB;
	Bscores(10) = CscrOctB;
	Bscores(11) = CscrNovB;
	Bscores(12) = CscrDecB;
	Bscores(13) = CscrNonB;
	
	/* get rid of old names for these *
	drop CscrJanA CscrFebA CscrMarA CscrAprA CscrMayA CscrJunA CscrJulA CscrAugA CscrSepA CscrOctA CscrNovA CscrDecA CscrNonA;	
	drop CscrJanB CscrFebB CscrMarB CscrAprB CscrMayB CscrJunB CscrJulB CscrAugB CscrSepB CscrOctB CscrNovB CscrDecB CscrNonB;	
	*/
	
	if ((Ascores(9) >= 4 and Ascores(10) >= 4 and Ascores(11) >= 4) or 
		(Ascores(10) >= 4 and Ascores(11) >= 4 and Ascores(12) >= 4) or 
		(Ascores(11) >= 4 and Ascores(12) >= 4 and Ascores(1) >= 4) or 
		(Ascores(12) >= 4 and Ascores(1) >= 4 and Ascores(2) >= 4) or 
		(Ascores(1) >= 4 and Ascores(2) >= 4 and Ascores(3) >= 4)) then do;
		C_WinterBad = 1;
	end;
	
	if ((Bscores(9) >= 4 and Bscores(10) >= 4 and Bscores(11) >= 4) or 
		(Bscores(10) >= 4 and Bscores(11) >= 4 and Bscores(12) >= 4) or 
		(Bscores(11) >= 4 and Bscores(12) >= 4 and Bscores(1) >= 4) or 
		(Bscores(12) >= 4 and Bscores(1) >= 4 and Bscores(2) >= 4) or 
		(Bscores(1) >= 4 and Bscores(2) >= 4 and Bscores(3) >= 4)) then do;
		C_WinterGood = 1;
	end;
	
	if ((Ascores(3) >= 4 and Ascores(4) >= 4 and Ascores(5) >= 4) or 
		(Ascores(4) >= 4 and Ascores(5) >= 4 and Ascores(6) >= 4) or 
		(Ascores(5) >= 4 and Ascores(6) >= 4 and Ascores(7) >= 4) or 
		(Ascores(6) >= 4 and Ascores(7) >= 4 and Ascores(8) >= 4)) then do;
		C_SummerBad = 1;
	end;
	
	if ((Bscores(3) >= 4 and Bscores(4) >= 4 and Bscores(5) >= 4) or 
		(Bscores(4) >= 4 and Bscores(5) >= 4 and Bscores(6) >= 4) or 
		(Bscores(5) >= 4 and Bscores(6) >= 4 and Bscores(7) >= 4) or 
		(Bscores(6) >= 4 and Bscores(7) >= 4 and Bscores(8) >= 4)) then do;
		C_SummerGood = 1;
	end;	
	
	/* Was PIDS finished? */
	if (askPIDS = 1 and (Bscore < 7 or (Bscore>=7 and C6_Err_Num=0))) then PIDSdone = 1;
	
	/* Were these from the week of the solstices? */
	if (mdy(4,7,2005) < startdat < mdy(6,5,2005)) then solstice = 'summer';
	if (mdy(4,7,2004) < startdat < mdy(6,5,2004)) then solstice = 'summer';
	if (mdy(4,7,2003) < startdat < mdy(6,5,2003)) then solstice = 'summer';
	if (mdy(4,7,2002) < startdat < mdy(6,5,2002)) then solstice = 'summer';
	if (mdy(4,7,2001) < startdat < mdy(6,5,2001)) then solstice = 'summer';

	if (mdy(12,7,2005) < startdat < mdy(1,4,2006)) then solstice = 'winter';
	if (mdy(12,7,2004) < startdat < mdy(1,4,2005)) then solstice = 'winter';
	if (mdy(12,7,2003) < startdat < mdy(1,4,2004)) then solstice = 'winter';
	if (mdy(12,7,2002) < startdat < mdy(1,4,2003)) then solstice = 'winter';
	if (mdy(12,7,2001) < startdat < mdy(1,4,2002)) then solstice = 'winter';
	
	/* Since three in a row is hard for seasonality, just pick several bad months */
	winterbad = ((CscoresA10 >= 4) + (CscoresA11 >= 4) + (CscoresA12 >= 4) + (CscoresA1 >= 4) + (CscoresA2 >= 4));
	summerbad = ((CscoresA5 >= 4) + (CscoresA6 >= 4) + (CscoresA7 >= 4) + (CscoresA8 >= 4) + (CscoresA9 >= 4));
	
	/* Flag candidates for SAD vs MDD analysis */
	if (PIDSdone = 1 and Bscore ne . and MDcrit3 ne . and keep=1) then useForSADvsMDDanalysis = 1;
	if (useForSADvsMDDanalysis = 1) then do;
		if (winterbad >= 2 and summerbad = 0) then hasWinterSeasonality = 1; 
		else hasWinterSeasonality = 0;
	end;
	
	/* Bin the latitudes to get counts per bin vs. #s in useForSADvsMDDanalysis */
	latbin_1 = round(lat_good,1);
	latbin_2 = round(lat_good,2);
	latbin_2_5 = round(lat_good,2.5);
	latbin_5 = round(lat_good,5);

	
	/* Minor depression diagnosis */
	MajorDepression_dx = MDcrit3;
	
	if (PIDSdone = 1) then do;
		if (Ascore >= 2 and Ascore <= 4 and (A4 = 1 or A5 = 1) and (A9 = 0)) then MinorDepression_dx = 1; 
		else MinorDepression_dx = 0;
	end;
run;

data subsetForSADvsMDD; set automeq;
	where useForSADvsMDDanalysis = 1;
run;

proc sql;
	create table latbin_1 as 
	select distinct latbin_1, count(*) as NumCasesAtLatbin_1, sum(MajorDepression_dx) as NumMajorDDAtLatbin_1, sum(MinorDepression_dx) as NumMinorDDAtLatbin_1,
		(sum(MajorDepression_dx) / count(*)) as PctMajorDDAtLatBin_1, (sum(MinorDepression_dx) / count(*)) as PctMinorDDAtLatBin_1
	from subsetForSADvsMDD
	group by latbin_1
	order by latbin_1;
quit;

proc sql;
	create table latbin_2 as 
	select distinct latbin_2, count(*) as NumCasesAtLatbin_2, sum(MajorDepression_dx) as NumMajorDDAtLatbin_2, sum(MinorDepression_dx) as NumMinorDDAtLatbin_2,
		(sum(MajorDepression_dx) / count(*)) as PctMajorDDAtLatBin_2, (sum(MinorDepression_dx) / count(*)) as PctMinorDDAtLatBin_2
	from subsetForSADvsMDD
	group by latbin_2
	order by latbin_2;
quit;

proc sql;
	create table latbin_2_5 as 
	select distinct latbin_2_5, count(*) as NumCasesAtLatbin_2_5, sum(MajorDepression_dx) as NumMajorDDAtLatbin_2_5, sum(MinorDepression_dx) as NumMinorDDAtLatbin_2_5,
		(sum(MajorDepression_dx) / count(*)) as PctMajorDDAtLatBin_2_5, (sum(MinorDepression_dx) / count(*)) as PctMinorDDAtLatBin_2_5
	from subsetForSADvsMDD
	group by latbin_2_5
	order by latbin_2_5;
quit;

proc sql;
	create table latbin_5 as 
	select distinct latbin_5, count(*) as NumCasesAtLatbin_5, sum(MajorDepression_dx) as NumMajorDDAtLatbin_5, sum(MinorDepression_dx) as NumMinorDDAtLatbin_5,
		(sum(MajorDepression_dx) / count(*)) as PctMajorDDAtLatBin_5, (sum(MinorDepression_dx) / count(*)) as PctMinorDDAtLatBin_5
	from subsetForSADvsMDD
	group by latbin_5
	order by latbin_5;
quit;

/* Re-merge with Bscore data */
proc sql;
	create table automeq2 as
	select l.*, r.NumCasesAtLatbin_1, r.NumMajorDDAtLatbin_1, r.NumMinorDDAtLatbin_1, r.PctMajorDDAtLatBin_1, r.PctMinorDDAtLatBin_1
	from subsetForSADvsMDD l, latbin_1 r
	where l.latbin_1 = r.latbin_1;
quit;

proc sql;	
	create table automeq2 as
	select l.*, r.NumCasesAtLatbin_2, r.NumMajorDDAtLatbin_2, r.NumMinorDDAtLatbin_2, r.PctMajorDDAtLatBin_2, r.PctMinorDDAtLatBin_2
	from automeq2 l, latbin_2 r
	where l.latbin_2 = r.latbin_2;	
quit;
	
proc sql;	
	create table automeq2 as
	select l.*, r.NumCasesAtLatbin_2_5, r.NumMajorDDAtLatbin_2_5, r.NumMinorDDAtLatbin_2_5, r.PctMajorDDAtLatBin_2_5, r.PctMinorDDAtLatBin_2_5
	from automeq2 l, latbin_2_5 r
	where l.latbin_2_5 = r.latbin_2_5;	
quit;

proc sql;	
	create table automeq2 as
	select l.*, r.NumCasesAtLatbin_5, r.NumMajorDDAtLatbin_5, r.NumMinorDDAtLatbin_5, r.PctMajorDDAtLatBin_5, r.PctMinorDDAtLatBin_5
	from automeq2 l, latbin_5 r
	where l.latbin_5 = r.latbin_5;			
quit;

/* Compute % total (Major + Minor) at each latitute binning */

data automeq2; set automeq2;
	NumMajorMinorAtLatBin_1 = (NumMajorDDAtLatbin_1 + NumMinorDDAtLatbin_1);
	PctMajorMinorAtLatBin_1 = NumMajorMinorAtLatBin_1 / NumCasesAtLatbin_1;

	NumMajorMinorAtLatBin_2 = (NumMajorDDAtLatbin_2 + NumMinorDDAtLatbin_2);
	PctMajorMinorAtLatBin_2 = NumMajorMinorAtLatBin_2 / NumCasesAtLatbin_2;
	
	NumMajorMinorAtLatBin_2_5 = (NumMajorDDAtLatbin_2_5 + NumMinorDDAtLatbin_2_5);
	PctMajorMinorAtLatBin_2_5 = NumMajorMinorAtLatBin_2_5 / NumCasesAtLatbin_2_5;
	
	NumMajorMinorAtLatBin_5 = (NumMajorDDAtLatbin_5 + NumMinorDDAtLatbin_5);
	PctMajorMinorAtLatBin_5 = NumMajorMinorAtLatBin_5 / NumCasesAtLatbin_5;
run;

data automeq0; set automeq;
	where useForSADvsMDDanalysis ne 1;
run;

data automeq2; set automeq0 automeq2;
run;

/* FIXME:  Re-merge with data that lacked latitude? */
	

/*
proc freq data=automeq;
	table age_cat;
	table d_age;
	table country;
run;
*/

/* make a backup copy of the datafile *
data work.automeq; set automeq;
run;
*/

/* make a data set of only those values we want to keep */
proc sql;
	create table work.keepers as
	select distinct
		uniqueid,
		joined, complete, d_who, abnlslep,
		startdat, month, season,
		startabs, startloc,wasDST,GMToffset,
		d_sex, d_age, age_cat,
		d_eye, eye_type, ethnicity, irb_ethnicity,
		country, statenam, stateabr, statecode, d_los,
		d_zip, zip_gis, okzip, latitude, latabout, lat_good, lat_bin, latbinmd, longitude,
		workdays, 
		circphas, meq_type, meq, meqstd, 		
		sleepmeq, wakemeq, sdurmeq, smidmeq,
		sleepwrk, wakewrk, sdurwrk, smidwrk,
		sleepnwk, wakenwk, sdurnwk, smidnwk, 
		sduravg, smidavg,
		longslep,
		q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19,
		d_sleep_darkroom, d_wake_withlight, d_outsidelight_work, d_outsidelight_nonwork,
		d_BMI, d_BMI_int,
		askPIDS, PIDSdone,
		A1, A2, A3, A4, A5, A6, A7, A8, A9, Ascore,
		B1, B2, B3, B4, B5, B6, B7, Bscore,
		CscoresA1, CscoresA2, CscoresA3, CscoresA4, CscoresA5, CscoresA6, CscoresA7, CscoresA8, CscoresA9, CscoresA10, CscoresA11, CscoresA12, CscoresA13,
		CscoresB1, CscoresB2, CscoresB3, CscoresB4, CscoresB5, CscoresB6, CscoresB7, CscoresB8, CscoresB9, CscoresB10, CscoresB11, CscoresB12, CscoresB13,
		D1, D2, D3, D4, D5, D6, D7, D8, D9, Dscore,
		MDcrit1, MDcrit2, MDcrit3, MDcrit4, MDcrit5, MDcrit6,
		C_WinterBad, C_WinterGood, C_SummerBad, C_SummerGood,
		solstice, winterbad, summerbad,
		useForSADvsMDDanalysis, hasWinterSeasonality,
		latbin_1, latbin_2, latbin_2_5, latbin_5,
		MajorDepression_dx, MinorDepression_dx,
		NumCasesAtLatbin_1, NumMajorDDAtLatbin_1, NumMinorDDAtLatbin_1, PctMajorDDAtLatBin_1, PctMinorDDAtLatBin_1, NumMajorMinorAtLatBin_1, PctMajorMinorAtLatBin_1,
		NumCasesAtLatbin_2, NumMajorDDAtLatbin_2, NumMinorDDAtLatbin_2, PctMajorDDAtLatBin_2, PctMinorDDAtLatBin_2, NumMajorMinorAtLatBin_2, PctMajorMinorAtLatBin_2,
		NumCasesAtLatbin_2_5, NumMajorDDAtLatbin_2_5, NumMinorDDAtLatbin_2_5, PctMajorDDAtLatBin_2_5, PctMinorDDAtLatBin_2_5, NumMajorMinorAtLatBin_2_5, PctMajorMinorAtLatBin_2_5,
		NumCasesAtLatbin_5, NumMajorDDAtLatbin_5, NumMinorDDAtLatbin_5, PctMajorDDAtLatBin_5, PctMinorDDAtLatBin_5, NumMajorMinorAtLatBin_5, PctMajorMinorAtLatBin_5
	from automeq2
	where keep = 1;
	;
quit;

/* Add analyses used for detecting cases of SANS */
data SADvsMD; set keepers;
	where useForSADvsMDDanalysis = 1;
	
	if (d_age > 15 and d_age < 26) then youngadult=1; else youngadult=0;
	if (month >= 11 or month <= 2) then iswinter=1; else iswinter=0;

	if (PIDSdone = 1 and Dscore >= 6 and 
		hasWinterSeasonality = 1 and MajorDepression_dx ne 1 and MinorDepression_dx ne 1) 
		then SANS = 1; else SANS = 0;

	if (hasWinterSeasonality = 1) then do;
		if (MajorDepression_dx = 1) then dx_cat = 'MDD';
		else if (MinorDepression_Dx = 1) then dx_cat = 'MIN';
		else if (SANS = 1) then dx_cat = 'SANS';
		else dx_cat = 'SANS';
	end;
	else dx_cat = 'OTHER';

	if (latbin_2_5 <= 32.5) then latbin_2_5b = 32.5;
	else if (latbin_2_5 >= 47.5) then latbin_2_5b = 47.5;
	else latbin_2_5b = latbin_2_5;

	if (latbin_2_5 <= 32.5) then latbin_2_5C = 32.5;
	else if (latbin_2_5 >= 45) then latbin_2_5C = 45;
	else latbin_2_5C = latbin_2_5;

	if (d_age < 25) then age_bin = 1;
	else if (d_age < 35) then age_bin = 2;
	else if (d_age < 45) then age_bin = 3;
	else if (d_age < 55) then age_bin = 4;
	else age_bin = 5;	
run;

/*
proc freq data=work.keepers;
	table ethnicity;
	table eye_type;
	table month;
	table meq_type;
	table circphas;
	table season;
	table lat_bin;
	table latbinmd;	* midpoint of second latitude bin
	
	table sleepmeq;
	table smidmeq;
	table wakemeq;
	table sdurmeq;
	
	table sleepwrk;
	table smidwrk;
	table wakewrk;
	table sdurwrk;
	
	table sleepnwk;
	table smidnwk;
	table wakenwk;
	table sdurnwk;		
	
	table sduravg;
	table smidavg;
	table workdays;
run;
*/

/*
proc sql;
	create table latcomp as
	select country, statenam, stateabr, statecode, d_zip, okzip, latabout, latitude, lat_good
	from work.keepers
	order by okzip;
*/
	
PROC EXPORT DATA= work.keepers 
            OUTFILE= "&cet7a_lib\Automeq.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

PROC EXPORT DATA= work.SADvsMD 
            OUTFILE= "&cet7a_lib\SADvsMD.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

/* Backup up data */
data cet7a.automeq; set automeq; run;

data cet7a.keepers; set keepers; run;

data cet7a.SADvsMD; set SADvsMD; run;


/* Why no keepers? -- COMPLETE = 0 for all -- why? *
proc freq data=automeq;
	table d_age;
	table meqstd;
	table lat_good;
	table workdays;
	table wakenwk;
	table sleepnwk;
	table sduravg;
	table smidavg;
	table statenam;
	table meq;
	table d_sex;
	table season;
	table eye_type;
	table abnlslep;
	table longslep;
	table joined;
	table complete;
	table d_who;
	table age_cat;
	table okzip;
	table d_los;
	table sdurwrk;
	table country;
run;
*/

/* 
data automeq; set cet7a.keepers;
	if (mdy(4,7,2003) < startdat < mdy(6,5,2003)) then solstice = 'summer';
	if (mdy(4,7,2002) < startdat < mdy(6,5,2002)) then solstice = 'summer';
	if (mdy(4,7,2001) < startdat < mdy(6,5,2001)) then solstice = 'summer';

	if (mdy(12,7,2003) < startdat < mdy(1,4,2004)) then solstice = 'winter';
	if (mdy(12,7,2002) < startdat < mdy(1,4,2003)) then solstice = 'winter';
	if (mdy(12,7,2001) < startdat < mdy(1,4,2002)) then solstice = 'winter';
run;
*/

/*
data nonwinterworse; set cet7a.keepers;
	winterbad = ((CscoresA10 >= 4) + (CscoresA11 >= 4) + (CscoresA12 >= 4) + (CscoresA1 >= 4) + (CscoresA2 >= 4));
	summergood = ((CscoresB5 >= 4) + (CscoresB6 >= 4) + (CscoresB7 >= 4) + (CscoresB8 >= 4) + (CscoresB9 >= 4));
run;
*/

/*
data SADvsMD; set nonwinterworse;
	where Bscore ne . and MDcrit3 ne . and 
run;

proc sort data=SADvsMD; by Bscore; 

proc freq data=SADvsMD;
	by Bscore;
	table MDcrit3;
run;

data nonwinterworse; set cet7a.keepers;
	winterbad = ((CscoresA10 >= 4) + (CscoresA11 >= 4) + (CscoresA12 >= 4) + (CscoresA1 >= 4) + (CscoresA2 >= 4));
	summerbad = ((CscoresA5 >= 4) + (CscoresA6 >= 4) + (CscoresA7 >= 4) + (CscoresA8 >= 4) + (CscoresA9 >= 4));
run;

proc freq data=nonwinterworse; 
	tables winterbad;
	tables summerbad;
run;

data SADvsMD; set nonwinterworse;
	where Bscore ne . and MDcrit3 ne . and winterbad >= 2 and summerbad = 0;
run;

proc sort data=SADvsMD2; by Bscore; 

proc freq data=SADvsMD;
	by Bscore;
	table MDcrit3;
run;

proc freq data=cet7a.keepers; 
	where C_SummerBad ne 1 and C_WinterBad = 1;
	tables MDcrit3;
run;

proc freq data=SADvsMD;
	where winterbad >=2 and summerbad = 0;
	tables MDcrit3;
run;
*/

/*

proc freq data=SADvsMD;
	where Bscore >= 16;
	tables lat_bin;
run;

proc freq data=cet7a.keepers;
	tables lat_bin;
run;
*/

/* Statistical Analyses *
options linesize=120 pagesize=MAX;

proc freq data=sadvsmd;
	tables BScore * MajorDepression_dx;
	tables Bscore * MinorDepression_dx;
run;

proc reg data=sadvsmd;
	model MajorDepression_dx = BScore;
run;

proc reg data=sadvsmd;
	model MinorDepression_dx = BScore;
run;


proc gplot data=sadvsmd;
	plot PctMajorDDAtLatBin_1 * latbin_1
		PctMinorDDAtLatBin_1 * latbin_1
		PctMajorMinorAtLatBin_1 * latbin_1
		/overlay;
run;

proc reg data=sadvsmd;
	model PctMajorDDAtLatBin_1 = latbin_1;
run;

proc reg data=sadvsmd;
	model Bscore = latbin_1;
run;
*/

/* Analyses with Terman on 4/15/04 */
/*
proc sql;
	create table vegitativenonMD as
	select distinct * from 
	cet7a.sadvsmd
	where Dscore >= 4 and hasWinterSeasonality = 1 and MinorDepression_dx = 0 and MajorDepression_Dx = 0
	;

data sadvsmd; set cet7a.sadvsmd;
	if (MajorDepression_Dx = 1) then DepressionType = 'Major';
	else if (MinorDepression_Dx = 1) then DepressionType = 'Minor';
	else if (Dscore >= 4) then DepressionType = 'SVD';	* SVD = seasonal vegitative depression
	else delete;
run;

proc freq data=sadvsmd;
	where hasWinterSeasonality = 1;
	tables DepressionType;
run;

proc freq data=sadvsmd;
	tables hasWinterSeasonality;
run;

options pagesize=MAX;
proc freq data=sadvsmd; 
	tables Dscore * DepressionType;
run;

proc freq data=sadvsmd;
	tables d_sex * DepressionType;
run;

proc gplot data=sadvsmd;
	plot MajorDepression_dx * Bscore = DepressionType;
run;

data sadvsmd; set sadvsmd;
	if (MajorDepression_Dx = 1) then MajorOrMinor = 1;
	else if (MinorDepression_Dx = 1) then MajorOrMinor = 1;
	else MajorOrMinor = 0;
RUN;

proc freq data=sadvsmd;
	where Bscore >= 12;
	tables MajorOrMinor;
run;


*/

/*
proc sql;
	create table vegitativenonMD as
	select distinct * from 
	cet7a.sadvsmd
	where Dscore >= 4 and hasWinterSeasonality = 1 and MinorDepression_dx = 0 and MajorDepression_Dx = 0
	;

data sadvsmd; set cet7a.sadvsmd;
	if (MajorDepression_Dx = 1) then DepressionType = 'Major';
	else if (MinorDepression_Dx = 1) then DepressionType = 'Minor';
	else if (Dscore >= 4) then DepressionType = 'SVD';
	else delete;
run;

proc freq data=sadvsmd;
	where hasWinterSeasonality = 1;
	tables DepressionType;
run;

proc freq data=sadvsmd;
	tables hasWinterSeasonality;
run;
options pagesize=MAX;
proc freq data=sadvsmd; 
	tables Dscore * DepressionType;
run;

proc freq data=sadvsmd;
	tables d_sex * DepressionType;
run;

proc gplot data=sadvsmd;
	plot MajorDepression_dx * Bscore = DepressionType;
run;

data sadvsmd; set sadvsmd;
	if (MajorDepression_Dx = 1) then MajorOrMinor = 1;
	else if (MinorDepression_Dx = 1) then MajorOrMinor = 1;
	else MajorOrMinor = 0;
RUN;

* Determine cumulative probability of having Diagnosis above the threshold of each given score
* Do this for MajorOrMinor (total), Major, Minor, and Vegitative

proc freq data=sadvsmd;
	title Bscore >= 7;
	where Bscore >= 7;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 8;
	title Bscore >= 8;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 9;
	title Bscore >= 9;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 10;
	title Bscore >= 10;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 11;
	title Bscore >= 11;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 12;
	title Bscore >= 12;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 13;
	title Bscore >= 13;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 14;
	title Bscore >= 14;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd;
	where Bscore >= 15;
	title Bscore >= 15;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 16;
	title Bscore >= 16;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 17;
	title Bscore >= 17;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 18;
	title Bscore >= 18;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd;
	where Bscore >= 19;
	title Bscore >= 19;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 20;
	title Bscore >= 20;
	tables MajorOrMinor;
run;


proc freq data=sadvsmd;
	where Bscore >= 21;
	title Bscore >= 21;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 22;
	title Bscore >= 22;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd;
	where Bscore >= 23;
	title Bscore >= 23;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd;
	where Bscore >= 24;
	title Bscore >= 24;
	tables MajorOrMinor;
run;


*/
/*
data sadvsmd2; set sadvsmd;
	where hasWinterSeasonality = 1;
run;

proc freq data=sadvsmd2;
	where Bscore >= 21;
	title Bscore >= 21;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 22;
	title Bscore >= 22;
	tables DepressionType;
run;
proc freq data=sadvsmd2;
	where Bscore >= 23;
	title Bscore >= 23;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 24;
	title Bscore >= 24;
	tables DepressionType;
run;


proc freq data=sadvsmd2;
	title Bscore >= 7;
	where Bscore >= 7;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 8;
	title Bscore >= 8;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 9;
	title Bscore >= 9;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 10;
	title Bscore >= 10;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 11;
	title Bscore >= 11;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 12;
	title Bscore >= 12;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 13;
	title Bscore >= 13;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 14;
	title Bscore >= 14;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd2;
	where Bscore >= 15;
	title Bscore >= 15;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 16;
	title Bscore >= 16;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 17;
	title Bscore >= 17;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 18;
	title Bscore >= 18;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd2;
	where Bscore >= 19;
	title Bscore >= 19;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 20;
	title Bscore >= 20;
	tables MajorOrMinor;
run;


proc freq data=sadvsmd2;
	where Bscore >= 21;
	title Bscore >= 21;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 22;
	title Bscore >= 22;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd2;
	where Bscore >= 23;
	title Bscore >= 23;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 24;
	title Bscore >= 24;
	tables MajorOrMinor;
run;




proc freq data=sadvsmd2;
	title Bscore >= 7;
	where Bscore >= 7;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 8;
	title Bscore >= 8;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 9;
	title Bscore >= 9;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 10;
	title Bscore >= 10;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 11;
	title Bscore >= 11;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 12;
	title Bscore >= 12;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 13;
	title Bscore >= 13;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 14;
	title Bscore >= 14;
	tables DepressionType;
run;
proc freq data=sadvsmd2;
	where Bscore >= 15;
	title Bscore >= 15;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 16;
	title Bscore >= 16;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 17;
	title Bscore >= 17;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 18;
	title Bscore >= 18;
	tables DepressionType;
run;
proc freq data=sadvsmd2;
	where Bscore >= 19;
	title Bscore >= 19;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 20;
	title Bscore >= 20;
	tables DepressionType;
run;

*/
/*
data sadvsmd2; set sadvsmd;
	where hasWinterSeasonality = 1;
run;



proc freq data=sadvsmd2;
	title Bscore >= 7;
	where Bscore >= 7;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 8;
	title Bscore >= 8;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 9;
	title Bscore >= 9;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 10;
	title Bscore >= 10;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 11;
	title Bscore >= 11;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 12;
	title Bscore >= 12;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 13;
	title Bscore >= 13;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 14;
	title Bscore >= 14;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd2;
	where Bscore >= 15;
	title Bscore >= 15;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 16;
	title Bscore >= 16;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 17;
	title Bscore >= 17;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 18;
	title Bscore >= 18;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd2;
	where Bscore >= 19;
	title Bscore >= 19;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 20;
	title Bscore >= 20;
	tables MajorOrMinor;
run;


proc freq data=sadvsmd2;
	where Bscore >= 21;
	title Bscore >= 21;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 22;
	title Bscore >= 22;
	tables MajorOrMinor;
run;
proc freq data=sadvsmd2;
	where Bscore >= 23;
	title Bscore >= 23;
	tables MajorOrMinor;
run;

proc freq data=sadvsmd2;
	where Bscore >= 24;
	title Bscore >= 24;
	tables MajorOrMinor;
run;



proc freq data=sadvsmd2;
	title Bscore >= 7;
	where Bscore >= 7;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 8;
	title Bscore >= 8;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 9;
	title Bscore >= 9;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 10;
	title Bscore >= 10;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 11;
	title Bscore >= 11;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 12;
	title Bscore >= 12;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 13;
	title Bscore >= 13;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 14;
	title Bscore >= 14;
	tables DepressionType;
run;
proc freq data=sadvsmd2;
	where Bscore >= 15;
	title Bscore >= 15;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 16;
	title Bscore >= 16;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 17;
	title Bscore >= 17;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 18;
	title Bscore >= 18;
	tables DepressionType;
run;
proc freq data=sadvsmd2;
	where Bscore >= 19;
	title Bscore >= 19;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 20;
	title Bscore >= 20;
	tables DepressionType;
run;


proc freq data=sadvsmd2;
	where Bscore >= 21;
	title Bscore >= 21;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 22;
	title Bscore >= 22;
	tables DepressionType;
run;
proc freq data=sadvsmd2;
	where Bscore >= 23;
	title Bscore >= 23;
	tables DepressionType;
run;

proc freq data=sadvsmd2;
	where Bscore >= 24;
	title Bscore >= 24;
	tables DepressionType;
run;


*/

/* IRB Report *

data automeq; set cet7a.automeq;
run;

proc sort data=automeq;
	by age_cat;
run;

%StartAnODSReport("&cet7a_lib.irbreport.htm");

proc freq data=automeq;
	by age_cat;

	tables d_sex * irb_ethnicity;
run;

%FinishAnODSReport;

*/

/* Possible analysis of relationship between sleep duration, latitude and depression *
data test2; set cet7a.sadvsmd2;
	keep lat_good sduravg season MajorDepression_dx;
	where season=1;
run;

proc sort data=test2;
	by MajorDepression_Dx;
run;

proc corr data=test2;
	by MajorDepression_Dx;
	with sduravg;
	var lat_good;
run;
*/