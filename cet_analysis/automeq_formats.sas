
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
		"Cote d_Ivoire" = "['Cote d_Ivoire']Cote d'Ivoire"
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
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0020f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0021f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]0:00"
		105 = "[105]1:45"
		120 = "[120]2:00"
		135 = "[135]2:15"
		15 = "[15]0:15"
		150 = "[150]2:30"
		165 = "[165]2:45"
		180 = "[180]3:00"
		195 = "[195]3:15"
		210 = "[210]3:30"
		225 = "[225]3:45"
		240 = "[240]4:00"
		255 = "[255]4:15"
		270 = "[270]4:30"
		285 = "[285]4:45"
		30 = "[30]0:30"
		300 = "[300]5:00"
		315 = "[315]5:15"
		330 = "[330]5:30"
		345 = "[345]5:45"
		360 = "[360]6:00"
		375 = "[375]6:15"
		390 = "[390]6:30"
		405 = "[405]6:45"
		420 = "[420]7:00"
		435 = "[435]7:15"
		45 = "[45]0:45"
		450 = "[450]7:30"
		465 = "[465]7:45"
		480 = "[480]8:00"
		495 = "[495]8:15"
		510 = "[510]8:30"
		525 = "[525]8:45"
		540 = "[540]9:00"
		555 = "[555]9:15"
		570 = "[570]9:30"
		585 = "[585]9:45"
		60 = "[60]1:00"
		600 = "[600]10:00"
		615 = "[615]10:15"
		630 = "[630]10:30"
		645 = "[645]10:45"
		660 = "[660]11:00"
		675 = "[675]11:15"
		690 = "[690]11:30"
		705 = "[705]11:45"
		720 = "[720]12:00"
		735 = "[735]12:15"
		75 = "[75]1:15"
		750 = "[750]12:30"
		765 = "[765]12:45"
		780 = "[780]13:00"
		795 = "[795]13:15"
		810 = "[810]13:30"
		825 = "[825]13:45"
		840 = "[840]14:00"
		855 = "[855]14:15"
		870 = "[870]14:30"
		885 = "[885]14:45"
		90 = "[90]1:30"
		900 = "[900]15:00"
		. = ' '
		OTHER = '?'
	;
	value DF0022f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]0:00"
		105 = "[105]1:45"
		120 = "[120]2:00"
		135 = "[135]2:15"
		15 = "[15]0:15"
		150 = "[150]2:30"
		165 = "[165]2:45"
		180 = "[180]3:00"
		195 = "[195]3:15"
		210 = "[210]3:30"
		225 = "[225]3:45"
		240 = "[240]4:00"
		255 = "[255]4:15"
		270 = "[270]4:30"
		285 = "[285]4:45"
		30 = "[30]0:30"
		300 = "[300]5:00"
		315 = "[315]5:15"
		330 = "[330]5:30"
		345 = "[345]5:45"
		360 = "[360]6:00"
		375 = "[375]6:15"
		390 = "[390]6:30"
		405 = "[405]6:45"
		420 = "[420]7:00"
		435 = "[435]7:15"
		45 = "[45]0:45"
		450 = "[450]7:30"
		465 = "[465]7:45"
		480 = "[480]8:00"
		495 = "[495]8:15"
		510 = "[510]8:30"
		525 = "[525]8:45"
		540 = "[540]9:00"
		555 = "[555]9:15"
		570 = "[570]9:30"
		585 = "[585]9:45"
		60 = "[60]1:00"
		600 = "[600]10:00"
		615 = "[615]10:15"
		630 = "[630]10:30"
		645 = "[645]10:45"
		660 = "[660]11:00"
		675 = "[675]11:15"
		690 = "[690]11:30"
		705 = "[705]11:45"
		720 = "[720]12:00"
		735 = "[735]12:15"
		75 = "[75]1:15"
		750 = "[750]12:30"
		765 = "[765]12:45"
		780 = "[780]13:00"
		795 = "[795]13:15"
		810 = "[810]13:30"
		825 = "[825]13:45"
		840 = "[840]14:00"
		855 = "[855]14:15"
		870 = "[870]14:30"
		885 = "[885]14:45"
		90 = "[90]1:30"
		900 = "[900]15:00"
		. = ' '
		OTHER = '?'
	;
	value DF0023f
		-1 = "[-1]I cannot or do not want to answer this question."
		1 = "[1]Feet and Inches"
		2 = "[2]Meters"
		. = ' '
		OTHER = '?'
	;
	value DF0024f
		-1 = "[-1]I cannot or do not want to answer this question."
		1 = "[1]Pounds"
		2 = "[2]Kilograms"
		. = ' '
		OTHER = '?'
	;
	value DF0025f
		0 = "[0]0"
		1 = "[1]1"
		2 = "[2]2"
		3 = "[3]3"
		4 = "[4]4"
		5 = "[5]5"
		6 = "[6]6"
		7 = "[7]7"
		8 = "[8]8"
		9 = "[9]9"
		. = ' '
		OTHER = '?'
	;
	value DF0026f
		0 = "[0]0"
		1 = "[1]1"
		10 = "[10]10"
		11 = "[11]11"
		2 = "[2]2"
		3 = "[3]3"
		4 = "[4]4"
		5 = "[5]5"
		6 = "[6]6"
		7 = "[7]7"
		8 = "[8]8"
		9 = "[9]9"
		. = ' '
		OTHER = '?'
	;
	value DF0027f
		1 = "[1]Yes, show me the seasonality questions."
		2 = "[2]No, I'll skip the seasonality questions."
		. = ' '
		OTHER = '?'
	;
	value DF0028f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0029f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0030f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0031f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0032f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0033f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0034f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0035f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0036f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0037f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0038f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0039f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0040f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0041f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0042f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0043f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0044f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0045f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0046f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0047f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0048f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0049f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0050f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0051f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0052f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0053f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0054f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0055f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0056f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0057f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0058f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0059f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0060f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0061f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0062f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0063f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0064f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0065f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0066f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0067f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0068f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0069f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0070f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0071f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0072f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0073f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0074f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0075f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0076f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0077f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0078f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0079f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0080f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0081f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0082f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0083f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0084f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0085f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0086f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0087f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0088f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0089f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0090f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0091f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0092f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0093f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0094f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0095f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0096f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0097f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0098f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0099f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0100f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0101f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0102f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0103f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0104f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0105f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0106f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0107f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0108f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0109f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0110f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0111f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0112f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0113f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0114f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0115f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0116f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0117f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0118f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0119f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0120f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0121f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0122f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0123f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0124f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0125f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0126f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0127f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0128f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0129f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0130f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0131f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0132f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0133f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0134f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0135f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0136f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0137f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0138f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0139f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0140f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0141f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0142f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0143f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0144f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0145f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0146f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0147f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0148f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0149f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0150f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0151f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0152f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0153f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0154f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0155f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0156f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0157f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0158f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0159f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0160f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0161f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0162f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0163f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0164f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0165f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0166f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0167f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0168f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0169f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0170f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0171f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0172f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0173f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0174f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0175f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0176f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0177f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0178f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0179f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0180f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0181f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0182f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0183f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0184f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0185f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0186f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0187f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0188f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0189f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0190f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0191f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0192f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0193f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0194f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0195f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0196f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0197f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0198f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0199f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0200f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0201f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0202f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0203f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0204f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0205f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0206f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0207f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0208f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0209f
		0 = "[0]12:00 noon-5:00 a.m."
		1 = "[1]11:00 a.m.-12:00 noon"
		2 = "[2]9:45-11:00 a.m."
		3 = "[3]7:45-9:45 a.m."
		4 = "[4]6:30-7:45 a.m."
		5 = "[5]5:00-6:30 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0210f
		0 = "[0]3:00 a.m.-8:00 p.m."
		1 = "[1]1:45-3:00 a.m."
		2 = "[2]12:30-1:45 a.m."
		3 = "[3]10:15 p.m.-12:30 a.m."
		4 = "[4]9:00-10:15 p.m."
		5 = "[5]8:00-9:00 p.m."
		. = ' '
		OTHER = '?'
	;
	value DF0211f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0212f
		1 = "[1]Very much"
		2 = "[2]Somewhat"
		3 = "[3]Slightly"
		4 = "[4]Not at all"
		. = ' '
		OTHER = '?'
	;
	value DF0213f
		1 = "[1]Very difficult"
		2 = "[2]Somewhat difficult"
		3 = "[3]Fairly easy"
		4 = "[4]Very easy"
		. = ' '
		OTHER = '?'
	;
	value DF0214f
		1 = "[1]Not at all alert"
		2 = "[2]Slightly alert"
		3 = "[3]Fairly alert"
		4 = "[4]Very alert"
		. = ' '
		OTHER = '?'
	;
	value DF0215f
		1 = "[1]Not at all hungry"
		2 = "[2]Slightly hungry"
		3 = "[3]Fairly hungry"
		4 = "[4]Very hungry"
		. = ' '
		OTHER = '?'
	;
	value DF0216f
		1 = "[1]Very tired"
		2 = "[2]Fairly tired"
		3 = "[3]Fairly refreshed"
		4 = "[4]Very refreshed"
		. = ' '
		OTHER = '?'
	;
	value DF0217f
		1 = "[1]More than 2 hours later"
		2 = "[2]1-2 hours later"
		3 = "[3]Less than 1 hour later"
		4 = "[4]Seldom or never later"
		. = ' '
		OTHER = '?'
	;
	value DF0218f
		1 = "[1]Would find it very difficult"
		2 = "[2]Would find it difficult"
		3 = "[3]Would be in reasonable form"
		4 = "[4]Would be in good form"
		. = ' '
		OTHER = '?'
	;
	value DF0219f
		1 = "[1]2-3 a.m."
		2 = "[2]12:45-2:00 a.m."
		3 = "[3]10:15 p.m.-12:45 a.m."
		4 = "[4]9-10:15 p.m."
		5 = "[5]8-9 p.m."
		. = ' '
		OTHER = '?'
	;
	value DF0220f
		0 = "[0]7-9 p.m."
		2 = "[2]3-5 p.m."
		4 = "[4]11 a.m.-1 p.m."
		6 = "[6]8-10 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0221f
		0 = "[0]Not at all tired"
		2 = "[2]A little tired"
		3 = "[3]Fairly tired"
		5 = "[5]Very tired"
		. = ' '
		OTHER = '?'
	;
	value DF0222f
		1 = "[1]Will not wake up until later than usual"
		2 = "[2]Will wake up at usual time, but will fall asleep again"
		3 = "[3]Will wake up at usual time and will doze thereafter"
		4 = "[4]Will wake up at usual time, but will not fall back asleep"
		. = ' '
		OTHER = '?'
	;
	value DF0223f
		1 = "[1]Would not go to bed until the watch was over"
		2 = "[2]Would take a nap before and sleep after"
		3 = "[3]Would take a good sleep before and nap after"
		4 = "[4]Would sleep only before the watch"
		. = ' '
		OTHER = '?'
	;
	value DF0224f
		1 = "[1]7-9 p.m."
		2 = "[2]3-5 p.m."
		3 = "[3]11 a.m.-1 p.m."
		4 = "[4]8-10 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0225f
		1 = "[1]Would be in good form"
		2 = "[2]Would be in reasonable form"
		3 = "[3]Would find it difficult"
		4 = "[4]Would find it very difficult"
		. = ' '
		OTHER = '?'
	;
	value DF0226f
		1 = "[1]5 hours starting between 5 p.m. and 4 a.m."
		2 = "[2]5 hours starting between 2 p.m. and 5 p.m."
		3 = "[3]5 hours starting between 9 a.m. and 2 p.m."
		4 = "[4]5 hours starting between 8 a.m. and 9 a.m."
		5 = "[5]5 hours starting between 4 a.m. and 8 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0227f
		1 = "[1]10 pm-5 a.m."
		2 = "[2]5-10 p.m."
		3 = "[3]10 a.m-5 p.m."
		4 = "[4]8-10 a.m."
		5 = "[5]5-8 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0228f
		0 = "[0]Definitely an evening type"
		2 = "[2]Rather more an evening type than a morning type"
		4 = "[4]Rather more a morning type than an evening type"
		6 = "[6]Definitely a morning type"
		. = ' '
		OTHER = '?'
	;
	value DF0229f
		1 = "[1]Please let me review my answers from the beginning"
		2 = "[2]My answers are correct - please continue"
		. = ' '
		OTHER = '?'
	;
run;

/*
data cet7.summary; set cet7.summary;
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
	format d_sleep_darkroom DF0019f.;
	format d_wake_withlight DF0020f.;
	format d_outsidelight_work DF0021f.;
	format d_outsidelight_nonwork DF0022f.;
	format d_height_units DF0023f.;
	format d_weight_units DF0024f.;
	format d_height_feet DF0025f.;
	format d_height_inches DF0026f.;
	format askPIDS DF0027f.;
	format A1 DF0028f.;
	format A2 DF0029f.;
	format A3 DF0030f.;
	format A4 DF0031f.;
	format A5 DF0032f.;
	format A6 DF0033f.;
	format A7 DF0034f.;
	format A8 DF0035f.;
	format A9 DF0036f.;
	format B1 DF0037f.;
	format B2 DF0038f.;
	format B3 DF0039f.;
	format B4 DF0040f.;
	format B5 DF0041f.;
	format B6 DF0042f.;
	format B7 DF0043f.;
	format C1A_Non DF0044f.;
	format C1A_Jan DF0045f.;
	format C1A_Feb DF0046f.;
	format C1A_Mar DF0047f.;
	format C1A_Apr DF0048f.;
	format C1A_May DF0049f.;
	format C1A_Jun DF0050f.;
	format C1A_Jul DF0051f.;
	format C1A_Aug DF0052f.;
	format C1A_Sep DF0053f.;
	format C1A_Oct DF0054f.;
	format C1A_Nov DF0055f.;
	format C1A_Dec DF0056f.;
	format C1B_Non DF0057f.;
	format C1B_Jan DF0058f.;
	format C1B_Feb DF0059f.;
	format C1B_Mar DF0060f.;
	format C1B_Apr DF0061f.;
	format C1B_May DF0062f.;
	format C1B_Jun DF0063f.;
	format C1B_Jul DF0064f.;
	format C1B_Aug DF0065f.;
	format C1B_Sep DF0066f.;
	format C1B_Oct DF0067f.;
	format C1B_Nov DF0068f.;
	format C1B_Dec DF0069f.;
	format C2A_Non DF0070f.;
	format C2A_Jan DF0071f.;
	format C2A_Feb DF0072f.;
	format C2A_Mar DF0073f.;
	format C2A_Apr DF0074f.;
	format C2A_May DF0075f.;
	format C2A_Jun DF0076f.;
	format C2A_Jul DF0077f.;
	format C2A_Aug DF0078f.;
	format C2A_Sep DF0079f.;
	format C2A_Oct DF0080f.;
	format C2A_Nov DF0081f.;
	format C2A_Dec DF0082f.;
	format C2B_Non DF0083f.;
	format C2B_Jan DF0084f.;
	format C2B_Feb DF0085f.;
	format C2B_Mar DF0086f.;
	format C2B_Apr DF0087f.;
	format C2B_May DF0088f.;
	format C2B_Jun DF0089f.;
	format C2B_Jul DF0090f.;
	format C2B_Aug DF0091f.;
	format C2B_Sep DF0092f.;
	format C2B_Oct DF0093f.;
	format C2B_Nov DF0094f.;
	format C2B_Dec DF0095f.;
	format C3A_Non DF0096f.;
	format C3A_Jan DF0097f.;
	format C3A_Feb DF0098f.;
	format C3A_Mar DF0099f.;
	format C3A_Apr DF0100f.;
	format C3A_May DF0101f.;
	format C3A_Jun DF0102f.;
	format C3A_Jul DF0103f.;
	format C3A_Aug DF0104f.;
	format C3A_Sep DF0105f.;
	format C3A_Oct DF0106f.;
	format C3A_Nov DF0107f.;
	format C3A_Dec DF0108f.;
	format C3B_Non DF0109f.;
	format C3B_Jan DF0110f.;
	format C3B_Feb DF0111f.;
	format C3B_Mar DF0112f.;
	format C3B_Apr DF0113f.;
	format C3B_May DF0114f.;
	format C3B_Jun DF0115f.;
	format C3B_Jul DF0116f.;
	format C3B_Aug DF0117f.;
	format C3B_Sep DF0118f.;
	format C3B_Oct DF0119f.;
	format C3B_Nov DF0120f.;
	format C3B_Dec DF0121f.;
	format C4A_Non DF0122f.;
	format C4A_Jan DF0123f.;
	format C4A_Feb DF0124f.;
	format C4A_Mar DF0125f.;
	format C4A_Apr DF0126f.;
	format C4A_May DF0127f.;
	format C4A_Jun DF0128f.;
	format C4A_Jul DF0129f.;
	format C4A_Aug DF0130f.;
	format C4A_Sep DF0131f.;
	format C4A_Oct DF0132f.;
	format C4A_Nov DF0133f.;
	format C4A_Dec DF0134f.;
	format C4B_Non DF0135f.;
	format C4B_Jan DF0136f.;
	format C4B_Feb DF0137f.;
	format C4B_Mar DF0138f.;
	format C4B_Apr DF0139f.;
	format C4B_May DF0140f.;
	format C4B_Jun DF0141f.;
	format C4B_Jul DF0142f.;
	format C4B_Aug DF0143f.;
	format C4B_Sep DF0144f.;
	format C4B_Oct DF0145f.;
	format C4B_Nov DF0146f.;
	format C4B_Dec DF0147f.;
	format C5A_Non DF0148f.;
	format C5A_Jan DF0149f.;
	format C5A_Feb DF0150f.;
	format C5A_Mar DF0151f.;
	format C5A_Apr DF0152f.;
	format C5A_May DF0153f.;
	format C5A_Jun DF0154f.;
	format C5A_Jul DF0155f.;
	format C5A_Aug DF0156f.;
	format C5A_Sep DF0157f.;
	format C5A_Oct DF0158f.;
	format C5A_Nov DF0159f.;
	format C5A_Dec DF0160f.;
	format C5B_Non DF0161f.;
	format C5B_Jan DF0162f.;
	format C5B_Feb DF0163f.;
	format C5B_Mar DF0164f.;
	format C5B_Apr DF0165f.;
	format C5B_May DF0166f.;
	format C5B_Jun DF0167f.;
	format C5B_Jul DF0168f.;
	format C5B_Aug DF0169f.;
	format C5B_Sep DF0170f.;
	format C5B_Oct DF0171f.;
	format C5B_Nov DF0172f.;
	format C5B_Dec DF0173f.;
	format C6A_Non DF0174f.;
	format C6A_Jan DF0175f.;
	format C6A_Feb DF0176f.;
	format C6A_Mar DF0177f.;
	format C6A_Apr DF0178f.;
	format C6A_May DF0179f.;
	format C6A_Jun DF0180f.;
	format C6A_Jul DF0181f.;
	format C6A_Aug DF0182f.;
	format C6A_Sep DF0183f.;
	format C6A_Oct DF0184f.;
	format C6A_Nov DF0185f.;
	format C6A_Dec DF0186f.;
	format C6B_Non DF0187f.;
	format C6B_Jan DF0188f.;
	format C6B_Feb DF0189f.;
	format C6B_Mar DF0190f.;
	format C6B_Apr DF0191f.;
	format C6B_May DF0192f.;
	format C6B_Jun DF0193f.;
	format C6B_Jul DF0194f.;
	format C6B_Aug DF0195f.;
	format C6B_Sep DF0196f.;
	format C6B_Oct DF0197f.;
	format C6B_Nov DF0198f.;
	format C6B_Dec DF0199f.;
	format D1 DF0200f.;
	format D2 DF0201f.;
	format D3 DF0202f.;
	format D4 DF0203f.;
	format D5 DF0204f.;
	format D6 DF0205f.;
	format D7 DF0206f.;
	format D8 DF0207f.;
	format D9 DF0208f.;
	format q1 DF0209f.;
	format q2 DF0210f.;
	format d_abnl_sleep_cont DF0211f.;
	format q3 DF0212f.;
	format q4 DF0213f.;
	format q5 DF0214f.;
	format q6 DF0215f.;
	format q7 DF0216f.;
	format q8 DF0217f.;
	format q9 DF0218f.;
	format q10 DF0219f.;
	format q11 DF0220f.;
	format q12 DF0221f.;
	format q13 DF0222f.;
	format q14 DF0223f.;
	format q15 DF0224f.;
	format q16 DF0225f.;
	format q17 DF0226f.;
	format q18 DF0227f.;
	format q19 DF0228f.;
	format Feedback0 DF0229f.;
run;
*/