
/**********************************************/
/* SAS Module __MAIN__-summary */
/**********************************************/

data WORK.AutoMEQ3;
	%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
	infile '\data\cet7\analysis\AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb)\__MAIN__-summary.tsv'
	delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
	informat UniqueID $50.; format UniqueID $50.;
	informat Finished best32.; format Finished best12.;
	informat StartDat mmddyy10.; format StartDat mmddyy10.;
	informat StopDate mmddyy10.; format StopDate mmddyy10.;
	informat Title $50.; format Title $50.;
	informat Version $50.; format Version $50.;
	informat d_who best32.;  format d_who best12.;
	informat d_study best32.;  format d_study best12.;
	informat d_age best32.;  format d_age best12.;
	informat _ask best32.;  format _ask best12.;
	informat d_sex best32.;  format d_sex best12.;
	informat d_eye best32.;  format d_eye best12.;
	informat d_country $25.;  format d_country $25.;
	informat d_state best32.;  format d_state best12.;
	informat _state_name $50.;  format _state_name $50.;
	informat d_los best32.;  format d_los best12.;
	informat d_zip best32.;  format d_zip best12.;
	informat d_eth_ai best32.;  format d_eth_ai best12.;
	informat d_eth_as best32.;  format d_eth_as best12.;
	informat d_eth_bl best32.;  format d_eth_bl best12.;
	informat d_eth_his best32.;  format d_eth_his best12.;
	informat d_eth_hw best32.;  format d_eth_hw best12.;
	informat d_eth_wh best32.;  format d_eth_wh best12.;
	informat d_working_days best32.;  format d_working_days best12.;
	informat d_sleep_workday $25.;  format d_sleep_workday $25.;
	informat d_sleep_nonworkday $25.;  format d_sleep_nonworkday $25.;
	informat d_awake_workday $25.;  format d_awake_workday $25.;
	informat d_awake_nonworkday $25.;  format d_awake_nonworkday $25.;
	informat q1 best32.;  format q1 best12.;
	informat q2 best32.;  format q2 best12.;
	informat d_abnl_sleep best32.;  format d_abnl_sleep best12.;
	informat d_abnl_sleep_cont best32.;  format d_abnl_sleep_cont best12.;
	informat _ask2 best32.;  format _ask2 best12.;
	informat q3 best32.;  format q3 best12.;
	informat q4 best32.;  format q4 best12.;
	informat q5 best32.;  format q5 best12.;
	informat q6 best32.;  format q6 best12.;
	informat q7 best32.;  format q7 best12.;
	informat q8 best32.;  format q8 best12.;
	informat q9 best32.;  format q9 best12.;
	informat q10 best32.;  format q10 best12.;
	informat q11 best32.;  format q11 best12.;
	informat q12 best32.;  format q12 best12.;
	informat q13 best32.;  format q13 best12.;
	informat q14 best32.;  format q14 best12.;
	informat q15 best32.;  format q15 best12.;
	informat q16 best32.;  format q16 best12.;
	informat q17 best32.;  format q17 best12.;
	informat q18 best32.;  format q18 best12.;
	informat q19 best32.;  format q19 best12.;
	informat MEQ best32.;  format MEQ best12.;
	informat MEQstd best32.;  format MEQstd best12.;
	informat DLMO best32.;  format DLMO best12.;
	informat DLMO_h best32.;  format DLMO_h best12.;
	informat DLMO_m best32.;  format DLMO_m best12.;
	informat DLMO_time0 time8.0;  format DLMO_time0 time8.0;
	informat DLMO_time time8.0;  format DLMO_time time8.0;
	informat SL_ONSET best32.;  format SL_ONSET best12.;
	informat SL_ONSET_h best32.;  format SL_ONSET_h best12.;
	informat SL_ONSET_m best32.;  format SL_ONSET_m best12.;
	informat SL_ONSET_time0 time8.0;  format SL_ONSET_time0 time8.0;
	informat SL_ONSET_time $50.;  format SL_ONSET_time $50.;
	informat LIGHTS_ON best32.;  format LIGHTS_ON best12.;
	informat LIGHTS_ON_h best32.;  format LIGHTS_ON_h best12.;
	informat LIGHTS_ON_m best32.;  format LIGHTS_ON_m best12.;
	informat LIGHTS_ON_time0 time8.0;  format LIGHTS_ON_time0 time8.0;
	informat LIGHTS_ON_time $50.;  format LIGHTS_ON_time $50.;
	informat MEQ_type $50.;  format MEQ_type $50.;
	informat Feedback0 best32.;  format Feedback0 best12.;
	informat Feedback_us $254.;  format Feedback_us $254.;


	INPUT
		UniqueID $
		Finished
		StartDat
		StopDate
		Title $
		Version $
		d_who
		d_study
		d_age
		_ask
		d_sex
		d_eye
		d_country $
		d_state
		_state_name $
		d_los
		d_zip
		d_eth_ai
		d_eth_as
		d_eth_bl
		d_eth_his
		d_eth_hw
		d_eth_wh
		d_working_days
		d_sleep_workday $
		d_sleep_nonworkday $
		d_awake_workday $
		d_awake_nonworkday $
		q1
		q2
		d_abnl_sleep
		d_abnl_sleep_cont
		_ask2
		q3
		q4
		q5
		q6
		q7
		q8
		q9
		q10
		q11
		q12
		q13
		q14
		q15
		q16
		q17
		q18
		q19
		MEQ
		MEQstd
		DLMO
		DLMO_h
		DLMO_m
		DLMO_time0
		DLMO_time
		SL_ONSET
		SL_ONSET_h
		SL_ONSET_m
		SL_ONSET_time0
		SL_ONSET_time $
		LIGHTS_ON
		LIGHTS_ON_h
		LIGHTS_ON_m
		LIGHTS_ON_time0
		LIGHTS_ON_time $
		MEQ_type $
		Feedback0
		Feedback_us
		;
	if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc format;
	value DF0001f
		1 = "[1]For yourself"
		2 = "[2]For someone else"
		3 = "[3]Just testing the system"
		4 = "[4]I cannot or do not want to answer this question."
		. = ' '
		OTHER = '?'
	;
	value DF0002f
		0 = "[0]No, I want to use the questionnaire only for my personal use"
		1 = "[1]Yes, I agree to join the study"
		. = ' '
		OTHER = '?'
	;
	value DF0003f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]male"
		1 = "[1]female"
		. = ' '
		OTHER = '?'
	;
	value DF0004f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]blue"
		1 = "[1]gray"
		2 = "[2]green"
		3 = "[3]hazel"
		4 = "[4]brown"
		5 = "[5]black"
		6 = "[6]albino"
		. = ' '
		OTHER = '?'
	;
	value $DF0005f
		"Afghanistan" = "['Afghanistan']Afghanistan"
		"Albania" = "['Albania']Albania"
		"Algeria" = "['Algeria']Algeria"
		"Andorra" = "['Andorra']Andorra"
		"Angola" = "['Angola']Angola"
		"Antigua and Barbuda" = "['Antigua and Barbuda']Antigua and Barbuda"
		"Argentina" = "['Argentina']Argentina"
		"Armenia" = "['Armenia']Armenia"
		"Australia" = "['Australia']Australia"
		"Austria" = "['Austria']Austria"
		"Azerbaijan" = "['Azerbaijan']Azerbaijan"
		"Bahamas" = "['Bahamas']Bahamas"
		"Bahrain" = "['Bahrain']Bahrain"
		"Bangladesh" = "['Bangladesh']Bangladesh"
		"Barbados" = "['Barbados']Barbados"
		"Belarus" = "['Belarus']Belarus"
		"Belgium" = "['Belgium']Belgium"
		"Belize" = "['Belize']Belize"
		"Benin" = "['Benin']Benin"
		"Bermuda" = "['Bermuda']Bermuda"
		"Bjibouti" = "['Bjibouti']Bjibouti"
		"Bolivia" = "['Bolivia']Bolivia"
		"Bosnia Herzegovian" = "['Bosnia Herzegovian']Bosnia Herzegovian"
		"Botswana" = "['Botswana']Botswana"
		"Brazil" = "['Brazil']Brazil"
		"Brunei" = "['Brunei']Brunei"
		"Bulgaria" = "['Bulgaria']Bulgaria"
		"Burkina Faso" = "['Burkina Faso']Burkina Faso"
		"Burma" = "['Burma']Burma"
		"Burundi" = "['Burundi']Burundi"
		"Cambodia" = "['Cambodia']Cambodia"
		"Cameroon" = "['Cameroon']Cameroon"
		"Canada" = "['Canada']Canada"
		"Cape Verde" = "['Cape Verde']Cape Verde"
		"Central African Republic" = "['Central African Republic']Central African Republic"
		"Chad" = "['Chad']Chad"
		"Chile" = "['Chile']Chile"
		"China" = "['China']China"
		"Colombia" = "['Colombia']Colombia"
		"Comoros" = "['Comoros']Comoros"
		"Congo" = "['Congo']Congo"
		"Costa Rica" = "['Costa Rica']Costa Rica"
		"Cote d'Ivoire" = "['Cote d'Ivoire']Cote d'Ivoire"
		"Croatia" = "['Croatia']Croatia"
		"Cuba" = "['Cuba']Cuba"
		"Cyprus" = "['Cyprus']Cyprus"
		"Czech" = "['Czech']Czech"
		"Democratic Republic of Congo" = "['Democratic Republic of Congo']Democratic Republic of Congo"
		"Denmark" = "['Denmark']Denmark"
		"Dominica" = "['Dominica']Dominica"
		"Dominican Republic" = "['Dominican Republic']Dominican Republic"
		"Ecuador" = "['Ecuador']Ecuador"
		"Egypt" = "['Egypt']Egypt"
		"El Salvador" = "['El Salvador']El Salvador"
		"Equatorial uinea" = "['Equatorial uinea']Equatorial Guinea"
		"Eritrea" = "['Eritrea']Eritrea"
		"Estonia" = "['Estonia']Estonia"
		"Ethiopia" = "['Ethiopia']Ethiopia"
		"European Union" = "['European Union']European Union"
		"Faroe Islands" = "['Faroe Islands']Faroe Islands"
		"Fiji" = "['Fiji']Fiji"
		"Finland" = "['Finland']Finland"
		"France" = "['France']France"
		"Gabon" = "['Gabon']Gabon"
		"Gambia" = "['Gambia']Gambia"
		"Georgia" = "['Georgia']Georgia"
		"Germany" = "['Germany']Germany"
		"Ghana" = "['Ghana']Ghana"
		"Great Britain" = "['Great Britain']Great Britain"
		"Greece" = "['Greece']Greece"
		"Greenland" = "['Greenland']Greenland"
		"Grenada" = "['Grenada']Grenada"
		"Guatemala" = "['Guatemala']Guatemala"
		"Guinea Bissau" = "['Guinea Bissau']Guinea Bissau"
		"Guinea" = "['Guinea']Guinea"
		"Guyana" = "['Guyana']Guyana"
		"Haiti" = "['Haiti']Haiti"
		"Holy See" = "['Holy See']Holy See"
		"Honduras" = "['Honduras']Honduras"
		"Hong Kong" = "['Hong Kong']Hong Kong"
		"Hungary" = "['Hungary']Hungary"
		"Iceland" = "['Iceland']Iceland"
		"India" = "['India']India"
		"Indonesia" = "['Indonesia']Indonesia"
		"Iran" = "['Iran']Iran"
		"Iraq" = "['Iraq']Iraq"
		"Ireland" = "['Ireland']Ireland"
		"Isle of Man" = "['Isle of Man']Isle of Man"
		"Israel" = "['Israel']Israel"
		"Italy" = "['Italy']Italy"
		"Jamaica" = "['Jamaica']Jamaica"
		"Jan Mayen" = "['Jan Mayen']Jan Mayen"
		"Japan" = "['Japan']Japan"
		"Jarvis Island" = "['Jarvis Island']Jarvis Island"
		"Jersey" = "['Jersey']Jersey"
		"Johnston Atoll" = "['Johnston Atoll']Johnston Atoll"
		"Jordan" = "['Jordan']Jordan"
		"Juan de Nova Island" = "['Juan de Nova Island']Juan de Nova Island"
		"Kazakstan" = "['Kazakstan']Kazakstan"
		"Kenya" = "['Kenya']Kenya"
		"Kiribati" = "['Kiribati']Kiribati"
		"Kuwait" = "['Kuwait']Kuwait"
		"Kyrgyztan" = "['Kyrgyztan']Kyrgyztan"
		"Laos" = "['Laos']Laos"
		"Latvia" = "['Latvia']Latvia"
		"Lebanon" = "['Lebanon']Lebanon"
		"Lesotho" = "['Lesotho']Lesotho"
		"Libria" = "['Libria']Liberia"
		"Libya" = "['Libya']Libya"
		"Liechtenstein" = "['Liechtenstein']Liechtenstein"
		"Lithuania" = "['Lithuania']Lithuania"
		"Luxembourg" = "['Luxembourg']Luxembourg"
		"Macau" = "['Macau']Macau"
		"Macedonia" = "['Macedonia']Macedonia"
		"Madagascar" = "['Madagascar']Madagascar"
		"Malaw" = "['Malaw']Malawi"
		"Malaysia" = "['Malaysia']Malaysia"
		"Mali" = "['Mali']Mali"
		"Marshall Islands" = "['Marshall Islands']Marshall Islands"
		"Martinique" = "['Martinique']Martinique"
		"Mauritania" = "['Mauritania']Mauritania"
		"Mauritius" = "['Mauritius']Mauritius"
		"Mayotte" = "['Mayotte']Mayotte"
		"Mexico" = "['Mexico']Mexico"
		"Micronesia" = "['Micronesia']Micronesia"
		"Midway Islands" = "['Midway Islands']Midway Islands"
		"Moldova" = "['Moldova']Moldova"
		"Monaco" = "['Monaco']Monaco"
		"Mongolia" = "['Mongolia']Mongolia"
		"Montserrat" = "['Montserrat']Montserrat"
		"Morocco" = "['Morocco']Morocco"
		"Mozambique" = "['Mozambique']Mozambique"
		"Myanmar" = "['Myanmar']Myanmar"
		"N/A" = "['N/A']I cannot or do not want to answer this question."
		"Namibia" = "['Namibia']Namibia"
		"Nauru" = "['Nauru']Nauru"
		"Navassa sland" = "['Navassa sland']Navassa sland"
		"Nepal" = "['Nepal']Nepal"
		"Netherlands Antilles" = "['Netherlands Antilles']Netherlands Antilles"
		"Netherlands" = "['Netherlands']Netherlands"
		"New Caledonia" = "['New Caledonia']New Caledonia"
		"New Zealand" = "['New Zealand']New Zealand"
		"Nicaragua" = "['Nicaragua']Nicaragua"
		"Niger" = "['Niger']Niger"
		"Nigeria" = "['Nigeria']Nigeria"
		"Niue" = "['Niue']Niue"
		"Norfolk Island" = "['Norfolk Island']Norfolk Island"
		"North Korea" = "['North Korea']North Korea"
		"Northern Mariana Islands" = "['Northern Mariana Islands']Northern Mariana Islands"
		"Norway" = "['Norway']Norway"
		"Oman" = "['Oman']Oman"
		"Pakistan" = "['Pakistan']Pakistan"
		"Palau" = "['Palau']Palau"
		"Palestine" = "['Palestine']Palestine"
		"Panama" = "['Panama']Panama"
		"Papua New Guinea" = "['Papua New Guinea']Papua New Guinea"
		"Paraguay" = "['Paraguay']Paraguay"
		"Peru" = "['Peru']Peru"
		"Philippines" = "['Philippines']Philippines"
		"Pitcairn Islands" = "['Pitcairn Islands']Pitcairn Islands"
		"Poland" = "['Poland']Poland"
		"Portugal" = "['Portugal']Portugal"
		"Puerto Rico" = "['Puerto Rico']Puerto Rico"
		"Qatar" = "['Qatar']Qatar"
		"Reunion" = "['Reunion']Reunion"
		"Romania" = "['Romania']Romania"
		"Royal Bhutan" = "['Royal Bhutan']Royal Bhutan"
		"Russia" = "['Russia']Russia"
		"Rwanda" = "['Rwanda']Rwanda"
		"Saint Kitts and Nevis" = "['Saint Kitts and Nevis']Saint Kitts and Nevis"
		"Saint Lucia" = "['Saint Lucia']Saint Lucia"
		"Saint Pierre and Miquelon" = "['Saint Pierre and Miquelon']Saint Pierre and Miquelon"
		"Saint Vincent and the Grenadines" = "['Saint Vincent and the Grenadines']Saint Vincent and the Grenadines"
		"Samoa American" = "['Samoa American']Samoa American"
		"Samoa" = "['Samoa']Samoa"
		"San Marino" = "['San Marino']San Marino"
		"Sao Tome and Principe" = "['Sao Tome and Principe']Sao Tome and Principe"
		"Saudi Arabia" = "['Saudi Arabia']Saudi Arabia"
		"Senegal" = "['Senegal']Senegal"
		"Serbia and Montenegro" = "['Serbia and Montenegro']Serbia and Montenegro"
		"Seychelles" = "['Seychelles']Seychelles"
		"Sierra Leone" = "['Sierra Leone']Sierra Leone"
		"Singapore" = "['Singapore']Singapore"
		"Slovakia" = "['Slovakia']Slovakia"
		"Slovenia" = "['Slovenia']Slovenia"
		"Solomon Islands" = "['Solomon Islands']Solomon Islands"
		"Somalia" = "['Somalia']Somalia"
		"South Korea" = "['South Korea']South Korea"
		"South frica" = "['South frica']South frica"
		"Spain" = "['Spain']Spain"
		"Sri Lanka" = "['Sri Lanka']Sri Lanka"
		"Sudan" = "['Sudan']Sudan"
		"Suriname" = "['Suriname']Suriname"
		"Swaziland" = "['Swaziland']Swaziland"
		"Sweden" = "['Sweden']Sweden"
		"Switzerland" = "['Switzerland']Switzerland"
		"Syria" = "['Syria']Syria"
		"Taiwan" = "['Taiwan']Taiwan"
		"Tajikistan" = "['Tajikistan']Tajikistan"
		"Tanzania" = "['Tanzania']Tanzania"
		"Thailand" = "['Thailand']Thailand"
		"Togo" = "['Togo']Togo"
		"Tonga" = "['Tonga']Tonga"
		"Trinidad and Tobago" = "['Trinidad and Tobago']Trinidad and Tobago"
		"Tunisia" = "['Tunisia']Tunisia"
		"Turkey" = "['Turkey']Turkey"
		"Turkmenistan" = "['Turkmenistan']Turkmenistan"
		"Tuvalu" = "['Tuvalu']Tuvalu"
		"Uganda" = "['Uganda']Uganda"
		"Ukraine" = "['Ukraine']Ukraine"
		"United Arab Emirates" = "['United Arab Emirates']United Arab Emirates"
		"United States" = "['United States']United States"
		"Uruguay" = "['Uruguay']Uruguay"
		"Uzbekistan" = "['Uzbekistan']Uzbekistan"
		"Vanuatu" = "['Vanuatu']Vanuatu"
		"Vatican" = "['Vatican']Vatican"
		"Venezuela" = "['Venezuela']Venezuela"
		"Vietnam" = "['Vietnam']Vietnam"
		"Western Samoa" = "['Western Samoa']Western Samoa"
		"Yemen" = "['Yemen']Yemen"
		"Yugoslavia" = "['Yugoslavia']Yugoslavia"
		"Zaire" = "['Zaire']Zaire"
		"Zambia" = "['Zambia']Zambia"
		"Zimbawe" = "['Zimbawe']Zimbawe"
		. = ' '
		OTHER = '?'
	;
	value DF0006f
		-1 = "[-1]I cannot or do not want to answer this question."
		1 = "[1]Alabama"
		10 = "[10]Florida"
		11 = "[11]Georgia"
		12 = "[12]Hawaii"
		13 = "[13]Idaho"
		14 = "[14]Illinois"
		15 = "[15]Indiana"
		16 = "[16]Iowa"
		17 = "[17]Kansas"
		18 = "[18]Kentucky"
		19 = "[19]Louisiana"
		2 = "[2]Alaska"
		20 = "[20]Maine"
		21 = "[21]Maryland"
		22 = "[22]Massachusetts"
		23 = "[23]Michigan"
		24 = "[24]Minnesota"
		25 = "[25]Mississippi"
		26 = "[26]Missouri"
		27 = "[27]Montana"
		28 = "[28]Nebraska"
		29 = "[29]Nevada"
		3 = "[3]Arizona"
		30 = "[30]New Hampshire"
		31 = "[31]New Jersey"
		32 = "[32]New Mexico"
		33 = "[33]New York"
		34 = "[34]North Carolina"
		35 = "[35]North Dakota"
		36 = "[36]Ohio"
		37 = "[37]Oklahoma"
		38 = "[38]Oregon"
		39 = "[39]Pennsylvania"
		4 = "[4]Arkansas"
		40 = "[40]Rhode Island"
		41 = "[41]South Carolina"
		42 = "[42]South Dakota"
		43 = "[43]Tennessee"
		44 = "[44]Texas"
		45 = "[45]Utah"
		46 = "[46]Vermont"
		47 = "[47]Virginia"
		48 = "[48]Washington"
		49 = "[49]West Virginia"
		5 = "[5]California"
		50 = "[50]Wisconsin"
		51 = "[51]Wyoming"
		6 = "[6]Colorado"
		7 = "[7]Connecticut"
		8 = "[8]Delaware"
		9 = "[9]District of Columbia"
		. = ' '
		OTHER = '?'
	;
	value DF0007f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0008f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0009f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0010f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0011f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0012f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0013f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0014f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]0"
		1 = "[1]1"
		2 = "[2]2"
		3 = "[3]3"
		4 = "[4]4"
		5 = "[5]5"
		6 = "[6]6"
		7 = "[7]7"
		. = ' '
		OTHER = '?'
	;
	value $DF0015f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value $DF0016f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value $DF0017f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value $DF0018f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value DF0019f
		0 = "[0]12:00 noon-5:00 a.m."
		1 = "[1]11:00 a.m.-12:00 noon"
		2 = "[2]9:45-11:00 a.m."
		3 = "[3]7:45-9:45 a.m."
		4 = "[4]6:30-7:45 a.m."
		5 = "[5]5:00-6:30 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0020f
		0 = "[0]3:00 a.m.-8:00 p.m."
		1 = "[1]1:45-3:00 a.m."
		2 = "[2]12:30-1:45 a.m."
		3 = "[3]10:15 p.m.-12:30 a.m."
		4 = "[4]9:00-10:15 p.m."
		5 = "[5]8:00-9:00 p.m."
		. = ' '
		OTHER = '?'
	;
	value DF0021f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0022f
		1 = "[1]Very much"
		2 = "[2]Somewhat"
		3 = "[3]Slightly"
		4 = "[4]Not at all"
		. = ' '
		OTHER = '?'
	;
	value DF0023f
		1 = "[1]Very difficult"
		2 = "[2]Somewhat difficult"
		3 = "[3]Fairly easy"
		4 = "[4]Very easy"
		. = ' '
		OTHER = '?'
	;
	value DF0024f
		1 = "[1]Not at all alert"
		2 = "[2]Slightly alert"
		3 = "[3]Fairly alert"
		4 = "[4]Very alert"
		. = ' '
		OTHER = '?'
	;
	value DF0025f
		1 = "[1]Not at all hungry"
		2 = "[2]Slightly hungry"
		3 = "[3]Fairly hungry"
		4 = "[4]Very hungry"
		. = ' '
		OTHER = '?'
	;
	value DF0026f
		1 = "[1]Very tired"
		2 = "[2]Fairly tired"
		3 = "[3]Fairly refreshed"
		4 = "[4]Very refreshed"
		. = ' '
		OTHER = '?'
	;
	value DF0027f
		1 = "[1]More than 2 hours later"
		2 = "[2]1-2 hours later"
		3 = "[3]Less than 1 hour later"
		4 = "[4]Seldom or never later"
		. = ' '
		OTHER = '?'
	;
	value DF0028f
		1 = "[1]Would find it very difficult"
		2 = "[2]Would find it difficult"
		3 = "[3]Would be in reasonable form"
		4 = "[4]Would be in good form"
		. = ' '
		OTHER = '?'
	;
	value DF0029f
		1 = "[1]2-3 a.m."
		2 = "[2]12:45-2:00 a.m."
		3 = "[3]10:15 p.m.-12:45 a.m."
		4 = "[4]9-10:15 p.m."
		5 = "[5]8-9 p.m."
		. = ' '
		OTHER = '?'
	;
	value DF0030f
		0 = "[0]7-9 p.m."
		2 = "[2]3-5 p.m."
		4 = "[4]11 a.m.-1 p.m."
		6 = "[6]8-10 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0031f
		0 = "[0]Not at all tired"
		2 = "[2]A little tired"
		3 = "[3]Fairly tired"
		5 = "[5]Very tired"
		. = ' '
		OTHER = '?'
	;
	value DF0032f
		1 = "[1]Will not wake up until later than usual"
		2 = "[2]Will wake up at usual time, but will fall asleep again"
		3 = "[3]Will wake up at usual time and will doze thereafter"
		4 = "[4]Will wake up at usual time, but will not fall back asleep"
		. = ' '
		OTHER = '?'
	;
	value DF0033f
		1 = "[1]Would not go to bed until the watch was over"
		2 = "[2]Would take a nap before and sleep after"
		3 = "[3]Would take a good sleep before and nap after"
		4 = "[4]Would sleep only before the watch"
		. = ' '
		OTHER = '?'
	;
	value DF0034f
		1 = "[1]7-9 p.m."
		2 = "[2]3-5 p.m."
		3 = "[3]11 a.m.-1 p.m."
		4 = "[4]8-10 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0035f
		1 = "[1]Would be in good form"
		2 = "[2]Would be in reasonable form"
		3 = "[3]Would find it difficult"
		4 = "[4]Would find it very difficult"
		. = ' '
		OTHER = '?'
	;
	value DF0036f
		1 = "[1]5 hours starting between 5 p.m. and 4 a.m."
		2 = "[2]5 hours starting between 2 p.m. and 5 p.m."
		3 = "[3]5 hours starting between 9 a.m. and 2 p.m."
		4 = "[4]5 hours starting between 8 a.m. and 9 a.m."
		5 = "[5]5 hours starting between 4 a.m. and 8 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0037f
		1 = "[1]10 pm-5 a.m."
		2 = "[2]5-10 p.m."
		3 = "[3]10 a.m-5 p.m."
		4 = "[4]8-10 a.m."
		5 = "[5]5-8 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0038f
		0 = "[0]Definitely an evening type"
		2 = "[2]Rather more an evening type than a morning type"
		4 = "[4]Rather more a morning type than an evening type"
		6 = "[6]Definitely a morning type"
		. = ' '
		OTHER = '?'
	;
	value DF0039f
		1 = "[1]Please let me review my answers from the beginning"
		2 = "[2]My answers are correct - please continue"
		. = ' '
		OTHER = '?'
	;
run;
data WORK.AutoMEQ3; set WORK.AutoMEQ3;
	format d_who DF0001f.;
	format d_study DF0002f.;
	format d_sex DF0003f.;
	format d_eye DF0004f.;
	format d_country $DF0005f.;
	format d_state DF0006f.;
	format d_los DF0007f.;
	format d_eth_ai DF0008f.;
	format d_eth_as DF0009f.;
	format d_eth_bl DF0010f.;
	format d_eth_his DF0011f.;
	format d_eth_hw DF0012f.;
	format d_eth_wh DF0013f.;
	format d_working_days DF0014f.;
	format d_sleep_workday $DF0015f.;
	format d_sleep_nonworkday $DF0016f.;
	format d_awake_workday $DF0017f.;
	format d_awake_nonworkday $DF0018f.;
	format q1 DF0019f.;
	format q2 DF0020f.;
	format d_abnl_sleep_cont DF0021f.;
	format q3 DF0022f.;
	format q4 DF0023f.;
	format q5 DF0024f.;
	format q6 DF0025f.;
	format q7 DF0026f.;
	format q8 DF0027f.;
	format q9 DF0028f.;
	format q10 DF0029f.;
	format q11 DF0030f.;
	format q12 DF0031f.;
	format q13 DF0032f.;
	format q14 DF0033f.;
	format q15 DF0034f.;
	format q16 DF0035f.;
	format q17 DF0036f.;
	format q18 DF0037f.;
	format q19 DF0038f.;
	format Feedback0 DF0039f.;
run;
options compress=BINARY;
data '\data\cet7\analysis\AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb)\AutoMEQ3.sas7bdat'; set WORK.AutoMEQ3; run;
/*proc sql; drop table WORK.AutoMEQ3;*/
