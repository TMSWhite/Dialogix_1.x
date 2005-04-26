
data cet7.sadvsmd2; set cet7.sadvsmd;
	retain case;
	if (_N_ = 1) then case = 0;

	if (d_age > 15 and d_age < 26) then youngadult=1; else youngadult=0;
	if (month >= 11 or month <= 2) then iswinter=1; else iswinter=0;

	if (PIDSdone = 1 and Dscore >= 6 and 
		hasWinterSeasonality = 1 and MajorDepression_dx ne 1 and MinorDepression_dx ne 1) 
		then SANS = 1; else SANS = 0;

	if (age_cat = 'Adult') then case = case + 1;

*	if (case = 664 or case = 1299) then delete;
	
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
PROC EXPORT DATA= CET7.SADvsMD2 
            OUTFILE= "&cet7_lib\SADvsMD2.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/