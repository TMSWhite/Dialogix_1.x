proc format;
	value sexf
		0 = 'male'
		1 = 'female'
		-1 = 'sex?'
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

data summary; set summary;
	format d_sex sexf.;

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
run;

proc freq data=summary;
	table ethnicity;
	table d_sex * irb_ethnicity;
run;