/* Modularizing code for easier replication */

%macro SetInitParams;
options compress=NO;

%global helpers cet3_lib cet4_lib cet5_lib cet7old_lib cet7_06_lib;

%let helpers = C:\data\cet-irb5\analysis\AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb);

%let cet3_lib = C:\data\cet7\analysis\AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb);
%let cet4_lib = C:\data\cet7\analysis\AutoMEQ-SA-v4.0-(AutoMEQ-SA-irb);
%let cet5_lib = C:\data\cet7\analysis\AutoMEQ-SA-v5.0-(AutoMEQ-SA-irb);
%let cet7old_lib = C:\data\cet-2005-04\;

%let cet7_06_lib = C:\data\cet_200506\analysis;

libname helpers "&helpers";

libname cet3 "&cet3_lib";
libname cet4 "&cet4_lib";
libname cet5 "&cet5_lib";
libname cet7old "&cet7old_lib";
libname cet7 "&cet7_06_lib";

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
		3 = 'Other'
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

options pagesize=50 linesize=120;
	
%mend SetInitParams;


%macro LoadRawData;

/* %include "&cet7_lib\deformat_automeq.sas"; */

/* %include "&cet5_lib\automeq_formats.sas"; */

%include "\cvs2\Dialogix\cet_analysis\LoadAutomeq7-200506-data.sas";

data cet7.automeq7; set automeq7;
run;

data cet7.automeq_all; set cet7old.automeq3 cet7old.automeq4 cet7old.automeq5all cet7.automeq7;
	format zip_gis $ 5.;
	zip_gis = put(d_zip,z5.);
run;

/* 6/27:  Not needed -- 21763 records either way
proc sql;
	create table cet7.automeq_all as
	select distinct *
	from cet7.automeq_all;
quit;
*/

%mend LoadRawData;

%macro LoadSupportTables;

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
		statecode, latitude, longitude, GMTOffset, DST, timezone
	from helpers.zipcodes
	order by zipcode;
	
/* convert the character value of zip code to a number */
data zips; set zips;
	zipnum = input(zipcode,best12.);
run;

/* backup this table */
data cet7.zips; set zips;
run;

PROC IMPORT OUT=cet7.musa_zip_25dg
            DATAFILE= "C:\data\cet-2005-04\zip_centroids_2p5dg.xls"
            DBMS=EXCEL2000 REPLACE;
     GETNAMES=YES;
RUN;

/* 6/27: join zips together here? */

proc sql;
	create table cet7.zip_gis as
	select a.zipcode, b.zip, a.statecode, b.state, a.latitude, b.Y, a.longitude, b.X, a.gmtoffset, a.dst, a.timezone, 
		b.po_name, b.urban, b.name, b.sad_div,
		(a.latitude-b.Y) as Diff_Lat,
		(a.longitude-b.X) as Diff_Long
	from cet7.zips a full outer join cet7.musa_zip_25dg b
	on a.zipcode = b.zip and a.statecode = b.state
	order by a.zipcode, b.zip;
quit;

/* 6/27: which is best match for zips from our data (e.g. how much is lost?) */
proc sql;
	create table test as
	select a.zip_gis, count(zip) as NumMatches
	from cet7.automeq_all a left join cet7.zip_gis b
	on a.zip_gis = b.zip
	where a.zip_gis ne ''
	group by a.zip_gis
	order by NumMatches, a.zip_gis;
quit;

proc freq data=test;
	tables NumMatches;
run;
/* 149 non-matches to Musa data */

proc sql;
	create table test as
	select a.zip_gis, count(zipcode) as NumMatches
	from cet7.automeq_all a left join cet7.zip_gis b
	on a.zip_gis = b.zipcode
	where a.zip_gis ne ''
	group by a.zip_gis
	order by NumMatches, a.zip_gis;
quit;

proc freq data=test;
	tables NumMatches;
run;
/* 26 non-matches on purchased data */

/* Also merge in 1 degree units? */
PROC IMPORT OUT=cet7.musa_zip_1and5dg 
            DATAFILE= "C:\data\cet-2005-04\analysis-0526\zip_centroids_div_coop_5dg_1dg_cnty_dem99.xls"
            DBMS=EXCEL2000 REPLACE;
     GETNAMES=YES;
RUN;

/* So, do two step match */
proc sql;
	create table cet7.zip_gis as
	select a.zipcode, a.statecode, a.latitude, b.Y, a.longitude, b.X, a.gmtoffset, a.dst, a.timezone, 
		b.po_name, b.urban, b.name, b.sad_div,
		b._p5dgID as ID_dg2p5, b.pop1999 as pop99_dg2p5
	from cet7.zips a join cet7.musa_zip_25dg b
	on a.zipcode = b.zip and a.statecode = b.state
	order by a.zipcode;
quit;


proc sql;
	create table cet7.zip_gis as
	select a.*, b._dgID as ID_dg1, b._dgID0 as ID_dg5, b._dgPOP99 as pop99_dg1, b._dgPOP990 as pop99_dg5, b.pop1999 as pop99_zip
	from cet7.zip_gis a left join cet7.musa_zip_1and5dg b
	on a.zipcode = b.zip
	order by a.zipcode;
quit;

/* Now compute distances from timezone */

data cet7.zip_gis; set cet7.zip_gis;
	X_1dg = round(X,1);
	Y_1dg = round(Y,1);
	X_5dg = round(X,5);
	Y_5dg = round(Y,5);
	X_2_5dg = round(X,2.5);
	Y_2_5dg = round(Y,2.5);	
	
	/* Can compute sunrise and daylength for any day of the year!*/
	
	%Sunrise(latitude,longitude,gmtoffset,mdy(12,21,2005),win_solst,0);
run;
		
/* What is the rightmost longitude at each latitude? */
proc sql;
	create table dist_from_boundary as
	select distinct
		statecode, zipcode, X, Y, 
		timezone, gmtoffset, dst,
		Y_1dg,
		min(X) as min_X, max(X) as max_X
	from cet7.zip_gis
	group by timezone, gmtoffset, Y_1dg
	order by timezone, gmtoffset, Y_1dg;
quit;

/* 7/21/2005 */
proc sql;
	select min(Y), max(Y)
	from dist_from_boundary;
quit;

proc sql;
	create table dist_from_boundary_gmt as
	select distinct gmtoffset, statecode, max(X) as max_X
	from cet7.zip_gis
	group by gmtoffset
	having gmtoffset = -5
	order by max_X desc, statecode;
quit;

data dist_from_boundary; set dist_from_boundary;
	NN = _N_;
run;

proc sql;
	create table dist_from_boundary2 as
	select a.max_X, b.*
	from (select statecode, gmtoffset, max(max_X) as max_X from dist_from_boundary_gmt) as a, dist_from_boundary as b
	where b.statecode in (select distinct statecode from dist_from_boundary_gmt)
		and a.statecode = b.statecode
		and a.gmtoffset = b.gmtoffset;
quit;

proc sql;
	create table dist_from_boundary3 as
	select max_X, *
	from dist_from_boundary
	where NN not in (select NN from dist_from_boundary2);
quit;

data dist_from_boundary4; set dist_from_boundary2 dist_from_boundary3;
run;


/* By zip code, what is the distance from the eastern edge of the timezone -- this is accurate */
data cet7.dist_from_boundary; set dist_from_boundary4;
	dist_from_timezone_boundary = max_X - X;
	timezone_width = max_X - min_X;
run;

proc sql;	
	create table cet7.zip_gis as
	select a.*, b.min_X, b.max_X, b.dist_from_timezone_boundary, b.timezone_width
	from cet7.zip_gis a join cet7.dist_from_boundary b
	on a.zipcode = b.zipcode
	order by a.zipcode;
quit;

proc sql;
	create table cet7.zip_gis as
	select a.*, b.sunrise_local_win_solst
	from cet7.zip_gis a left join cet7.zip_with_sunrise b
	on a.zipcode = b.zipcode
	order by a.zipcode;
quit;

%mend LoadSupportTables;

%macro JoinAutomeqWithGeocoding;
/* N.B. This may lose considerable data if people aren't filling in their zip codes! */
/* This used to join on the state name, in which case we approximated the latitude */
proc sql;
	create table cet7.automeq_zip as
	select distinct l.*, r.*
	 from cet7.automeq_all l left join cet7.zip_gis r
	 on l.zip_gis = r.zipcode
	 order by startdat;
quit;

/* How many missing or invalid zip codes? */
data nozip; set cet7.automeq_zip;
	keep version _state_name ziptype ziptype2;
	if (d_zip = .) then ziptype = 'missing';
	else if (d_zip <= 0) then ziptype = 'invalid';
	else if (d_zip > 0) then ziptype = 'real?';
	if (zipcode ne '') then ziptype2 = 'real'; else ziptype2 = 'invalid';
run;

proc freq data=nozip;
	tables _state_name * ziptype;
	tables _state_name * ziptype2;
run;
/* 7259 "real?" values, 374 invalid, 24 missing */
/* 6941 "real" values, 716 invalid (9.35%) - using Musa's zip criteria */
/* Note, 6789 subjects "joined" the study - so how are there more real values than participants? */
%mend JoinAutomeqWithGeocoding;

%macro ProcessAutoMeqData;
data cet7.automeq; set cet7.automeq_zip;
	d_awake_ = left(d_awake_workday);
	wakewrk_str = d_awake_workday;
	drop d_awake_workday;
	d_awake_nonworkday = left(d_awake_nonworkday);
	wakenwk_str = d_awake_nonworkday;
	drop d_awake_nonworkday;
	
	d_sleep_workday = left(d_sleep_workday);
	sleepwrk_str = d_sleep_workday;
	drop d_sleep_workday;
	d_sleep_nonworkday = left(d_sleep_nonworkday);
	sleepnwk_str = d_sleep_nonworkday;
	drop d_sleep_nonworkday;
	
	wakemeq_str = LIGHTS_ON_time;
	drop LIGHTS_ON_time;
	sleepmeq_str = SL_ONSET_time;
	drop SL_ONSET_time;
	
	abnlslep = d_abnl_sleep; drop d_abnl_sleep;
	country = d_country; drop d_country;
	workdays = d_working_days; drop d_working_days;
	comments = Feedback_us; drop Feedback_us;
	
	if country = 'Canada'  then latabout = 47;

	if (zipcode ne '') then okzip = 1; else okzip = 0;

	if (statecode eq '') then lat_good = latabout;
	else if (okzip = 1) then lat_good = latitude;
	else lat_good = latabout;
	
	/* Manually process the time data -- much faster */
	format time_val time18.;
		
	time_val = timepart(input(left(wakewrk_str),TIME.));	
	wakewrk = hour(time_val) + minute(time_val) / 60;
	
	time_val = timepart(input(left(wakenwk_str),TIME.));
	wakenwk = hour(time_val) + minute(time_val) / 60;
	
	time_val = timepart(input(left(wakemeq_str),TIME.));	
	wakemeq = hour(time_val) + minute(time_val) / 60;
	
	time_val = timepart(input(left(sleepwrk_str),TIME.));	
	sleepwrk = hour(time_val) + minute(time_val) / 60;
	
	time_val = timepart(input(left(sleepnwk_str),TIME.));
	sleepnwk = hour(time_val) + minute(time_val) / 60;
		
	time_val = timepart(input(left(sleepmeq_str),TIME.));	
	sleepmeq = hour(time_val) + minute(time_val) / 60;

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
	else season = 3;
		
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
		(meqstd > 1.7) or
		(lat_good = .) or
		(workdays < 0) or
		(wakenwk = . or sleepnwk = .) or
		(workdays > 0 and (wakewrk = . or sleepwrk = .)) or
		(sduravg = . or smidavg = .) or
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
	
	if ((d_age > 100 or d_age < 14) or
		(meqstd > 1.7) or
		(lat_good = .) or
		(workdays < 0) or
		(wakenwk = . or sleepnwk = .) or
		(workdays > 0 and (wakewrk = . or sleepwrk = .)) or
		(sduravg = . or smidavg = .) or
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
		(sdurnwk < 4 or sdurnwk > 12)
	)
		then world_keep = 0;
	else world_keep = 1;		
	
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
	
	if (B1  >= 3) then do;
		hypsomsr =  1 + (C4A_Nov + C4A_Dec + C4A_Jan + C4A_Feb);
	end;
	else hypsomsr = 0;
	
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
	
	/* Code from April-June / 05 */
	
	if (hypsomsr > 1) then is_hypsomsr = 1; else is_hypsomsr = 0;
	if (Bscore >= 11 and hasWinterSeasonality = 1) then seasonal = 1; else seasonal=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and (MajorDepression_dx = 1)) then seas_mdd = 1; else seas_mdd=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and (MajorDepression_dx = 1 or MinorDepression_dx = 1)) then majmin = 1; else majmin=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and (MinorDepression_dx = 1)) then seas_min = 1; else seas_min=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and (SANS = 1)) then seas_sans = 1; else seas_sans=0;
	
	if (Bscore >= 11 and hasWinterSeasonality = 1 and hypsomsr > 1) then seasonal_hypersom = 1; else seasonal_hypersom = 0;
	
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A1 = 1) then sleep_dist = 1; else sleep_dist=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A2 = 1) then fatigue_A2 = 1; else fatigue_A2=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A3 = 1) then eating_dist = 1; else eating_dist=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A4 = 1) then anhedonia = 1; else anhedonia=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A5 = 1) then mood_dist = 1; else mood_dist=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A6 = 1) then negative_thoughts = 1; else negative_thoughts=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A7 = 1) then concentration = 1; else concentration=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A8 = 1) then restless = 1; else restless=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and A9 = 1) then suicidal = 1; else suicidal=0;
	
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D1 = 1) then hypersom_D1 = 1; else hypersom_D1=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D2 = 1) then diff_awakening = 1; else diff_awakening=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D3 = 1) then fatigue = 1; else fatigue=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D4 = 1) then evenings_worst = 1; else evenings_worst=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D5 = 1) then afternoon_slump = 1; else afternoon_slump=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D6 = 1) then carb_craving = 1; else carb_craving=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D7 = 1) then carbo_eating = 1; else carbo_eating=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D8 = 1) then carb_craving_in_pm = 1; else carb_craving_in_pm=0;
	if (Bscore >= 11 and hasWinterSeasonality = 1 and D9 = 1) then weight_gain = 1; else weight_gain=0;
	
	/* 10/12/05 revisions */
	if (dist_from_timezone_boundary > 11.31672) then bin2_dtz = ">11.31672"; else bin2_dtz = "<11.31672" ;
	if (sunrise_local_win_solst > 7.654) then bin2_sunrise = ">7.654"; else bin2_sunrise = "<7.654";
	if (Y > 36.94834) then bin2_Y = ">36.94834"; else bin2_Y = "<36.94834";
	
	if (dist_from_timezone_boundary < 7.54448) then 
		bin3_dtz = "0.0000-7.54448";
	else if (dist_from_timezone_boundary < 15.08896) then
		bin3_dtz = "7.54448-15.08896";
	else
		bin3_dtz= "15.08896-22.63344";
		
	if (sunrise_local_win_solst < 7.271866667) then
		bin3_sunrise = "6.507-7.27187";
	else if (sunrise_local_win_solst < 8.036733333) then
		bin3_sunrise = "7.27187-8.03673";
	else
		bin3_sunrise = "8.03673-8.8016";

	if (Y < 32.82638333) then
		bin3_Y = "24.58247-32.826383";
	else if (Y < 41.07029667) then
		bin3_Y = "24.58247-41.0703";
	else 
		bin3_Y = "41.0703-49.31421";
		
	if (dist_from_timezone_boundary < 5.66) then
		bin4_dtz = "0.00-5.66";
	else if (dist_from_timezone_boundary < 11.32) then
		bin4_dtz = "5.66-11.32";
	else if (dist_from_timezone_boundary < 16.98) then
		bin4_dtz = "16.98-22.63";
		
	if (sunrise_local_win_solst < 7.08) then
		bin4_sunrise = "6.51-7.08";
	else if (sunrise_local_win_solst < 7.65) then
		bin4_sunrise = "7.08-7.65";
	else if (sunrise_local_win_solst < 8.23) then
		bin4_sunrise = "7.65-8.23";
	else
		bin4_sunrise = "8.23-8.80";
		
	if (Y < 30.77) then
		bin4_Y = "24.58-30.77";
	else if (Y < 36.95) then
		bin4_Y = "30.77-36.95";
	else if (Y < 43.13) then
		bin4_Y = "36.95-43.13";
	else
		bin4_Y = "43.13-49.31";
		
	if (dist_from_timezone_boundary < 5.0) then 
		bin3a_dtz = "0.0-5.0";
	else if (dist_from_timezone_boundary < 10) then
		bin3a_dtz = "5.0-10.0";
	else
		bin3a_dtz= ">10";
		
	if (dist_from_timezone_boundary < 3.75) then
		bin4a_dtz = "0.00-3.75";
	else if (dist_from_timezone_boundary < 7.5) then
		bin4a_dtz = "3.75-7.5";
	else if (dist_from_timezone_boundary < 11.25) then
		bin4a_dtz = "7.5-11.25";
	else 
		bin4a_dtz = ">11.25";
	
	/* 5/20/05 revisions */
	if (X >= -75 and X < -69) then timezone_band='east-EST';
	else if ((X <= -81.5 and statecode in ('ME','NY','MA','VT','RI','CT','NJ','DE','MD','VA','NC','WV','PA','OH','MI'))
		or (X < -81.5 and Y >= -90 and country in ('Canada')))
		then timezone_band='west-EST';
	else if ((X >= -93.5 and statecode in ('ND','SD','NE','KS','OK','MN','IA','MO','WI','IL','IN','TN','ID'))
		or (X >= -96 and Y < -90 and country in ('Canada')))
		then timezone_band='east-CST';
	else if (statecode in ('OR','WA')
		or (X < -120 and country in ('Canada'))) then timezone_band='west-PST';
	else 
		timezone_band='other';
	
	if (timezone_band in ('east-EST', 'east-CST')) then timezone_side='east';
	if (timezone_band in ('west-EST', 'west-PST')) then timezone_side='west';	
	
	X_1dg = round(X,1);
	Y_1dg = round(Y,1);
	X_5dg = round(X,5);
	Y_5dg = round(Y,5);
	
	X_2_5dg = round(X,2.5);
	Y_2_5dg = round(Y,2.5);		
	
	Y_2dg = round(Y,2);
	
	/* Add binning by distance from Timezone for graphing purposes */
	dtz_1dg = round(dist_from_timezone_boundary,1);
	dtz_2p5dg = round(dist_from_timezone_boundary,2.5);
	dtz_3dg = round(dist_from_timezone_boundary,3);
	dtz_5dg = round(dist_from_timezone_boundary,5);
	
	dtz_4dg = round(dist_from_timezone_boundary,4);
	
	if (dtz_4dg > 16) then dtz_4dg = 20;
	
	Y_2dg = round(Y,2);
	if (Y_2dg > 48) then Y_2dg = 50;		
	
	if (Y_2dg <= 26) then delete;	/* Do I really want to delete these? */

	Y_4dg = round(Y,4);
	if (Y_4dg > 48) then Y_4dg = 52;	
run;

/* distributions */
proc freq data=cet7.automeq; 
/*	tables country wakewrk_str wakenwk_str wakemeq_str sleepwrk_str workdays abnlslep; */
	tables useForSADvsMDDanalysis;
	tables keep;	/* 0 */
	tables d_sex eye_type abnlslep longslep joined 
		complete d_who okzip d_los;
	tables timezone_band timezone_side;
run;

/* make a data set of only those values we want to keep *
proc sql;
	create table cet7.keepers as
	select distinct
		uniqueid,
		joined, complete, d_who, abnlslep,
		startdat, month, season,
		startabs, startloc,wasDST,GMToffset,
		d_sex, d_age, age_cat,
		d_eye, eye_type, ethnicity, irb_ethnicity,
		country, statenam, statecode, statecode, d_los,
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
		C1A_Nov, C2A_Nov, C3A_Nov, C4A_Nov, C5A_Nov, C6A_Nov, CscrNovA,
		C1A_Mar, C2A_Mar, C3A_Mar, C4A_Mar, C5A_Mar, C6A_Mar, CscrMarA,
		D1, D2, D3, D4, D5, D6, D7, D8, D9, Dscore,
		MDcrit1, MDcrit2, MDcrit3, MDcrit4, MDcrit5, MDcrit6,
		C_WinterBad, C_WinterGood, C_SummerBad, C_SummerGood,
		solstice, winterbad, summerbad,
		useForSADvsMDDanalysis, hasWinterSeasonality,
		latbin_1, latbin_2, latbin_2_5, latbin_5,
		MajorDepression_dx, MinorDepression_dx,
		hypsomsr,
		youngadult, iswinter, SANS, dx_cat, latbin_2_5b, latbin_2_5C, age_bin
	from cet7.automeq
	where keep = 1;
	;
quit;
*/

/* Add analyses used for detecting cases of SANS */
data cet7.SADvsMD; set cet7.automeq;
	where useForSADvsMDDanalysis = 1 and keep=1;
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
	select country, statenam, statecode, statecode, d_zip, okzip, latabout, latitude, lat_good
	from work.keepers
	order by okzip;
*/
	
/*
PROC EXPORT DATA= work.keepers 
            OUTFILE= "&cet7a_lib\Automeq.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

PROC EXPORT DATA= work.SADvsMD 
            OUTFILE= "&cet7a_lib\SADvsMD.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/

/* Add code for 4/13/05 analyses:
Self-reported hypersomnia = say 3 or 4 on B1 (moderate / severe sleeping longer in winter); 
C4A subset - how many bad winter months (from 0-4)
*/

/* proc freq data=cet7.automeq; tables C4A_Nov C4A_Dec C4A_Jan C4A_Feb; run; */
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
data SADvsMD; set nonwinterworse;
	where Bscore ne . and MDcrit3 ne . and 
run;

proc sort data=SADvsMD; by Bscore; 

proc freq data=SADvsMD;
	by Bscore;
	table MDcrit3;
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

proc freq data=cet7.keepers; 
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

proc freq data=cet7.keepers;
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
	cet7.sadvsmd
	where Dscore >= 4 and hasWinterSeasonality = 1 and MinorDepression_dx = 0 and MajorDepression_Dx = 0
	;

data sadvsmd; set cet7.sadvsmd;
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
	cet7.sadvsmd
	where Dscore >= 4 and hasWinterSeasonality = 1 and MinorDepression_dx = 0 and MajorDepression_Dx = 0
	;

data sadvsmd; set cet7.sadvsmd;
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

* Can these individual frequency calculations be re-written for easier use? *
* How about use proc freq -- shows cummulative frequencies *
data sadvsmd; set sadvsmd;
	if (Bscore >= 0) then BscoreGe0 = 1;
	if (Bscore >= 1) then BscoreGe1 = 1;
	if (Bscore >= 2) then BscoreGe2 = 1;
	if (Bscore >= 3) then BscoreGe3 = 1;
	if (Bscore >= 4) then BscoreGe4 = 1;
	if (Bscore >= 5) then BscoreGe5 = 1;
	if (Bscore >= 6) then BscoreGe6 = 1;
	if (Bscore >= 7) then BscoreGe7 = 1;
	if (Bscore >= 8) then BscoreGe8 = 1;
	if (Bscore >= 9) then BscoreGe9 = 1;
	if (Bscore >= 10) then BscoreGe10 = 1;
	if (Bscore >= 11) then BscoreGe11 = 1;
	if (Bscore >= 12) then BscoreGe12 = 1;
	if (Bscore >= 13) then BscoreGe13 = 1;
	if (Bscore >= 14) then BscoreGe14 = 1;
	if (Bscore >= 15) then BscoreGe15 = 1;
	if (Bscore >= 16) then BscoreGe16 = 1;
	if (Bscore >= 17) then BscoreGe17 = 1;
	if (Bscore >= 18) then BscoreGe18 = 1;
	if (Bscore >= 19) then BscoreGe19 = 1;
	if (Bscore >= 20) then BscoreGe20 = 1;
	if (Bscore >= 21) then BscoreGe21 = 1;
	if (Bscore >= 22) then BscoreGe22 = 1;
	if (Bscore >= 23) then BscoreGe23 = 1;
	if (Bscore >= 24) then BscoreGe24 = 1;
run;


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

data automeq; set cet7.automeq;
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
data test2; set cet7.sadvsmd2;
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

/* 5/6/05 */
data cet7.daylightsavings2; set cet7.automeq;
	if (d_age < 22) then delete;	/* remove children */
	if (d_age > 70) then delete;	/* remove elderly */
	where (Y >= 39 and Y <= 50 and keep=1);	/* keep restricted latitude band */
run;

%mend ProcessAutoMeqData;

%macro TimezoneAnalyses_0;
proc sql;
	create table test as
	select timezone_band, count(*) as N, sum(is_hypsomsr) as N_hypersom, sum(is_hypsomsr) / count(*) as Ratio,
		 sum(seasonal_hypersom) as N_seasonal_hypersom, sum(seasonal_hypersom) / count(*) as Ratio_seasonal_hypersom,
		 sum(seasonal) as N_seasonal, sum(seasonal) / count(*) as Ratio_Seasonal,
		 sum(seas_mdd) as N_mdd, sum(seas_mdd) / count(*) as Ratio_MDD,
		 sum(hyperphagia) as N_hyperphagia, sum(hyperphagia) / count(*) as Ratio_hyperphagia,
		 sum(fatigue) as N_fatigue, sum(fatigue) / count(*) as Ratio_fatigue,
		 avg(meq) as Avg_MEQ,
		 avg(sduravg) as Avg_SleepDuration,
		 avg(smidavg) as Avg_SleepMidpoint,
		 avg(d_age) as Avg_Age,
		 sum(d_sex) / count(*) as Pct_Female		 
	from cet7.daylightsavings2
	group by timezone_band
	order by timezone_band;
quit;

proc print data=test; run;


proc sql;
	create table test2 as
	select timezone_side, count(*) as N, sum(is_hypsomsr) as N_hypersom, sum(is_hypsomsr) / count(*) as Ratio,
		 sum(seasonal_hypersom) as N_seasonal_hypersom, sum(seasonal_hypersom) / count(*) as Ratio_seasonal_hypersom,
		 sum(seasonal) as N_seasonal, sum(seasonal) / count(*) as Ratio_Seasonal,
		 sum(seas_mdd) as N_mdd, sum(seas_mdd) / count(*) as Ratio_MDD,
		 sum(hyperphagia) as N_hyperphagia, sum(hyperphagia) / count(*) as Ratio_hyperphagia,
		 sum(fatigue) as N_fatigue, sum(fatigue) / count(*) as Ratio_fatigue,
		 avg(meq) as Avg_MEQ,
		 avg(sduravg) as Avg_SleepDuration,
		 avg(smidavg) as Avg_SleepMidpoint,
		 avg(d_age) as Avg_Age,
		 sum(d_sex) / count(*) as Pct_Female
	from cet7.daylightsavings2
	group by timezone_side
	order by timezone_side;
quit;

proc print data=test2; run;

proc sql;
	create table test3 as
	select season, timezone_band, count(*) as N, sum(is_hypsomsr) as N_hypersom, sum(is_hypsomsr) / count(*) as Ratio,
		 sum(seasonal_hypersom) as N_seasonal_hypersom, sum(seasonal_hypersom) / count(*) as Ratio_seasonal_hypersom,
		 sum(seasonal) as N_seasonal, sum(seasonal) / count(*) as Ratio_Seasonal,
		 sum(seas_mdd) as N_mdd, sum(seas_mdd) / count(*) as Ratio_MDD,
		 sum(hyperphagia) as N_hyperphagia, sum(hyperphagia) / count(*) as Ratio_hyperphagia,
		 sum(fatigue) as N_fatigue, sum(fatigue) / count(*) as Ratio_fatigue,
		 avg(meq) as Avg_MEQ,
		 avg(sduravg) as Avg_SleepDuration,
		 avg(smidavg) as Avg_SleepMidpoint,
		 avg(d_age) as Avg_Age,
		 sum(d_sex) / count(*) as Pct_Female
	from cet7.daylightsavings2
	group by season, timezone_band
	order by season, timezone_band;
quit;

proc print data=test3; run;


proc sql;
	create table test4 as
	select season, timezone_side, count(*) as N, sum(is_hypsomsr) as N_hypersom, sum(is_hypsomsr) / count(*) as Ratio,
		 sum(seasonal_hypersom) as N_seasonal_hypersom, sum(seasonal_hypersom) / count(*) as Ratio_seasonal_hypersom,
		 sum(seasonal) as N_seasonal, sum(seasonal) / count(*) as Ratio_Seasonal,
		 sum(seas_mdd) as N_mdd, sum(seas_mdd) / count(*) as Ratio_MDD,
		 sum(hyperphagia) as N_hyperphagia, sum(hyperphagia) / count(*) as Ratio_hyperphagia,
		 sum(fatigue) as N_fatigue, sum(fatigue) / count(*) as Ratio_fatigue,
		 avg(meq) as Avg_MEQ,
		 avg(sduravg) as Avg_SleepDuration,
		 avg(smidavg) as Avg_SleepMidpoint,
		 avg(d_age) as Avg_Age,
		 sum(d_sex) / count(*) as Pct_Female
	from cet7.daylightsavings2
	group by season, timezone_side
	order by season, timezone_side;
quit;

proc print data=test4; run;
%mend TimezoneAnalyses_0;

%macro ChiSquare_0;
/* these are significant */
proc freq data=cet7.daylightsavings2;
	where timezone_side ne '';
	tables timezone_side * seas_mdd / chisq;
	tables timezone_side * seasonal_hypersom / chisq;
	tables timezone_side * hyperphagia / chisq;
	tables timezone_side * fatigue / chisq;
	tables timezone_side * seasonal / chisq;
	
	tables timezone_side * sleep_dist / chisq;
	tables timezone_side * fatigue_A2 / chisq;
	tables timezone_side * eating_dist / chisq;
	tables timezone_side * anhedonia / chisq;
	tables timezone_side * mood_dist / chisq;
	tables timezone_side * negative_thoughts / chisq;
	tables timezone_side * concentration / chisq;
	tables timezone_side * restless / chisq;
	tables timezone_side * suicidal / chisq;
run;

/* so are these */
proc freq data=cet7.daylightsavings2;
	where timezone_band in ('east-EST', 'west-EST');
	tables timezone_band * seas_mdd / chisq;
	tables timezone_band * seasonal_hypersom / chisq;
	tables timezone_band * hyperphagia / chisq;
	tables timezone_band * fatigue / chisq;
	tables timezone_band * seasonal / chisq;
	
	tables timezone_band * sleep_dist / chisq;
	tables timezone_band * fatigue_A2 / chisq;
	tables timezone_band * eating_dist / chisq;
	tables timezone_band * anhedonia / chisq;
	tables timezone_band * mood_dist / chisq;
	tables timezone_band * negative_thoughts / chisq;
	tables timezone_band * concentration / chisq;
	tables timezone_band * restless / chisq;
	tables timezone_band * suicidal / chisq;	
run;

/* few of these are significant, beyling the switch across timezone boundaries */
proc freq data=cet7.daylightsavings2;
	where timezone_band in ('east-CST', 'west-EST');
	tables timezone_band * seas_mdd / chisq;
	tables timezone_band * seasonal_hypersom / chisq;
	tables timezone_band * hyperphagia / chisq;
	tables timezone_band * fatigue / chisq;
	tables timezone_band * seasonal / chisq;
	
	tables timezone_band * sleep_dist / chisq;
	tables timezone_band * fatigue_A2 / chisq;
	tables timezone_band * eating_dist / chisq;
	tables timezone_band * anhedonia / chisq;
	tables timezone_band * mood_dist / chisq;
	tables timezone_band * negative_thoughts / chisq;
	tables timezone_band * concentration / chisq;
	tables timezone_band * restless / chisq;
	tables timezone_band * suicidal / chisq;	
run;
%mend ChiSquare_0;


/* Mean latitudes are the same */
%macro TimezoneAnalyses_1;
proc sql;
	create table long_means as
	select timezone_band, mean(latitude) as MeanLat
	from cet7.daylightsavings2
	group by timezone_band
	order by timezone_band;
	
proc sql;
	create table all_means as
	select mean(latitude) as AvgMeanLat
	from cet7.daylightsavings2;
	
proc sql;
	select a.timezone_band, a.MeanLat, b.AvgMeanLat, (a.MeanLat - b.AvgMeanLat) as Diff
	from long_means a, all_means b
	order by a.timezone_band;
quit;

%mend TimezoneAnalyses_1;

/* 
                                         The SAS System           14:24 Friday, May 20, 2005  83

                                       timezone_band       MeanLat
                                       ŸŸŸŸŸŸŸŸŸŸŸŸŸŸŸŸŸŸ
                                       east-CST  42.15711
                                       east-EST  41.72658
                                       west-EST  41.72248
*/


/* [ ] latitude effect - ANOVA of latitudes - show that non-significant */
/* What about if for women only */
	
/** TODO:
	(1) Why don't my numbers match Michael's
	(2) Prepare data for George
*/

/** ToDos for George (5/27/04)
Tom, George,

I am going to be away for a week starting Wednesday.  I'm hoping the two of you can meet this Friday to clarify/plan poster presentation analyses for our abstract.  I am not familiar with George's techniques, but imagine that we want:

a. a map showing distribution of respondents across North America

b. a map for North America illustrating the latitude effect on global seasonality score and/or winter depression (major or major + minor?).  Our previous analyses were based on proportion of respondents in latitude bins.  I am not sure what is gained by correcting the numbers for population density, since the sample is self-selected and does not provide a basis for absolute prevalence estimates.  Maybe I misunderstand.

c. close-up map(s?) of our 3 longitude tiers, showing distribution of respondents and color coded for some (all?) of our outcome measures.  I think it is important to show some measures (sleep?) that do not show a longitude effect, in order to raise confidence that we have something more than a regional bias toward overreporting.

d. If you can work out a continuous longitude analysis for EST, not restricted to our arbitrary longitude divisions, that would be great, since it would allow us to correlate our variables with the time of sunrise.

I'm sure you have other ideas, as well, very likely better than mine!

Then, I hope we can meet the following Friday to select data and figures for final presentation, so I can draft poster text.  There is not much time left to get this all done.

How does this plan sound?

/Michael 	
*/
%macro TimezoneAnalyses_3;
proc sql;
	create table sad_data_at_1dg as
	select distinct timezone_band,
		_dgID as dg1_ID,
		count(*) as dg1_NumResondants,
		max(_dgPOP99) as dg1_POP99,
		count(*) * 1000 / max(_dgPOP99) as dg1_RespondantsPer1000,
		avg(d_age) as dg1_avg_Age,
		avg(d_sex) as dg1_pct_Female,
		avg(sduravg) as dg1_avg_SleepDuration,
		avg(smidavg) as dg1_avg_SleepMidpoint,
		avg(seasonal) as dg1_pct_Seasonal,
		avg(Bscore) as dg1_avg_Bscore,
		avg(meq) as dg1_avg_MEQ,
		avg(circphas) as dg1_avg_CircPhase,
		avg(seas_mdd) as dg1_pct_MDD,
		avg(SANS) as dg1_pct_SANS,
		avg(d_BMI) as dg1_avg_BMI,
		avg(workdays) as dg1_avg_Workdays,
		avg(majmin) as dg1_pct_majmin,
		avg(seasonal_hypersom) as dg1_pct_seasonal_hypersom,
		avg(hyperphagia) as dg1_pct_hyperphagia,
		avg(fatigue) as dg1_pct_fatigue,
		avg(sleep_dist) as dg1_pct_sleep_dist,
		avg(fatigue_A2) as dg1_pct_fatigue_A2,
		avg(eating_dist) as dg1_pct_eating_dist,
		avg(anhedonia) as dg1_pct_anhedonia,
		avg(mood_dist) as dg1_pct_mood_dist,
		avg(negative_thoughts) as dg1_pct_negative_thoughts,
		avg(concentration) as dg1_pct_concentration,
		avg(restless) as dg1_pct_restless,
		avg(suicidal) as dg1_pct_suicidal
	from cet7.daylightsavings2
	group by timezone_band, dg1_ID
	order by timezone_band, dg1_ID;
quit;

PROC EXPORT DATA= WORK.SAD_DATA_AT_1DG 
            OUTFILE= "C:\data\cet-2005-04\analysis-0526\sad_data_at_1dg.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

proc sql;
	create table sad_data_at_5dg as
	select distinct timezone_band,
		_dgID0 as dg5_ID,
		count(*) as dg5_NumResondants,
		max(_dgPOP990) as dg5_POP99,
		count(*) * 1000 / max(_dgPOP990) as dg5_RespondantsPer1000,
		avg(d_age) as dg5_avg_Age,
		avg(d_sex) as dg5_pct_Female,
		avg(sduravg) as dg5_avg_SleepDuration,
		avg(smidavg) as dg5_avg_SleepMidpoint,
		avg(seasonal) as dg5_pct_Seasonal,
		avg(Bscore) as dg5_avg_Bscore,
		avg(meq) as dg5_avg_MEQ,
		avg(circphas) as dg5_avg_CircPhase,
		avg(seas_mdd) as dg5_pct_MDD,
		avg(SANS) as dg5_pct_SANS,
		avg(d_BMI) as dg5_avg_BMI,
		avg(workdays) as dg5_avg_Workdays,
		avg(majmin) as dg5_pct_majmin,
		avg(seasonal_hypersom) as dg5_pct_seasonal_hypersom,
		avg(hyperphagia) as dg5_pct_hyperphagia,
		avg(fatigue) as dg5_pct_fatigue,
		avg(sleep_dist) as dg5_pct_sleep_dist,
		avg(fatigue_A2) as dg5_pct_fatigue_A2,
		avg(eating_dist) as dg5_pct_eating_dist,
		avg(anhedonia) as dg5_pct_anhedonia,
		avg(mood_dist) as dg5_pct_mood_dist,
		avg(negative_thoughts) as dg5_pct_negative_thoughts,
		avg(concentration) as dg5_pct_concentration,
		avg(restless) as dg5_pct_restless,
		avg(suicidal) as dg5_pct_suicidal
	from cet7.daylightsavings2
	group by timezone_band, dg5_ID
	order by timezone_band, dg5_ID;
quit;

PROC EXPORT DATA= WORK.SAD_DATA_AT_5DG 
            OUTFILE= "C:\data\cet-2005-04\analysis-0526\sad_data_at_5dg.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

proc sql;
	create table deg_2_5_ID as
	select distinct X_2_5dg, Y_2_5dg
	from cet7.daylightsavings2
	order by X_2_5dg, Y_2_5dg;
quit;

data deg_2_5_ID; set deg_2_5_ID;
	dg2_5_ID = _N_;
run;

proc sql;
	create table sad_data_at_2_5dg as
	select distinct timezone_band,
		X_2_5dg, Y_2_5dg,
		count(*) as dg2_5_NumResondants,
		avg(d_age) as dg2_5_avg_Age,
		avg(d_sex) as dg2_5_pct_Female,
		avg(sduravg) as dg2_5_avg_SleepDuration,
		avg(smidavg) as dg2_5_avg_SleepMidpoint,
		avg(seasonal) as dg2_5_pct_Seasonal,
		avg(Bscore) as dg2_5_avg_Bscore,
		avg(meq) as dg2_5_avg_MEQ,
		avg(circphas) as dg2_5_avg_CircPhase,
		avg(seas_mdd) as dg2_5_pct_MDD,
		avg(SANS) as dg2_5_pct_SANS,
		avg(d_BMI) as dg2_5_avg_BMI,
		avg(workdays) as dg2_5_avg_Workdays,
		avg(majmin) as dg2_5_pct_majmin,
		avg(seasonal_hypersom) as dg2_5_pct_seasonal_hypersom,
		avg(hyperphagia) as dg2_5_pct_hyperphagia,
		avg(fatigue) as dg2_5_pct_fatigue,
		avg(sleep_dist) as dg2_5_pct_sleep_dist,
		avg(fatigue_A2) as dg2_5_pct_fatigue_A2,
		avg(eating_dist) as dg2_5_pct_eating_dist,
		avg(anhedonia) as dg2_5_pct_anhedonia,
		avg(mood_dist) as dg2_5_pct_mood_dist,
		avg(negative_thoughts) as dg2_5_pct_negative_thoughts,
		avg(concentration) as dg2_5_pct_concentration,
		avg(restless) as dg2_5_pct_restless,
		avg(suicidal) as dg2_5_pct_suicidal
	from cet7.daylightsavings2
	group by timezone_band, X_2_5dg, Y_2_5dg
	order by timezone_band, X_2_5dg, Y_2_5dg;
quit;

proc sql;
	create table sad_data_at_2_5dg as
	select a.dg2_5_ID, b.*
	from deg_2_5_ID a join sad_data_at_2_5dg b
	on a.X_2_5dg = b.X_2_5dg and a.Y_2_5dg = b.Y_2_5dg;
quit;

PROC EXPORT DATA= WORK.sad_data_at_2_5dg 
            OUTFILE= "C:\data\cet-2005-04\analysis-0526\sad_data_at_2_5dg.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

proc sql;
	create table sad_data_at_tier as
	select distinct timezone_band,
		count(*) as tier_NumResondants,
		avg(d_age) as tier_avg_Age,
		avg(d_sex) as tier_pct_Female,
		avg(sduravg) as tier_avg_SleepDuration,
		avg(smidavg) as tier_avg_SleepMidpoint,
		avg(seasonal) as tier_pct_Seasonal,
		avg(Bscore) as tier_avg_Bscore,
		avg(meq) as tier_avg_MEQ,
		avg(circphas) as tier_avg_CircPhase,
		avg(seas_mdd) as tier_pct_MDD,
		avg(SANS) as tier_pct_SANS,
		avg(d_BMI) as tier_avg_BMI,
		avg(workdays) as tier_avg_Workdays,
		avg(majmin) as tier_pct_majmin,
		avg(seasonal_hypersom) as tier_pct_seasonal_hypersom,
		avg(hyperphagia) as tier_pct_hyperphagia,
		avg(fatigue) as tier_pct_fatigue,
		avg(sleep_dist) as tier_pct_sleep_dist,
		avg(fatigue_A2) as tier_pct_fatigue_A2,
		avg(eating_dist) as tier_pct_eating_dist,
		avg(anhedonia) as tier_pct_anhedonia,
		avg(mood_dist) as tier_pct_mood_dist,
		avg(negative_thoughts) as tier_pct_negative_thoughts,
		avg(concentration) as tier_pct_concentration,
		avg(restless) as tier_pct_restless,
		avg(suicidal) as tier_pct_suicidal
	from cet7.daylightsavings2
	group by timezone_band
	order by timezone_band;
quit;

PROC EXPORT DATA= WORK.SAD_DATA_AT_TIER
            OUTFILE= "C:\data\cet-2005-04\analysis-0526\sad_data_at_tier.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
%mend TimezoneAnalyses_3;

/* Analyses */
%macro TimezoneAnalyses_4;	/* ChiSquares of Urbanness */
/* few of these are significant */
proc freq data=cet7.daylightsavings2;
	where timezone_band ne 'other';
	tables urban * seas_mdd / chisq;
	tables urban * seasonal_hypersom / chisq;
	tables urban * hyperphagia / chisq;
	tables urban * fatigue / chisq;
	tables urban * seasonal / chisq;
	
	tables urban * sleep_dist / chisq;
	tables urban * fatigue_A2 / chisq;
	tables urban * eating_dist / chisq;
	tables urban * anhedonia / chisq;
	tables urban * mood_dist / chisq;
	tables urban * negative_thoughts / chisq;
	tables urban * concentration / chisq;
	tables urban * restless / chisq;
	tables urban * suicidal / chisq;	
run;

proc freq data=cet7.daylightsavings2;
	tables urban * timezone_band * seas_mdd / chisq;
	tables urban * timezone_band * seasonal_hypersom / chisq;
	tables urban * timezone_band * hyperphagia / chisq;
	tables urban * timezone_band * fatigue / chisq;
	tables urban * timezone_band * seasonal / chisq;
	
	tables urban * timezone_band * sleep_dist / chisq;
	tables urban * timezone_band * fatigue_A2 / chisq;
	tables urban * timezone_band * eating_dist / chisq;
	tables urban * timezone_band * anhedonia / chisq;
	tables urban * timezone_band * mood_dist / chisq;
	tables urban * timezone_band * negative_thoughts / chisq;
	tables urban * timezone_band * concentration / chisq;
	tables urban * timezone_band * restless / chisq;
	tables urban * timezone_band * suicidal / chisq;	
run;
%mend TimezoneAnalyses_4;	/* ChiSquares of Urbanness */

/* Data preparation for Latitude and Longitude ANOVAs */

%macro TimezoneAnalyes_5;	/* extract subset -- not needed? */
/* Extract just the data needed for ANOVA analysis */
proc sql;
	create table sad_data_for_Anova as
	select timezone_band,
		timezone, 
		gmtoffset as GMTOffset,
		dst,
		zip_gis,
		dist_from_timezone_boundary,
		timezone_width,
		X, Y,
		X_1dg, Y_1dg,
		X_2_5dg, Y_2_5dg,
		X_5dg, Y_5dg,
		d_age,
		d_sex,
		sduravg,
		smidavg,
		seasonal,
		Ascore,
		Bscore,
		meq,
		circphas,
		seas_mdd,
		MajorDepression_Dx,
		SANS,
		d_BMI,
		workdays,
		majmin,
		seasonal_hypersom,
		season,
		hyperphagia,
		fatigue,
		sleep_dist,
		fatigue_A2,
		eating_dist,
		anhedonia,
		mood_dist,
		negative_thoughts,
		concentration,
		restless,
		suicidal,
		urban,
		eye_type,
		C1A_Nov, C2A_Nov, C3A_Nov, C4A_Nov, C5A_Nov, C6A_Nov, CscrNovA,
		C1A_Mar, C2A_Mar, C3A_Mar, C4A_Mar, C5A_Mar, C6A_Mar, CscrMarA
	from cet7.daylightsavings2
quit;

PROC EXPORT DATA= WORK.sad_data_for_Anova
            OUTFILE= "C:\data\cet-2005-04\analysis-0526\sad_data_for_Anova.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
%mend TimezoneAnalyes_5;	/* extract subset -- not needed? */

%macro Regressions_1;
/* Attempts at statistical analysis of this */
title 'Stepwise Logistic Regression of Major Depression Covariates';
proc logistic data=cet7.daylightsavings2;
	model MajorDepression_Dx (event='1')=seasonal Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type 
		Y*dist_from_timezone_boundary d_age*dist_from_timezone_boundary d_sex*dist_from_timezone_boundary
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;

title 'Stepwise Logistic Regression of Seasonal Major Depression Covariates';
proc logistic data=cet7.daylightsavings2;
	model seas_mdd (event='1')= Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type
		Y*dist_from_timezone_boundary d_age*dist_from_timezone_boundary d_sex*dist_from_timezone_boundary
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;

title 'Stepwise Logistic Regression of Seasonality Covariates';
proc logistic data=cet7.daylightsavings2;
	model seasonal (event='1')=Ascore Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type
		Y*dist_from_timezone_boundary d_age*dist_from_timezone_boundary d_sex*dist_from_timezone_boundary
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;

title 'Stepwise Linear Regression of Sleep Duration Covariates';
proc reg data=cet7.daylightsavings2;
	model sduravg =Ascore seasonal Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq GMTOffset eye_type
		Y*dist_from_timezone_boundary d_age*dist_from_timezone_boundary d_sex*dist_from_timezone_boundary
		/ selection=stepwise slentry=0.3 slstay=0.35 details;
run;

title 'Stepwise Linear Regression of Sleep Duration Covariates - Just latitude and Ascore';
proc reg data=cet7.daylightsavings2;
	model sduravg =Ascore Y dist_from_timezone_boundary
		/ selection=stepwise slentry=0.3 slstay=0.35 details;
run;

title 'Stepwise Logistic Regression of Self-Reported Hypersomnia Covariates';
proc logistic data=cet7.daylightsavings2;
	model seasonal_hypersom (event='1')=Ascore Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type
		Y*dist_from_timezone_boundary d_age*dist_from_timezone_boundary d_sex*dist_from_timezone_boundary
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;
%mend Regressions_1;


/* Code to create 2nd order correlations among input variables *
data test;
	input varname $;
	cards;
season
Y
dist_from_timezone_boundary 
d_age 
d_sex 
urban 
d_BMI 
workdays 
meq 
sduravg 
GMTOffset 
eye_type
;
run;

proc sql;
	create table test2 as
	select trim(a.varname) || '*' || trim(b.varname) as xprod
	from test a, test b
	where a.varname ne b.varname
	order by xprod;
quit;

proc print data=test2; run;
*/

/** Revised Analyses using all first order interactions */
/* Attempts at statistical analysis of this */
%macro Regressions_2;
title 'Stepwise Logistic Regression of Major Depression Covariates';
proc logistic data=cet7.daylightsavings2;
	model MajorDepression_Dx (event='1')=seasonal Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type

Y*d_BMI
Y*d_age
Y*d_sex
Y*dist_from_timezone_boundary
Y*eye_type
Y*GMTOffset
Y*meq
Y*sduravg
Y*seasonal
Y*urban
Y*workdays
d_BMI*Y
d_BMI*d_age
d_BMI*d_sex
d_BMI*dist_from_timezone_boundary
d_BMI*eye_type
d_BMI*GMTOffset
d_BMI*meq
d_BMI*sduravg
d_BMI*seasonal
d_BMI*urban
d_BMI*workdays
d_age*Y
d_age*d_BMI
d_age*d_sex
d_age*dist_from_timezone_boundary
d_age*eye_type
d_age*GMTOffset
d_age*meq
d_age*sduravg
d_age*seasonal
d_age*urban
d_age*workdays
d_sex*Y
d_sex*d_BMI
d_sex*d_age
d_sex*dist_from_timezone_boundary
d_sex*eye_type
d_sex*GMTOffset
d_sex*meq
d_sex*sduravg
d_sex*seasonal
d_sex*urban
d_sex*workdays
dist_from_timezone_boundary*Y
dist_from_timezone_boundary*d_BMI
dist_from_timezone_boundary*d_age
dist_from_timezone_boundary*d_sex
dist_from_timezone_boundary*meq
dist_from_timezone_boundary*sduravg
dist_from_timezone_boundary*seasonal
dist_from_timezone_boundary*urban
dist_from_timezone_boundary*workdays
eye_type*Y
eye_type*d_BMI
eye_type*d_age
eye_type*d_sex
eye_type*dist_from_timezone_boundary
eye_type*GMTOffset
eye_type*meq
eye_type*sduravg
eye_type*seasonal
eye_type*urban
eye_type*workdays
GMTOffset*Y
GMTOffset*d_BMI
GMTOffset*d_age
GMTOffset*d_sex
GMTOffset*dist_from_timezone_boundary
GMTOffset*eye_type
GMTOffset*meq
GMTOffset*sduravg
GMTOffset*seasonal
GMTOffset*urban
GMTOffset*workdays
meq*Y
meq*d_BMI
meq*d_age
meq*d_sex
meq*dist_from_timezone_boundary
meq*eye_type
meq*GMTOffset
meq*sduravg
meq*seasonal
meq*urban
meq*workdays
sduravg*Y
sduravg*d_BMI
sduravg*d_age
sduravg*d_sex
sduravg*dist_from_timezone_boundary
sduravg*eye_type
sduravg*GMTOffset
sduravg*meq
sduravg*seasonal
sduravg*urban
seasonal*d_BMI
seasonal*d_age
seasonal*d_sex
seasonal*dist_from_timezone_boundary
seasonal*eye_type
seasonal*GMTOffset
seasonal*meq
seasonal*sduravg
seasonal*urban
seasonal*workdays
urban*Y
urban*d_BMI
urban*d_age
urban*d_sex
urban*dist_from_timezone_boundary
urban*eye_type
urban*GMTOffset
urban*meq
urban*sduravg
urban*seasonal
urban*workdays
workdays*Y
workdays*d_BMI
workdays*d_age
workdays*d_sex
workdays*dist_from_timezone_boundary
workdays*eye_type
workdays*GMTOffset
workdays*meq
workdays*sduravg
workdays*seasonal
workdays*urban

		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;

title 'Stepwise Logistic Regression of Seasonal Major Depression Covariates';
proc logistic data=cet7.daylightsavings2;
	model seas_mdd (event='1')=Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type
Y*d_BMI
Y*d_age
Y*d_sex
Y*dist_from_timezone_boundary
Y*eye_type
Y*GMTOffset
Y*meq
Y*sduravg
Y*seasonal
Y*urban
Y*workdays
d_BMI*Y
d_BMI*d_age
d_BMI*d_sex
d_BMI*dist_from_timezone_boundary
d_BMI*eye_type
d_BMI*GMTOffset
d_BMI*meq
d_BMI*sduravg
d_BMI*seasonal
d_BMI*urban
d_BMI*workdays
d_age*Y
d_age*d_BMI
d_age*d_sex
d_age*dist_from_timezone_boundary
d_age*eye_type
d_age*GMTOffset
d_age*meq
d_age*sduravg
d_age*seasonal
d_age*urban
d_age*workdays
d_sex*Y
d_sex*d_BMI
d_sex*d_age
d_sex*dist_from_timezone_boundary
d_sex*eye_type
d_sex*GMTOffset
d_sex*meq
d_sex*sduravg
d_sex*seasonal
d_sex*urban
d_sex*workdays
dist_from_timezone_boundary*Y
dist_from_timezone_boundary*d_BMI
dist_from_timezone_boundary*d_age
dist_from_timezone_boundary*d_sex
dist_from_timezone_boundary*eye_type
dist_from_timezone_boundary*GMTOffset
dist_from_timezone_boundary*meq
dist_from_timezone_boundary*sduravg
dist_from_timezone_boundary*seasonal
dist_from_timezone_boundary*urban
dist_from_timezone_boundary*workdays
eye_type*Y
eye_type*d_BMI
eye_type*d_age
eye_type*d_sex
eye_type*dist_from_timezone_boundary
eye_type*GMTOffset
eye_type*meq
eye_type*sduravg
eye_type*seasonal
eye_type*urban
eye_type*workdays
GMTOffset*Y
GMTOffset*d_BMI
GMTOffset*d_age
GMTOffset*d_sex
GMTOffset*dist_from_timezone_boundary
GMTOffset*eye_type
GMTOffset*meq
GMTOffset*sduravg
GMTOffset*seasonal
GMTOffset*urban
GMTOffset*workdays
meq*Y
meq*d_BMI
meq*d_age
meq*d_sex
meq*dist_from_timezone_boundary
meq*eye_type
meq*GMTOffset
meq*sduravg
meq*seasonal
meq*urban
meq*workdays
sduravg*Y
sduravg*d_BMI
sduravg*d_age
sduravg*d_sex
sduravg*dist_from_timezone_boundary
sduravg*eye_type
sduravg*GMTOffset
sduravg*meq
sduravg*seasonal
sduravg*urban
sduravg*workdays
seasonal*Y
seasonal*d_BMI
seasonal*d_age
seasonal*d_sex
seasonal*dist_from_timezone_boundary
seasonal*eye_type
seasonal*GMTOffset
seasonal*meq
seasonal*sduravg
seasonal*urban
seasonal*workdays
urban*Y
urban*d_BMI
urban*d_age
urban*d_sex
urban*dist_from_timezone_boundary
urban*eye_type
urban*GMTOffset
urban*meq
urban*sduravg
urban*seasonal
urban*workdays
workdays*Y
workdays*d_BMI
workdays*d_age
workdays*d_sex
workdays*dist_from_timezone_boundary
workdays*eye_type
workdays*GMTOffset
workdays*meq
workdays*sduravg
workdays*seasonal
workdays*urban
	
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;

title 'Stepwise Logistic Regression of Seasonality Covariates';
proc logistic data=cet7.daylightsavings2;
	model seasonal (event='1')=Ascore seasonal Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type
Ascore*Y
Ascore*d_BMI
Ascore*d_age
Ascore*d_sex
Ascore*dist_from_timezone_boundary
Ascore*eye_type
Ascore*GMTOffset
Ascore*meq
Ascore*sduravg
Ascore*seasonal
Ascore*urban
Ascore*workdays
Y*Ascore
Y*d_BMI
Y*d_age
Y*d_sex
Y*dist_from_timezone_boundary
Y*eye_type
Y*GMTOffset
Y*meq
Y*sduravg
Y*seasonal
Y*urban
Y*workdays
d_BMI*Ascore
d_BMI*Y
d_BMI*d_age
d_BMI*d_sex
d_BMI*dist_from_timezone_boundary
d_BMI*eye_type
d_BMI*GMTOffset
d_BMI*meq
d_BMI*sduravg
d_BMI*seasonal
d_BMI*urban
d_BMI*workdays
d_age*Ascore
d_age*Y
d_age*d_BMI
d_age*d_sex
d_age*dist_from_timezone_boundary
d_age*eye_type
d_age*GMTOffset
d_age*meq
d_age*sduravg
d_age*seasonal
d_age*urban
d_age*workdays
d_sex*Ascore
d_sex*Y
d_sex*d_BMI
d_sex*d_age
d_sex*dist_from_timezone_boundary
d_sex*eye_type
d_sex*GMTOffset
d_sex*meq
d_sex*sduravg
d_sex*seasonal
d_sex*urban
d_sex*workdays
dist_from_timezone_boundary*Ascore
dist_from_timezone_boundary*Y
dist_from_timezone_boundary*d_BMI
dist_from_timezone_boundary*d_age
dist_from_timezone_boundary*d_sex
dist_from_timezone_boundary*eye_type
dist_from_timezone_boundary*GMTOffset
dist_from_timezone_boundary*meq
dist_from_timezone_boundary*sduravg
dist_from_timezone_boundary*seasonal
dist_from_timezone_boundary*urban
dist_from_timezone_boundary*workdays
eye_type*Ascore
eye_type*Y
eye_type*d_BMI
eye_type*d_age
eye_type*d_sex
eye_type*dist_from_timezone_boundary
eye_type*GMTOffset
eye_type*meq
eye_type*sduravg
eye_type*seasonal
eye_type*urban
eye_type*workdays
GMTOffset*Ascore
GMTOffset*Y
GMTOffset*d_BMI
GMTOffset*d_age
GMTOffset*d_sex
GMTOffset*dist_from_timezone_boundary
GMTOffset*eye_type
GMTOffset*meq
GMTOffset*sduravg
GMTOffset*seasonal
GMTOffset*urban
GMTOffset*workdays
meq*Ascore
meq*Y
meq*d_BMI
meq*d_age
meq*d_sex
meq*dist_from_timezone_boundary
meq*eye_type
meq*GMTOffset
meq*sduravg
meq*seasonal
meq*urban
meq*workdays
sduravg*Ascore
sduravg*Y
sduravg*d_BMI
sduravg*d_age
sduravg*d_sex
sduravg*dist_from_timezone_boundary
sduravg*eye_type
sduravg*GMTOffset
sduravg*meq
sduravg*seasonal
sduravg*urban
sduravg*workdays
seasonal*Ascore
seasonal*Y
seasonal*d_BMI
seasonal*d_age
seasonal*d_sex
seasonal*dist_from_timezone_boundary
seasonal*eye_type
seasonal*GMTOffset
seasonal*meq
seasonal*sduravg
seasonal*urban
seasonal*workdays
urban*Ascore
urban*Y
urban*d_BMI
urban*d_age
urban*d_sex
urban*dist_from_timezone_boundary
urban*eye_type
urban*GMTOffset
urban*meq
urban*sduravg
urban*seasonal
urban*workdays
workdays*Ascore
workdays*Y
workdays*d_BMI
workdays*d_age
workdays*d_sex
workdays*dist_from_timezone_boundary
workdays*eye_type
workdays*GMTOffset
workdays*meq
workdays*sduravg
workdays*seasonal
workdays*urban
	
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;

title 'Stepwise Logistic Regression of Self-Reported Hypersomnia Covariates';
proc logistic data=cet7.daylightsavings2;
	model seasonal_hypersom (event='1')=Ascore Y dist_from_timezone_boundary d_age d_sex urban d_BMI workdays meq sduravg GMTOffset eye_type
Ascore*Y
Ascore*d_BMI
Ascore*d_age
Ascore*d_sex
Ascore*dist_from_timezone_boundary
Ascore*eye_type
Ascore*GMTOffset
Ascore*meq
Ascore*sduravg
Ascore*urban
Ascore*workdays
Y*Ascore
Y*d_BMI
Y*d_age
Y*d_sex
Y*dist_from_timezone_boundary
Y*eye_type
Y*GMTOffset
Y*meq
Y*sduravg
Y*urban
Y*workdays
d_BMI*Ascore
d_BMI*Y
d_BMI*d_age
d_BMI*d_sex
d_BMI*dist_from_timezone_boundary
d_BMI*eye_type
d_BMI*GMTOffset
d_BMI*meq
d_BMI*sduravg
d_BMI*urban
d_BMI*workdays
d_age*Ascore
d_age*Y
d_age*d_BMI
d_age*d_sex
d_age*dist_from_timezone_boundary
d_age*eye_type
d_age*GMTOffset
d_age*meq
d_age*sduravg
d_age*urban
d_age*workdays
d_sex*Ascore
d_sex*Y
d_sex*d_BMI
d_sex*d_age
d_sex*dist_from_timezone_boundary
d_sex*eye_type
d_sex*GMTOffset
d_sex*meq
d_sex*sduravg
d_sex*urban
d_sex*workdays
dist_from_timezone_boundary*Ascore
dist_from_timezone_boundary*Y
dist_from_timezone_boundary*d_BMI
dist_from_timezone_boundary*d_age
dist_from_timezone_boundary*d_sex
dist_from_timezone_boundary*eye_type
dist_from_timezone_boundary*GMTOffset
dist_from_timezone_boundary*meq
dist_from_timezone_boundary*sduravg
dist_from_timezone_boundary*urban
dist_from_timezone_boundary*workdays
eye_type*Ascore
eye_type*Y
eye_type*d_BMI
eye_type*d_age
eye_type*d_sex
eye_type*dist_from_timezone_boundary
eye_type*GMTOffset
eye_type*meq
eye_type*sduravg
eye_type*urban
eye_type*workdays
GMTOffset*Ascore
GMTOffset*Y
GMTOffset*d_BMI
GMTOffset*d_age
GMTOffset*d_sex
GMTOffset*dist_from_timezone_boundary
GMTOffset*eye_type
GMTOffset*meq
GMTOffset*sduravg
GMTOffset*urban
GMTOffset*workdays
meq*Ascore
meq*Y
meq*d_BMI
meq*d_age
meq*d_sex
meq*dist_from_timezone_boundary
meq*eye_type
meq*GMTOffset
meq*sduravg
meq*urban
meq*workdays
sduravg*Ascore
sduravg*Y
sduravg*d_BMI
sduravg*d_age
sduravg*d_sex
sduravg*dist_from_timezone_boundary
sduravg*eye_type
sduravg*GMTOffset
sduravg*meq
sduravg*urban
sduravg*workdays
urban*Ascore
urban*Y
urban*d_BMI
urban*d_age
urban*d_sex
urban*dist_from_timezone_boundary
urban*eye_type
urban*GMTOffset
urban*meq
urban*sduravg
urban*seasonal
urban*workdays
workdays*Ascore
workdays*Y
workdays*d_BMI
workdays*d_age
workdays*d_sex
workdays*dist_from_timezone_boundary
workdays*eye_type
workdays*GMTOffset
workdays*meq
workdays*sduravg
workdays*seasonal
workdays*urban	
		/ selection=stepwise slentry=0.3 slstay=0.35 details lackfit;
run;
%mend Regressions_2;

/* 
6/3/2005 Conversation with Michael Terman

Within timezone effect and latitude effect - are they separable (independent)?  
Draw regression lines

Is there a latitude effect for 39 and above?
Can we graph interaction of Y*dist_from_timezone_boundary for Seasonality -- each separately 

[ ] Do we have a latitude effect from 39-50 (Y) [31% of cases are below 39 degrees] [correlation]
- What has strongest latitude effects?  E.g. winter depression, GSS, symptoms.
- Latitude by longitude interaction (need south for latitidude)

Is there different sleep duration? in winter and summer? YES
proc sort data=daylightsavings3; by season;
run;
proc corr data=daylightsavings3;
	by season;
*	by MajorDepression_Dx;
	with sduravg;
	var Y;
run;

proc corr data=daylightsavings3;
	with seas_mdd;
	var Y;
run;

proc corr data=daylightsavings3;
	with seas_mdd;
	var dist_from_timezone_boundary;
run;

proc corr data=daylightsavings3;
	where Y >= 39 and Y <= 50;
	with seasonal_hypersom;
	var dist_from_timezone_boundary;
run;


proc corr data=daylightsavings3;
	with Bscore;
	var Y;
run;

proc corr data=daylightsavings3;
	where Y >= 39 and Y <= 50; 
	with seasonal_hypersom;
	var dist_from_timezone_boundary;
run;



-- why isn't this showing an interaction effect?

[] What is the slope of the line (need regression constants - mx + b)
[ ] Do we have a timezone effect from 39-50 (dist_from_timezone_boundary) -- plot each of these as a function of degrees

[ ] Given 2.5 degree groupings to George, throwing out N below 20 (I can give it to him this way)

[ ] Get rid of higher order interactions?
[ ] Throw in all three way interactions just to see what it does

[ ] How do we predict impact of extending daylight savings time on incidence of depression? -- look at November and March
[ ] What is prevalence of Depressed mood in November and March? -- apply one hour later sunrise to current November / March
Multiply odds ratio (percent change) of people in western timezone_side X percent worse than they are now

[ ] Analyze BRFSS data? -- are they asking the right question

[ ] When looking at Phi - keep subscale components (Cscores for November)

*/
/* 6/24/05 discussion *
(1) Which sample are we using -- 
  (a) fallback is to use original sample (east-EST, west-EST)
  (b) add east-CST
  (c) whole country 39-50
  (d) whole country all latutides -- want to see interaction effect between Y and dist_from_timezone_boundary with no dist_from_timezone_boundary alone
  -- do we just want to include respondants from the winter season (may have stronger effects) -- only filter to Winter if no strong conclusions all year
(2) Dependent variables
	(a) seas_mdd (Bscore > 11, seasonalality, Major Depression)
	(b) Bscore
	(c) Ascore
	(d) A1-9
	(e) Dscore - atypical neurovegetative
(3) Independent variables
	(a) Y
	(b) dist_from_timezone_boundary
	(c) Y * dist_from_timezone_boundary?
	(d) sex
	(e) age
	(f) d_BMI
(4) Map of sample distribution -- e.g. 3D with spikes - secondary (bin at 1 degree level and just show counts of respondants).

*/

%macro MakeDataSubsets;
	data cet7.automeq_keepers; set cet7.automeq;
		where keep=1;
		/* create constants needed for regression, which can't seem to model them itself */
		Y_x_dist_from_tzb = Y*dist_from_timezone_boundary;
		BMI_x_dist_from_tzb = d_BMI*dist_from_timezone_boundary;
		age_x_dist_from_tzb = d_age*dist_from_timezone_boundary;
		sex_x_dist_from_tzb = d_sex*dist_from_timezone_boundary;
		BMI_x_Y = d_BMI*Y;
		age_x_Y = d_age*Y;
		sex_x_Y = d_sex*Y;
		season_x_BMI = season*d_BMI;
		season_x_BMI_x_Y = season*d_BMI*Y;
		season_x_BMI_x_dist_tzb = season*d_BMI*dist_from_timezone_boundary;		
		
		if (statecode = 'AK') then delete;	/* 7/1/05 - remove Alaska from analyses */
	run;
	
	data cet7.automeq_gt_39; set cet7.automeq_keepers;
		where Y >= 39;
	run;	
	
	data cet7.automeq_gt_39_winter; set cet7.automeq_gt_39;
		where season=1;
	run;	
	
	data cet7.automeq_winter; set cet7.automeq_keepers;
		where season=1;
	run;		
%mend MakeDataSubsets;

%macro RunAllRegressions;
	%RunRegressions(cet7.automeq_keepers);
	
	%RunRegressions(cet7.automeq_gt_39);
	
	%RunRegressions(cet7.automeq_gt_39_winter);
	
	%RunRegressions(cet7.automeq_winter);
	
%mend RunAllRegressions;

%macro RunRegressions(db);
	%put '=============================================';
	%put "======= START OF REGRESSIONS USING &db ========";
	%put '=============================================';
	%RunRegression(logistic, seasonal_hypersom, &db);
	%RunRegression(logistic, is_hypsomsr, &db);
	%RunRegression(logistic, D1, &db);
	%RunRegression(reg, hypsomsr, &db);
	
	%RunRegression(logistic, seas_mdd, &db);
	%RunRegression(reg, Bscore, &db);
	%RunRegression(reg, Dscore, &db);
	
/*	%RunRegression(reg, Ascore, &db); */
/*	%RunRegression(logistic, sleep_dist, &db); */
	/*
	%RunRegression(logistic, fatigue_A2, &db);
	%RunRegression(logistic, eating_dist, &db);
	%RunRegression(logistic, anhedonia, &db);
	%RunRegression(logistic, negative_thoughts, &db);
	%RunRegression(logistic, concentration, &db);
	%RunRegression(logistic, restless, &db);
	%RunRegression(logistic, suicidal, &db);
	%RunRegression(logistic, diff_awakening, &db);
	%RunRegression(logistic, carbo_eating, &db);
	%RunRegression(logistic, weight_gain, &db);
	*/
	
	%RunRegression(logistic,sleep_dist, &db);
	%RunRegression(logistic,fatigue_A2, &db);
	%RunRegression(logistic,eating_dist, &db);
	%RunRegression(logistic,anhedonia, &db);
	%RunRegression(logistic,mood_dist, &db);
	%RunRegression(logistic,negative_thoughts, &db);
	%RunRegression(logistic,concentration, &db);
	%RunRegression(logistic,restless, &db);
	%RunRegression(logistic,suicidal, &db);
	
	%RunRegression(logistic,hypersom_D1, &db);
	%RunRegression(logistic,diff_awakening, &db);
	%RunRegression(logistic,fatigue, &db);
	%RunRegression(logistic,evenings_worst, &db);
	%RunRegression(logistic,afternoon_slump, &db);
	%RunRegression(logistic,carb_craving, &db);
	%RunRegression(logistic,carbo_eating, &db);
	%RunRegression(logistic,carb_craving_in_pm, &db);
	%RunRegression(logistic,weight_gain, &db);
	
	%RunRegression(reg, smidavg, &db);
	%RunRegression(reg, meq, &db);
	%RunRegression(reg, sduravg, &db);
	%RunRegression(logistic, seas_min, &db);
	%RunRegression(logistic, majmin, &db);
	%RunRegression(logistic, seas_sans, &db);
	
	
	%put '=============================================';
	%put "======= END OF REGRESSIONS USING &db ========";
	%put '=============================================';
%mend RunRegressions;

%macro CreateTimezoneBins;
	/*
	proc sql;
		create table automeq_gt39_dtz_3dg as
		select 
			dtz_3dg,
			min(dist_from_timezone_boundary) as min_dtz,
			max(dist_from_timezone_boundary) as max_dtz,
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg
		from cet7.automeq_gt_39
		group by dtz_3dg
		order by dtz_3dg;
	quit;

	proc print data=automeq_gt39_dtz_3dg; run;
	*/
	
	proc sql;
		create table automeq_gt39_dtz_4dg as
		select 
			dtz_4dg,
			min(dist_from_timezone_boundary) as min_dtz,
			max(dist_from_timezone_boundary) as max_dtz,			
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(D1) as pct_D1_hypersom,
			avg(hypsomsr) as avg_winter_hypersom_months,
			avg(is_hypsomsr) as pct_atleast_1_hypersom_month,
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg		
		from cet7.automeq_gt_39
		group by dtz_4dg
		order by dtz_4dg;
	quit;

	proc print data=automeq_gt39_dtz_4dg; run;	
			
	PROC EXPORT DATA= automeq_gt39_dtz_4dg 
	            OUTFILE= "&cet7_06_lib\automeq_gt39_dtz_4dg.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;			
	
	/*
	proc sql;
		create table automeq_gt39_Y_2dg as
		select 
			Y_2dg,
			min(Y) as min_Y,
			max(Y) as max_Y,			
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(D1) as pct_D1_hypersom,
			avg(hypsomsr) as avg_winter_hypersom_months,
			avg(is_hypsomsr) as pct_atleast_1_hypersom_month,			
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg		
		from cet7.automeq_gt_39
		group by Y_2dg
		order by Y_2dg;
	quit;

	proc print data=automeq_gt39_Y_2dg; run;		
			
	PROC EXPORT DATA= automeq_gt39_Y_2dg 
	            OUTFILE= "&cet7_06_lib\automeq_gt39_Y_2dg.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;	
	*/
	
	proc sql;
		create table automeq_Y_4dg as
		select 
			Y_4dg,
			min(Y) as min_Y,
			max(Y) as max_Y,			
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(D1) as pct_D1_hypersom,
			avg(hypsomsr) as avg_winter_hypersom_months,
			avg(is_hypsomsr) as pct_atleast_1_hypersom_month,			
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg		
		from cet7.automeq_keepers
		group by Y_4dg
		order by Y_4dg;
	quit;

	proc print data=automeq_Y_4dg; run;		
			
	PROC EXPORT DATA= automeq_Y_4dg 
	            OUTFILE= "&cet7_06_lib\automeq_Y_4dg.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;								
	
	/* Also make bins for winter respondants only to show no variable in sleep midpoint, duration, and MEQ */

	proc sql;
		create table automeq_gt39_winter_dtz_4dg as
		select 
			dtz_4dg,
			min(dist_from_timezone_boundary) as min_dtz,
			max(dist_from_timezone_boundary) as max_dtz,			
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(D1) as pct_D1_hypersom,
			avg(hypsomsr) as avg_winter_hypersom_months,
			avg(is_hypsomsr) as pct_atleast_1_hypersom_month,			
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg		
		from cet7.automeq_gt_39_winter
		group by dtz_4dg
		order by dtz_4dg;
	quit;

	proc print data=automeq_gt39_winter_dtz_4dg; run;	
			
	PROC EXPORT DATA= automeq_gt39_winter_dtz_4dg 
	            OUTFILE= "&cet7_06_lib\automeq_gt39_winter_dtz_4dg.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;			

	proc sql;
		create table automeq_winter_Y_4dg as
		select 
			Y_4dg,
			min(Y) as min_Y,
			max(Y) as max_Y,			
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(D1) as pct_D1_hypersom,
			avg(hypsomsr) as avg_winter_hypersom_months,
			avg(is_hypsomsr) as pct_atleast_1_hypersom_month,			
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg		
		from cet7.automeq_winter
		group by Y_4dg
		order by Y_4dg;
	quit;

	proc print data=automeq_winter_Y_4dg; run;		
			
	PROC EXPORT DATA= automeq_winter_Y_4dg 
	            OUTFILE= "&cet7_06_lib\automeq_winter_Y_4dg.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;	
	
	proc sql;
		create table automeq_gt39_dtz_5dg as
		select 
			dtz_5dg,
			min(dist_from_timezone_boundary) as min_dtz,
			max(dist_from_timezone_boundary) as max_dtz,			
			count(*) as N,
			avg(seasonal_hypersom) as pct_seasonal_hypersom,
			avg(D1) as pct_D1_hypersom,
			avg(hypsomsr) as avg_winter_hypersom_months,
			avg(is_hypsomsr) as pct_atleast_1_hypersom_month,
			avg(seas_mdd) as pct_seas_mdd,
			avg(fatigue_A2) as pct_fatigue_A2,
			avg(eating_dist) as pct_eating_dist,
			avg(anhedonia) as pct_anhedonia,
			avg(negative_thoughts) as pct_guilt,
			avg(concentration) as pct_concentration,
			avg(restless) as pct_restless,
			avg(suicidal) as pct_suicidal,
			avg(diff_awakening) as pct_diff_awakening,
			avg(carbo_eating) as pct_carbo_eating,
			avg(weight_gain) as pct_weight_gain,
			avg(meq) as avg_meq,
			avg(smidavg) as avg_smidavg,
			avg(sduravg) as avg_sduravg		
		from cet7.automeq_gt_39
		group by dtz_5dg
		order by dtz_5dg;
	quit;

	proc print data=automeq_gt39_dtz_5dg; run;	
			
	PROC EXPORT DATA= automeq_gt39_dtz_5dg 
	            OUTFILE= "&cet7_06_lib\automeq_gt39_dtz_5dg.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;																			
		
%mend CreateTimezoneBins;

%macro RunRegression(type,dependent,db);
	%RunARegression(&type,&dependent,&db,sunrise);
	%RunARegression(&type,&dependent,&db,timezone);
%mend RunRegression;


%macro RunARegression(type,dependent,db,explanvar);
	%put '************************************************';
	%put "***** START &type REGRESSION of &dependent using &db *****";
	%if (&explanvar eq sunrise) %then %do;
		%put "****** Sunrise / Daylength *****";
	%end;
	%else %do;
		%put "****** Latitude / Distance From Timezone Boundary *****";
	%end;
	%put '************************************************';
	title "====== REGRESSION(&type) of &dependent vs. &explanvar using &db ======";
	proc &type data=&db;
		%if (&type eq logistic) %then %do;
			class d_sex;
			%if (&explanvar eq sunrise) %then %do;
				 units sunrise_local_win_solst = 1;
			%end;
			%else %do;
				units dist_from_timezone_boundary = 15 Y = 20;
			%end;
		%end;
		model &dependent 
			%if (&type eq logistic) %then %do;
				(event='1')
			%end;
			%if (&explanvar eq sunrise) %then %do; 
				= sunrise_local_win_solst
			%end;
			%else %do;
				= Y dist_from_timezone_boundary 
			%end;
			
			/* d_BMI */ d_age d_sex /* season */
			
			%if (&type eq logistic) %then %do;
				%if (&explanvar ne sunrise) %then Y*dist_from_timezone_boundary 
			%end;
			%else %do;
				%if (&explanvar ne sunrise) %then %do;
					Y_x_dist_from_tzb
				%end;
				/*
				BMI_x_dist_from_tzb
				age_x_dist_from_tzb 
				sex_x_dist_from_tzb
				BMI_x_Y
				age_x_Y
				sex_x_Y
				season_x_BMI
				season_x_BMI_x_Y
				season_x_BMI_x_dist_tzb	
				*/		
		%end;
			/ selection=stepwise slentry=0.3 slstay=0.35 details
			%if (&type eq logistic) %then lackfit rsquare stb clodds=wald;
				;
	run;
	%put '************************************************';
	%put "***** END &type REGRESSION of &dependent using &db ****";
	%if (&explanvar eq sunrise) %then %do;
		%put "****** Sunrise / Daylength *****";
	%end;
	%else %do;
		%put "****** Latitude / Distance From Timezone Boundary *****";
	%end;	
	%put '************************************************';	
%mend RunARegression;


%macro RunARegression2(type,dependent,db,explanvar);
	%put '************************************************';
	%put "***** START &type REGRESSION of &dependent using &db *****";
	%if (&explanvar eq sunrise) %then %do;
		%put "****** Sunrise / Daylength *****";
	%end;
	%else %do;
		%put "****** Latitude / Distance From Timezone Boundary *****";
	%end;
	%put '************************************************';
	title "====== REGRESSION(&type) of &dependent vs. &explanvar using &db ======";
	proc &type data=&db;
		by d_sex;
		%if (&type eq logistic) %then %do;
			%if (&explanvar eq sunrise) %then %do;
				 units sunrise_local_win_solst = 1;
			%end;
			%else %do;
				units dist_from_timezone_boundary = 15 Y = 20;
			%end;
		%end;
		model &dependent 
			%if (&type eq logistic) %then %do;
				(event='1')
			%end;
			%if (&explanvar eq sunrise) %then %do; 
				= sunrise_local_win_solst
			%end;
			%else %do;
				= Y dist_from_timezone_boundary 
			%end;
			
			/* d_BMI */ d_age /* season */
			
			%if (&type eq logistic) %then %do;
				%if (&explanvar ne sunrise) %then Y*dist_from_timezone_boundary 
			%end;
			%else %do;
				%if (&explanvar ne sunrise) %then %do;
					Y_x_dist_from_tzb
				%end;
				/*
				BMI_x_dist_from_tzb
				age_x_dist_from_tzb 
				sex_x_dist_from_tzb
				BMI_x_Y
				age_x_Y
				sex_x_Y
				season_x_BMI
				season_x_BMI_x_Y
				season_x_BMI_x_dist_tzb	
				*/		
		%end;
			/ selection=stepwise slentry=0.3 slstay=0.35 details
			%if (&type eq logistic) %then lackfit rsquare stb clodds=wald;
				;
	run;
	%put '************************************************';
	%put "***** END &type REGRESSION of &dependent using &db ****";
	%if (&explanvar eq sunrise) %then %do;
		%put "****** Sunrise / Daylength *****";
	%end;
	%else %do;
		%put "****** Latitude / Distance From Timezone Boundary *****";
	%end;	
	%put '************************************************';	
%mend RunARegression2;



%macro doAll;
%SetInitParams;

/*
%ProcessAutoMeqData;
%MakeDataSubsets;
%RunAllRegressions;
%CreateTimezoneBins;
%Analyses_20050715;
%ComputePhases;
*/

%mend doAll;


/* Notes from June 28, 2005 *

[ ] Line - show for only 39 and above (symptoms vs. distance_from_timezone) - binned at 1 degree - to see prevalance of symptom vs. distance.

How do we interpret the goodness of fit test?

[ ] Table of regression equations e.g. Depression = mx + b -- ideally for all three samples (automeq, automeq_39, winter_only)
[ ] Table of p values for each parameter for each equation
[ ] Total R-squared?  -- how much variance is predicted by model?
[ ] Paragarph re criteria for inclusion/exclusion within a stepwise regression (e.g. which parameters used for retain/omit)
[ ] Map of respondants from George with 3D distribution?  2D map is good too (at 2.5 degrees) (just Ns at those degrees)

*/

/* Notes from July 15, 2005 *
(1) Graph - show ramp function repeated over timezones?
(2) can we retain data - what are minimum variables we need? - what about dropping MEQ criteria?  Can we regain any? - NO
(3) Validating data against SPARC data?  How do I get it?  How do we see seasonality in those data?  e.g. springtime peak in suicide (but no clear proof that SAD)
(4) Do other states have data like these so that we can see timezone effect? -- not enough geography in NYS? - Via CDC?
(5) [ ] Are there national databases on suicide incidence? Ask Madeline Gould  543-5329
(6) Graph of patterns of worst months - there is a small phase difference
(7) Re-do phase analyses for Sleep (Part C-4), and energy (Part C-5)
*/

/* Notes from July 21, 2005 *
[ ] For binning at 5 degrees, have the bins be 2.5, 7.5, and 12.5, dropping all cases above 15 degrees

[ ] Use TKDiff to analyze comparison between 
C:/cvs2/Dialogix/cet_analysis/SLTBR-2005-analysis-rev3-withoutAlaska.log and 
C:/cvs2/Dialogix/cet_analysis/SLTBR-2005-analysis-rev4-withoutAlaska.log
*/

%macro Analyses_20050715;
data PIDS_3_data; set cet7.automeq_keepers;
	JanDiff = CscrJanB - CscrJanA;
	FebDiff = CscrFebB - CscrFebA;
	MarDiff = CscrMarB - CscrMarA;
	AprDiff = CscrAprB - CscrAprA;
	MayDiff = CscrMayB - CscrMayA;
	JunDiff = CscrJunB - CscrJunA;
	JulDiff = CscrJulB - CscrJulA;
	AugDiff = CscrAugB - CscrAugA;
	SepDiff = CscrSepB - CscrSepA;
	OctDiff = CscrOctB - CscrOctA;
	NovDiff = CscrNovB - CscrNovA;
	DecDiff = CscrDecB - CscrDecA;
	
	Jan4Diff = C4B_Jan - C4A_Jan;
	Feb4Diff = C4B_Feb - C4A_Feb;
	Mar4Diff = C4B_Mar - C4A_Mar;
	Apr4Diff = C4B_Apr - C4A_Apr;
	May4Diff = C4B_May - C4A_May;
	Jun4Diff = C4B_Jun - C4A_Jun;
	Jul4Diff = C4B_Jul - C4A_Jul;
	Aug4Diff = C4B_Aug - C4A_Aug;
	Sep4Diff = C4B_Sep - C4A_Sep;
	Oct4Diff = C4B_Oct - C4A_Oct;
	Nov4Diff = C4B_Nov - C4A_Nov;
	Dec4Diff = C4B_Dec - C4A_Dec;	
	
	Jan5Diff = C5B_Jan - C5A_Jan;
	Feb5Diff = C5B_Feb - C5A_Feb;
	Mar5Diff = C5B_Mar - C5A_Mar;
	Apr5Diff = C5B_Apr - C5A_Apr;
	May5Diff = C5B_May - C5A_May;
	Jun5Diff = C5B_Jun - C5A_Jun;
	Jul5Diff = C5B_Jul - C5A_Jul;
	Aug5Diff = C5B_Aug - C5A_Aug;
	Sep5Diff = C5B_Sep - C5A_Sep;
	Oct5Diff = C5B_Oct - C5A_Oct;
	Nov5Diff = C5B_Nov - C5A_Nov;
	Dec5Diff = C5B_Dec - C5A_Dec;		
	
	/* 10/12/2005 -- These are Feel Best - Feel Worst */
	Jan1Diff = C1B_Jan - C1A_Jan;
	Feb1Diff = C1B_Feb - C1A_Feb;
	Mar1Diff = C1B_Mar - C1A_Mar;
	Apr1Diff = C1B_Apr - C1A_Apr;
	May1Diff = C1B_May - C1A_May;
	Jun1Diff = C1B_Jun - C1A_Jun;
	Jul1Diff = C1B_Jul - C1A_Jul;
	Aug1Diff = C1B_Aug - C1A_Aug;
	Sep1Diff = C1B_Sep - C1A_Sep;
	Oct1Diff = C1B_Oct - C1A_Oct;
	Nov1Diff = C1B_Nov - C1A_Nov;
	Dec1Diff = C1B_Dec - C1A_Dec;		
	
	if (d_age < 22) then delete;	/* remove children */
	if (d_age > 70) then delete;	/* remove elderly */
	where keep=1;
	/* keep restricted latitude band
	where (Y >= 39 and Y <= 50 and keep=1);	
	*/
run;	

data PIDS_3_data_depressed; set PIDS_3_data;
	where (seas_mdd = 1 or majmin = 1 or seas_min = 1 or seas_sans = 1);
run;

/* Is there a phase difference between east and west? */
proc sql;
	create table PIDS_3 as
	select 
		AprDiff /6 as avgApr,
		MayDiff /6 as avgMay,
		JunDiff /6 as avgJun,
		JulDiff /6 as avgJul,
		AugDiff /6 as avgAug,
		SepDiff /6 as avgSep,
		OctDiff /6 as avgOct,
		NovDiff /6 as avgNov,
		DecDiff /6 as avgDec,
		JanDiff /6 as avgJan,
		FebDiff /6 as avgFeb,
		MarDiff /6 as avgMar,
		AprDiff /6 as avgApr2
 	from PIDS_3_data
 	where AprDiff ne . and hasWinterSeasonality = 1
	;
quit;

/* Find inflection point - from when switch from positive to negative */
data PIDS_3; set PIDS_3;
	if (JulDiff > 0 and AugDiff < 0) then date_worsens = mdy(7,15,2005);
	else if (AugDiff > 0 and SepDiff < 0) then month_worsens = mdy(8,15,2005);
	else if (SepDiff > 0 and OctDiff < 0) then month_worsens = mdy(9,15,2005);
	else if (OctDiff > 0 and NovDiff < 0) then month_worsens = mdy(10,15,2005);
	else if (NovDiff > 0 and DecDiff < 0) then month_worsens = mdy(11,15,2005);
	else if (DecDiff > 0 and JanDiff < 0) then month_worsens = mdy(12,15,2005);
	else if (JanDiff > 0 and FebDiff < 0) then month_worsens = mdy(1,15,2005);
	else if (FebDiff > 0 and MarDiff < 0) then month_worsens = mdy(2,15,2005);
	else if (MarDiff > 0 and AprDiff < 0) then month_worsens = mdy(3,15,2005);
	else if (AprDiff > 0 and JuDiff < 0) then month_worsens = mdy(4,15,2005);
	else if (JunDiff > 0 and JulDiff < 0) then month_worsens = mdy(5,15,2005);
run;

proc sql;
	create table PIDS_3 as
	select 
		timezone_side,
		count(*) as N,
		avg(AprDiff) / 6 as avgApr,
		avg(MayDiff) / 6 as avgMay,
		avg(JunDiff) / 6 as avgJun,
		avg(JulDiff) / 6 as avgJul,
		avg(AugDiff) / 6 as avgAug,
		avg(SepDiff) / 6 as avgSep,
		avg(OctDiff) / 6 as avgOct,
		avg(NovDiff) / 6 as avgNov,
		avg(DecDiff) / 6 as avgDec,
		avg(JanDiff) / 6 as avgJan,
		avg(FebDiff) / 6 as avgFeb,
		avg(MarDiff) / 6 as avgMar,
		avg(AprDiff) / 6 as avgApr2
 	from PIDS_3_data
 	group by timezone_side
	;
quit;

PROC EXPORT DATA= work.PIDS_3 
            OUTFILE= "&cet7_06_lib\Pids3_diff.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

proc sql;
	create table PIDS_3all as
	select distinct
		count(*) as N,
		avg(AprDiff) / 6 as avgApr,
		avg(MayDiff) / 6 as avgMay,
		avg(JunDiff) / 6 as avgJun,
		avg(JulDiff) / 6 as avgJul,
		avg(AugDiff) / 6 as avgAug,
		avg(SepDiff) / 6 as avgSep,
		avg(OctDiff) / 6 as avgOct,
		avg(NovDiff) / 6 as avgNov,
		avg(DecDiff) / 6 as avgDec,
		avg(JanDiff) / 6 as avgJan,
		avg(FebDiff) / 6 as avgFeb,
		avg(MarDiff) / 6 as avgMar,
		avg(AprDiff) / 6 as avgApr2
 	from PIDS_3_data
	;
quit;

PROC EXPORT DATA= work.PIDS_3all 
            OUTFILE= "&cet7_06_lib\Pids3all_diff.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

/* Is it better to look just at the bad winter months? */
proc sql;
	create table PIDS_3worse as
	select 
		timezone_side,
		count(*) as N,
		avg(CscrAprA) / 6 as avgApr,
		avg(CscrMayA) / 6 as avgMay,
		avg(CscrJunA) / 6 as avgJun,
		avg(CscrJulA) / 6 as avgJul,
		avg(CscrAugA) / 6 as avgAug,
		avg(CscrSepA) / 6 as avgSep,
		avg(CscrOctA) / 6 as avgOct,
		avg(CscrNovA) / 6 as avgNov,
		avg(CscrDecA) / 6 as avgDec,
		avg(CscrJanA) / 6 as avgJan,
		avg(CscrFebA) / 6 as avgFeb,
		avg(CscrMarA) / 6 as avgMar,
		avg(CscrAprA) / 6 as avgApr2
 	from PIDS_3_data
 	group by timezone_side
	;
quit;

PROC EXPORT DATA= work.PIDS_3worse 
            OUTFILE= "&cet7_06_lib\Pids3_worse_diff.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

proc sql;
	create table PIDS_3_sleep as
	select 
		timezone_side,
		count(*) as N,
		avg(Apr4Diff) / 6 as avgApr,
		avg(May4Diff) / 6 as avgMay,
		avg(Jun4Diff) / 6 as avgJun,
		avg(Jul4Diff) / 6 as avgJul,
		avg(Aug4Diff) / 6 as avgAug,
		avg(Sep4Diff) / 6 as avgSep,
		avg(Oct4Diff) / 6 as avgOct,
		avg(Nov4Diff) / 6 as avgNov,
		avg(Dec4Diff) / 6 as avgDec,
		avg(Jan4Diff) / 6 as avgJan,
		avg(Feb4Diff) / 6 as avgFeb,
		avg(Mar4Diff) / 6 as avgMar,
		avg(Apr4Diff) / 6 as avgApr2
 	from PIDS_3_data
 	group by timezone_side
	;
quit;

PROC EXPORT DATA= work.PIDS_3_sleep 
            OUTFILE= "&cet7_06_lib\Pids3_sleep_diff.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

/*
proc sql;
	create table PIDS_3_1 as
	select 
		"Best-Worst" as Dependent,
		"Distance From Timezone" as Independent,
		bin2_dtz,
		count(*) as N,
		avg(Apr1Diff) as avgApr,
		avg(May1Diff) as avgMay,
		avg(Jun1Diff) as avgJun,
		avg(Jul1Diff) as avgJul,
		avg(Aug1Diff) as avgAug,
		avg(Sep1Diff) as avgSep,
		avg(Oct1Diff) as avgOct,
		avg(Nov1Diff) as avgNov,
		avg(Dec1Diff) as avgDec,
		avg(Jan1Diff) as avgJan,
		avg(Feb1Diff) as avgFeb,
		avg(Mar1Diff) as avgMar,
		avg(Apr1Diff) as avgApr2
 	from PIDS_3_data
 	group by bin2_dtz
	;
quit;

proc sql;
	create table PIDS_3_2 as
	select 
		"Worst" as Dependent,
		"Distance From Timezone" as Independent,
		bin2_dtz,
		count(*) as N,
		avg(C1A_Apr) as avgApr,
		avg(C1A_May) as avgMay,
		avg(C1A_Jun) as avgJun,
		avg(C1A_Jul) as avgJul,
		avg(C1A_Aug) as avgAug,
		avg(C1A_Sep) as avgSep,
		avg(C1A_Oct) as avgOct,
		avg(C1A_Nov) as avgNov,
		avg(C1A_Dec) as avgDec,
		avg(C1A_Jan) as avgJan,
		avg(C1A_Feb) as avgFeb,
		avg(C1A_Mar) as avgMar,
		avg(C1A_Apr) as avgApr2
 	from PIDS_3_data
 	group by bin2_dtz
	;
quit;

proc sql;
	create table PIDS_3_3 as
	select 
		"Best-Worst" as Dependent,
		"Sunrise Time" as Independent,
		bin2_sunrise,
		count(*) as N,
		avg(Apr1Diff) as avgApr,
		avg(May1Diff) as avgMay,
		avg(Jun1Diff) as avgJun,
		avg(Jul1Diff) as avgJul,
		avg(Aug1Diff) as avgAug,
		avg(Sep1Diff) as avgSep,
		avg(Oct1Diff) as avgOct,
		avg(Nov1Diff) as avgNov,
		avg(Dec1Diff) as avgDec,
		avg(Jan1Diff) as avgJan,
		avg(Feb1Diff) as avgFeb,
		avg(Mar1Diff) as avgMar,
		avg(Apr1Diff) as avgApr2
 	from PIDS_3_data
 	group by bin2_sunrise
	;
quit;

proc sql;
	create table PIDS_3_4 as
	select 
		"Worst" as Dependent,
		"Sunrise Time" as Independent,
		bin2_sunrise,
		count(*) as N,
		avg(C1A_Apr) as avgApr,
		avg(C1A_May) as avgMay,
		avg(C1A_Jun) as avgJun,
		avg(C1A_Jul) as avgJul,
		avg(C1A_Aug) as avgAug,
		avg(C1A_Sep) as avgSep,
		avg(C1A_Oct) as avgOct,
		avg(C1A_Nov) as avgNov,
		avg(C1A_Dec) as avgDec,
		avg(C1A_Jan) as avgJan,
		avg(C1A_Feb) as avgFeb,
		avg(C1A_Mar) as avgMar,
		avg(C1A_Apr) as avgApr2
 	from PIDS_3_data
 	group by bin2_sunrise
	;
quit;

proc sql;
	create table PIDS_3_5 as
	select 
		"Best-Worst" as Dependent,
		"Latitude" as Independent,
		bin2_Y,
		count(*) as N,
		avg(Apr1Diff) as avgApr,
		avg(May1Diff) as avgMay,
		avg(Jun1Diff) as avgJun,
		avg(Jul1Diff) as avgJul,
		avg(Aug1Diff) as avgAug,
		avg(Sep1Diff) as avgSep,
		avg(Oct1Diff) as avgOct,
		avg(Nov1Diff) as avgNov,
		avg(Dec1Diff) as avgDec,
		avg(Jan1Diff) as avgJan,
		avg(Feb1Diff) as avgFeb,
		avg(Mar1Diff) as avgMar,
		avg(Apr1Diff) as avgApr2
 	from PIDS_3_data
 	group by bin2_Y
	;
quit;

proc sql;
	create table PIDS_3_6 as
	select 
		"Worst" as Dependent,
		"Latitude" as Independent,
		bin2_Y,
		count(*) as N,
		avg(C1A_Apr) as avgApr,
		avg(C1A_May) as avgMay,
		avg(C1A_Jun) as avgJun,
		avg(C1A_Jul) as avgJul,
		avg(C1A_Aug) as avgAug,
		avg(C1A_Sep) as avgSep,
		avg(C1A_Oct) as avgOct,
		avg(C1A_Nov) as avgNov,
		avg(C1A_Dec) as avgDec,
		avg(C1A_Jan) as avgJan,
		avg(C1A_Feb) as avgFeb,
		avg(C1A_Mar) as avgMar,
		avg(C1A_Apr) as avgApr2
 	from PIDS_3_data
 	group by bin2_Y
	;
quit;

data PIDS_3_all; set PIDS_3_1 PIDS_3_2 PIDS_3_3 PIDS_3_4 PIDS_3_5 PIDS_3_6;
run;

PROC EXPORT DATA= work.PIDS_3_all 
            OUTFILE= "&cet7_06_lib\PIDS_3_all.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/

%mend Analyses_20050715; 

/* 10/12/2005 - Generate files needed for analysis */
%macro ComputePhases;
	/* %Analyses_20050715; */
	
	%global phase_count;
	%let phase_count = 0;

	%ComputePhase("Distance from Timezone","Num Good - Num Bad",bin2_dtz,2,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Distance from Timezone","Feel Best-Worst",bin2_dtz,2,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Distance from Timezone","Worst",bin2_dtz,2,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Sunrise Time","Num Good - Num Bad",bin2_sunrise,2,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Sunrise Time","Feel Best-Worst",bin2_sunrise,2,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Sunrise Time","Worst",bin2_sunrise,2,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Latitude","Num Good - Num Bad",bin2_Y,2,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Latitude","Feel Best-Worst",bin2_Y,2,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Latitude","Worst",bin2_Y,2,1,monthly_pre=C1A_,monthly_suffix=);
	
	%ComputePhase("Distance from Timezone","Num Good - Num Bad",bin3_dtz,3,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Distance from Timezone","Feel Best-Worst",bin3_dtz,3,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Distance from Timezone","Worst",bin3_dtz,3,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Distance from Timezone","Num Good - Num Bad",bin3a_dtz,3,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Distance from Timezone","Feel Best-Worst",bin3a_dtz,3,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Distance from Timezone","Worst",bin3a_dtz,3,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Sunrise Time","Num Good - Num Bad",bin3_sunrise,3,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Sunrise Time","Feel Best-Worst",bin3_sunrise,3,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Sunrise Time","Worst",bin3_sunrise,3,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Latitude","Num Good - Num Bad",bin3_Y,3,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Latitude","Feel Best-Worst",bin3_Y,3,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Latitude","Worst",bin3_Y,3,1,monthly_pre=C1A_,monthly_suffix=);
	
	%ComputePhase("Distance from Timezone","Num Good - Num Bad",bin4_dtz,4,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Distance from Timezone","Feel Best-Worst",bin4_dtz,4,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Distance from Timezone","Worst",bin4_dtz,4,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Distance from Timezone","Num Good - Num Bad",bin4a_dtz,4,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Distance from Timezone","Feel Best-Worst",bin4a_dtz,4,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Distance from Timezone","Worst",bin4a_dtz,4,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Sunrise Time","Num Good - Num Bad",bin4_sunrise,4,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Sunrise Time","Feel Best-Worst",bin4_sunrise,4,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Sunrise Time","Worst",bin4_sunrise,4,1,monthly_pre=C1A_,monthly_suffix=);
	%ComputePhase("Latitude","Num Good - Num Bad",bin4_Y,4,6,monthly_pre=,monthly_suffix=Diff);
	%ComputePhase("Latitude","Feel Best-Worst",bin4_Y,4,1,monthly_pre=,monthly_suffix=1Diff);
	%ComputePhase("Latitude","Worst",bin4_Y,4,1,monthly_pre=C1A_,monthly_suffix=);	
	
	/* create table merging data from all analyses just created */
	%let _count = 1;
	data PhaseAnalysis_all; set 
		%do %while(&_count <= &phase_count);
			PhaseAnalysis_&_count
			
			%let _count = %eval(&_count + 1);
		%end;	
		;
	run;
	
	%let _count = 1;
	proc sql;
		%do %while(&_count <= &phase_count);
			drop table PhaseAnalysis_&_count;
			%let _count = %eval(&_count + 1);
		%end;	
	quit;

	PROC EXPORT DATA= work.PhaseAnalysis_all
	            OUTFILE= "&cet7_06_lib\PhaseAnalysis_all.xls" 
	            DBMS=EXCEL2000 REPLACE;
	RUN;

%mend ComputePhases;

%macro ComputePhase(independent,dependent,binner,numbins,divisor,monthly_pre=,monthly_suffix=);
	%let phase_count = %eval(&phase_count + 1);

	proc sql;
		create table PhaseAnalysis_&phase_count.a as
		select 
			"All Subjects" as Sample,
			&independent as Independent,
			&dependent as Dependent,
			&numbins as NumBins,
			&binner as BinLabel,
			&divisor as Divisor,
			count(*) as N,
			avg(&monthly_pre.Apr&monthly_suffix.) / &divisor as Apr,
			avg(&monthly_pre.May&monthly_suffix.) / &divisor as May,
			avg(&monthly_pre.Jun&monthly_suffix.) / &divisor as Jun,
			avg(&monthly_pre.Jul&monthly_suffix.) / &divisor as Jul,
			avg(&monthly_pre.Aug&monthly_suffix.) / &divisor as Aug,
			avg(&monthly_pre.Sep&monthly_suffix.) / &divisor as Sep,
			avg(&monthly_pre.Oct&monthly_suffix.) / &divisor as Oct,
			avg(&monthly_pre.Nov&monthly_suffix.) / &divisor as Nov,
			avg(&monthly_pre.Dec&monthly_suffix.) / &divisor as Dec,
			avg(&monthly_pre.Jan&monthly_suffix.) / &divisor as Jan,
			avg(&monthly_pre.Feb&monthly_suffix.) / &divisor as Feb,
			avg(&monthly_pre.Mar&monthly_suffix.) / &divisor as Mar,
			avg(&monthly_pre.Apr&monthly_suffix.) / &divisor as Apr2
	 	from PIDS_3_data
	 	group by &binner
		;
	quit;
	
	proc sql;
		create table PhaseAnalysis_&phase_count.b as
		select 
			"Only Depressed" as Sample,
			&independent as Independent,
			&dependent as Dependent,
			&numbins as NumBins,
			&binner as BinLabel,
			&divisor as Divisor,
			count(*) as N,
			avg(&monthly_pre.Apr&monthly_suffix.) / &divisor as Apr,
			avg(&monthly_pre.May&monthly_suffix.) / &divisor as May,
			avg(&monthly_pre.Jun&monthly_suffix.) / &divisor as Jun,
			avg(&monthly_pre.Jul&monthly_suffix.) / &divisor as Jul,
			avg(&monthly_pre.Aug&monthly_suffix.) / &divisor as Aug,
			avg(&monthly_pre.Sep&monthly_suffix.) / &divisor as Sep,
			avg(&monthly_pre.Oct&monthly_suffix.) / &divisor as Oct,
			avg(&monthly_pre.Nov&monthly_suffix.) / &divisor as Nov,
			avg(&monthly_pre.Dec&monthly_suffix.) / &divisor as Dec,
			avg(&monthly_pre.Jan&monthly_suffix.) / &divisor as Jan,
			avg(&monthly_pre.Feb&monthly_suffix.) / &divisor as Feb,
			avg(&monthly_pre.Mar&monthly_suffix.) / &divisor as Mar,
			avg(&monthly_pre.Apr&monthly_suffix.) / &divisor as Apr2
	 	from PIDS_3_data_depressed
	 	group by &binner
		;
	quit;	
	
	data PhaseAnalysis_&phase_count; set PhaseAnalysis_&phase_count.a PhaseAnalysis_&phase_count.b;
	run;
	
	proc sql;
		drop table PhaseAnalysis_&phase_count.a;
		drop table PhaseAnalysis_&phase_count.b;
	quit;
%mend ComputePhase;

%macro Sunrise(latitude,longitud,timezone,date,label,isdst);
/* This may inappropriately set daylight savings time for regions which don't use it */
  radian = 57.29578;
  pi = 3.1415926536;
  format sunrise_&label sunset_&label daylength_&label tod.;
  format daylength_&label hhmm7.;
  array sun{0:1} sunset_&label sunrise_&label;
  phi=&latitude/radian;
  lambda=&longitud/15;
  
  n=&date-intnx('year',&date,0)+1;
  if (dst = 'Y') then do;
	  select (month(&date));
	    when (4)
	      _dst=&date>=intnx('month',&date,0)-weekday(intnx('month',&date,0))+8;
	    when (10)
	      _dst=&date<intnx('month',&date,1)-weekday(intnx('month',&date,1))+1;
	    otherwise _dst=5<=month(&date)<=9;
	  end;
	end;
	else do;
		_dst = 0;
	end;
	
	if (&isdst = 0) then _dst = 0;
	
  do s=0 to 1;
    t=n+(18-12*s-lambda)/24;
    m=(.9856*t-3.289)/radian;
    l=m+(1.916*sin(m)+.02*sin(2*m)+282.634)/radian;
    delta=.39782*sin(l);
    sun{s}=3600*(mod(24*((1-2*s)*arcos((-.01454-
    sin(delta)*sin(phi))/(cos(delta)*cos(phi)))/(2*pi)+s)+atan(.91746
    *tan(l))*radian/15+12*(mod(floor(l*2/pi)+4,4)
    in (1,2))-.06571*t-6.622-lambda+&timezone+_dst+48,24)-12*(1-s));
  end;
  
  sunset_&label = sunset_&label + (12 * 60 * 60);
  
  daylength_&label = sunset_&label - sunrise_&label;
  
  if (sunset_&label > sunrise_&label) then do;
		daylength_&label = sunset_&label - sunrise_&label;
	end;
	else do;
		daylength_&label = (sunset_&label + (24 * 60 * 60)) - sunrise_&label;
	end;
  
  drop radian pi phi lambda n t m l s delta _dst;
  
%mend Sunrise;

/* Notes from 7/27/2004
(1) When is the onset of the symptoms (trigger point) - "break point analysis" of 3 month intervals and test when get first non-zero slope
	(a) use mid-point of month in which have first worsening and use that as date for sunrise calculation
	(b) use average mid-point for all population who reported worsening as the average - is this independent?
(3) Consider doing breakpoint analysis on mood instead of carb craving?
(4) Do trigger point analysis of each of the symptoms to detect the time-course of the worsening.
(6) Give George the zip vs. sunrise time and day length - Requires good Sunrisetime calculation - could bad correlation be due to daylight time?
(7) What is delay in sunrise if within valley in rocky mountains -- how much of a difference? - For discussion section 
(9) Send zip code data to Steve -- fairhur@pi.cpmc.columbia.edu so can compute sunrise/sunset times. (zip and latitude/longitude?)
(10) Can I compute better sunrise time be re-engineering the algorithm they mentioned? - NO - didn't work
*/

/* Notes from 8/19/2005
(1) Use regression equation to calculate behaviors at each latitude/longidue and use Geoerge's colored map to plot expected values
	(1) must merge with zip code data to get timezone at that location
	(2) For George's map - use heat gradient color standard for the light gradient so can clearly read actual values
	(3) Plots - (a) Sunrise Map Winter (b) Sunrise map Summer (c) Behavior (feeling worst) Winter (d) %worst Summar [2 columns/rows]
		- three month band of summer/winter, centered on the solstice
	(4) Worst vs. best month (Feb vs. June) - no, winter/summer solstice
	(5) Get rid of timezone boundary line so don't have approximation problem
	(6) [DONE ] Email Steve lat/long vs. zip on winter and summer solstice
	 (want 1 degree steps in lat/long that span the US - let him do this and generate tsv file)
	 (I'll join this with zip code data and compute the regression equations => Give final file to George)
(2) Email Michael C:\data\cet_200506\analysis\Pids3all_diff.xls
(3) Is there a revser latatide cline of summer worse from south-north -- use CscoreA >= 1 (about 250 people) [validates the notion that summer depression has reverse characteristicss]
	NO:
			data test; set cet7.automeq_keepers;
			if (CscrJulA >= 1) then bad_summer = 1; else bad_summer=0;
			
			keep bad_summer latbinmd;
		run;
		
		proc freq data=test;
			tables bad_summer * latbinmd / chisq;
		run;
(4)Can Vesna's clerk process the SLTBR-2005-analysis file to extract the Odds ratio of an hour of change [NO - use Julie]
	Sunrise, Latitude, Distance from Timezone -- ideally with confidence intervals and p values
	Summer Solstice:  30 deg - 4:59; 50 Deg => 3:50 - so also an hour difference with 20 degrees at summer solstice
	- Needed to analyze relative contributions of these
(5) [DONE ] Calculate expected values for lat/long using regression equations for seas_mdd;
(6) [ ] Power analysis of sample needed to detect differences in suicidality by lat/long/sunrise - Does George know anyone?  What about Shiela?
  - could such questions be put in to CDC's BFRSS survey?
  John Nee's EasyStat - Michael will f/u on this.
*/

/* Notes from 8/27/2005 
(1) Should we re-compute the suicide data using units of hours instead of [DONE]
(2) Logistic regressions are not sensitive to interaction effects, so the fact that we detected some is interesting.
(3) For power analysis data range -- pick 4 levels (bins) - absolute bin size not important -- just divide by 4
(4) Need to do odds ratios of interaction effects "Power interaction of logistic regression within EasyStat"?
*/

%macro JoinSunriseTimeWithZip;
	proc sql;
		create table rnd_zip as
		select distinct Zipcode, Y, round(Y) as rnd_Y, X, -round(X) as rnd_X, GMTOffset
		from cet7.zip_gis
		order by Zipcode;
	quit;
	
	proc sql;
		create table cet7.zip_with_sunrise as
			select distinct a.Zipcode,
				abs((b.lat-a.Y) * (b.long+a.X)) as mean_sq_dist,
				b.lat, a.Y,
				b.long, a.X,
				b.sunrise_GMT_win_solst,
				(b.sunrise_GMT_win_solst + a.GMTOffset) as sunrise_local_win_solst
		from rnd_zip a, cet7.sunrisetimes b
		where rnd_Y = b.lat and rnd_X = b.long
		order by Zipcode, mean_sq_dist;
	quit;
	
	/*
	proc sql;
		create table zipmatch_test as
		select distinct zipcode, count(*) as N, *
		from temp
		group by zipcode
		order by N DESC, zipcode;
	quit;
	*/
	
%mend JoinSunriseTimeWithZip;

/* Get data to George *
proc sql;
	create table latlong_sunrise as
	select distinct zipcode, lat, long, sunrise_local_win_solst,
		(-5.2895 + .5415 * sunrise_local_win_solst) as seas_mdd_estimate
	from cet7.zip_with_sunrise
	order by zipcode;
quit;
*/

/* 9/9/05 Notes with Terman 
(1) George - Create Calculated Sunrise Time by Zip Code for COntinuous United States -
	(a) Smooth at the timezone boundaries -- it is related to joining by zipcode? sounds like already smoothed
	(b) Use a horizontal scale for the continuous data
	(c) interpolate Steve's data to 10th of a degree?
	(d) if get good continuous figure, don't need the timezone boundaries.
	(e) remove internal text labels (showing lat/long)
	(f) Graph of seasonal_mdd; men vs. women based upon expected values from regression lines
(2) Recommended - modafinil instead of caffeine
(3) Graph of seasonal_mdd - 
(4) Sex effect - men stronger than women
(5) N.B. Created Excel table with Michael using macro below
  - Effect sizes are large - graph regression equation from %s of repondants, not the logistic regression line
  
Manuscript:
Graphs
	(1) geo - Sunrise time
	(2) geo - MDD (combine men and women) for whole country (e.g. based upon sunrise data)
Tables
	(1a) % mdd - lat vs. sex
	(1b) % mdd - dtz vs sex
	(2) DSM-IV symptom criteria for MDD 
	
Michael will play with graphs and tables
[ ] Given N's for men and women for confidence intervals - so re-compute Analyses_2005_09_09 (edit workbook for Michael)
[ ] Do regressions (and geo distributions?) of seas_min, majmin, seas_sans
*/
%macro Analyses_2005_09_09;
	/* Effect is larger for men than women */
	proc sort data=cet7.automeq_keepers;
		by d_sex;
	run;
	
	%RunARegression2(logistic,seas_mdd,cet7.automeq_keepers,sunrise);
	%RunARegression2(logistic,seas_mdd,cet7.automeq_keepers,timezone);


	/* Need #s to show % of men affected by DTZ and LAT */
	data test1; set cet7.automeq_keepers; 
		if (dtz_4dg > 16) then dtz_4dg = 16;
	run;
	
	proc sort data=test1;
		by dtz_4dg;
	run;
	
	proc freq data=test1;
		by dtz_4dg;
		table d_sex * seas_mdd;
	run;
	
	/* Analyze #s by latitude */
	data test2; set cet7.automeq_keepers; 
		if (Y_4dg < 32) then Y_4dg = 32;
	run;
	
	proc sort data=test2;
		by Y_4dg;
	run;
	
	proc freq data=test2;
		by Y_4dg;
		table d_sex * seas_mdd;
	run;
	
	/* Latitude > 39, male vs. female by distnace from timezone boundary */
	data test3; set cet7.automeq_keepers; 
		where Y >= 39;
		if (dtz_4dg > 16) then dtz_4dg = 16;
	run;
	
	proc sort data=test3;
		by dtz_4dg;
	run;
	
	proc freq data=test3;
		by dtz_4dg;
		table d_sex * seas_mdd;
	run;
	
	/* Do male vs. female of sunrisetime, binning by quarter hour */
	data test4; set cet7.automeq_keepers;
		sunrise_bin_25 = round(sunrise_local_win_solst,.25);
		if (sunrise_bin_25 < 7) then sunrise_bin_25 = 7;
		if (sunrise_bin_25 > 8) then sunrise_bin_25 = 8;
	run;
	
	proc sort data=test4;
		by sunrise_bin_25;
	run;
	
	proc freq data=test4;
		by sunrise_bin_25;
		table d_sex * seas_mdd;
	run;	
	
	/* overall mean */
	proc freq data=test4;
		table d_sex * seas_mdd;
	run;		
		
	/* Do we need to weight the differences from the mean by the number of respondants at each sunrise time bin? */
%mend Analyses_2005_09_09;

/* to Do - 10/7/05 
	[ ] Chi-squared of binned sunrise time vs. # responses (e.g. 4-8 bins) - to see whether # respondants is comparable
*/

%macro Analyses_20051012;
data zip_gis; set cet7.zip_gis;
	where (statecode ne 'AK' and statecode ne 'HI');
run;

proc freq data=zip_gis;
	tables statecode;
run;

proc sql;
	select 
		min(sunrise_local_win_solst) as min_sunrise, max(sunrise_local_win_solst) as max_sunrise, 
			min(sunrise_local_win_solst) + ((max(sunrise_local_win_solst) - min(sunrise_local_win_solst)) / 2) as mid_sunrise,
		min(X) as min_X, max(X) as max_X, 
			min(X) + ((max(X) - min(X)) / 2) as mid_X,
		min(Y) as min_Y, max(Y) as max_Y, 
			min(Y) + ((max(Y) - min(Y)) / 2) as mid_Y,
		min(dist_from_timezone_boundary) as min_dtz, max(dist_from_timezone_boundary) as max_dtz, 
			min(dist_from_timezone_boundary) + ((max(dist_from_timezone_boundary) - min(dist_from_timezone_boundary))) / 2 as mid_dtz
	from zip_gis;
quit;

/* 
                                                     The SAS System                17:29 Wednesday, October 12, 2005  14

     min_      max_      mid_
  sunrise   sunrise   sunrise     min_X     max_X     mid_X     min_Y     max_Y     mid_Y   min_dtz   max_dtz   mid_dtz
 ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
    6.507    8.8016    7.6543  -124.532  -67.0127  -95.7722  24.58247  49.31421  36.94834         0  22.63344  11.31672
    
what	min	max	bin2_size	bin3_size	bin4_size	bin2_0	bin3_1	bin3_2	bin4_1	bin4_2	bin4_3
sunrise	6.507	8.8016	1.1473	0.764866667	0.57365	7.6543	7.271866667	8.036733333	7.08065	7.6543	8.22795
Y	24.58247	49.31421	12.36587	8.243913333	6.182935	36.94834	32.82638333	41.07029667	30.765405	36.94834	43.131275
dtz	0	22.63344	11.31672	7.54448	5.65836	11.31672	7.54448	15.08896	5.65836	11.31672	16.97508
    
*/


%mend Analyses_20051012;