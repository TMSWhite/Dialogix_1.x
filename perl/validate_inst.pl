#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# This perl script checks whether any equation references a variable before it is defined
# Usage:
#		perl validate_inst.pl <directory name> <log file>
#	(so reads instrument from inst.txt, and writes writes the file with embedded error messages to out.txt, and writes just the errors to errs.txt)


use strict;

use File::Basename;
use Dialogix::Utils;
use Digest::MD5 qw(md5_hex);


if (!($#ARGV == 0)) {
	print "Usage:\nperl validate_inst.pl <config_file>";
	exit;
}

my (@gargs,$Prefs,$conf_file);
@gargs = @ARGV;
$conf_file = shift(@gargs);

my %varnames;
my %uniqueNames = ();

my $levelTypes = {
	check => 'NOMINAL',
	combo => 'NOMINAL',
	combo2 => 'NOMINAL',
	date => 'SCALE',
	day => 'SCALE',
	day_num => 'SCALE',		# since start of year.
	double => 'SCALE',
	hour => 'SCALE',
	list => 'NOMINAL',
	list2 => 'NOMINAL',
	memo => 'NOMINAL',
	minute => 'SCALE',
	month => 'NOMINAL',		# since name of the month
	month_num => 'SCALE',
	nothing => 'NOMINAL',
	password => 'NOMINAL',
	radio => 'NOMINAL',
	radio2 => 'NOMINAL',
	radio3 => 'NOMINAL',
	second => 'SCALE',
	text => 'NOMINAL',
	time => 'NOMINAL',
	weekday => 'NOMINAL',	# since name of weekday
	year => 'SCALE',
};


# formats reference SPSS data types -- the date formats have not been validated yet
my $SPSSformats = {
	check => 'F8.0',
	combo => 'F8.0',
	combo2 => 'F8.0',
	date => 'ADATE10',
	day => 'date|dd',		# what is syntax for this?
	day_num => 'date|dd',		# since start of year.
	double => 'F8.3',
	hour => 'date|hh',
	list => 'F8.0',
	list2 => 'F8.0',
	memo => 'A254',
	minute => 'date|mm',
	month => 'MONTH',		# since name of the month
	month_num => 'date|mm',
	nothing => 'F8.2',
	password => 'A50',
	radio => 'F8.0',
	radio2 => 'F8.0',
	radio3 => 'F8.0',
	second => 'date|ss',
	text => 'A100',
	time => 'A9',	# was TIME5.3, but seemed to cause problems on import
	weekday => 'WKDAY',	# since name of weekday
	year => 'date|yyyy',	
};

# informats reference SAS data types -- the date formats have not been validated yet
my $SASinformats = {
	check => 'best32.',
	combo => 'best32.',
	combo2 => 'best32.',
	date => 'mmddyy10.',
	day => '$6.',			# wrong
	day_num => 'best32.',	# hack
	double => 'best32.',
	hour => 'best32.',
	list => 'best32.',
	list2 => 'best32.',
	memo => '$254.',
	minute => 'best32.',
	month => '$10.',		# hack
	month_num => 'best32.',	# hack
	nothing => 'best32.',
	password => '$50.',
	radio => 'best32.',
	radio2 => 'best32.',
	radio3 => 'best32.',
	second => 'best32.',
	text => '$100.',
	time => 'time8.0',	
	weekday => '$10.',	# hack
	year => 'best32.',	# hack
};

# formats reference SAS data types -- the date formats have not been validated yet
my $SASformats = {
	check => 'best12.',
	combo => 'best12.',
	combo2 => 'best12.',
	date => 'mmddyy10.',
	day => '$6.',			# wrong
	day_num => 'day2.',	# hack
	double => 'best12.',
	hour => 'hour2.',
	list => 'best12.',
	list2 => 'best12.',
	memo => '$254.',
	minute => 'best12.',
	month => '$10.',		# hack
	month_num => 'best12',	# hack
	nothing => 'best12.',
	password => '$50.',
	radio => 'best12.',
	radio2 => 'best12.',
	radio3 => 'best12.',
	second => 'best12.',
	text => '$100.',
	time => 'time8.0',	
	weekday => '$10.',	# hack
	year => 'best12.',				# hack
};

# formats reference SPSS data types -- the date formats have not been validated yet
my $supportsMissing = {
	check => 1,
	combo => 1,
	combo2 => 1,
	date => 1,
	day => 0,
	day_num => 1,
	double => 1,
	hour => 1,
	list => 1,
	list2 => 1,
	memo => 0,
	minute => 1,
	month => 1,
	month_num => 1,
	nothing => 1,
	password => 1,
	radio => 1,
	radio2 => 1,
	radio3 => 1,
	second => 1,
	text => 0,
	time => 0,
	weekday => 1,
	year => 1,
};


&main();


sub main {
	$Prefs = &Dialogix::Utils::readDialogixPrefs($conf_file);
	&Dialogix::Utils::mychdir($Prefs->{INSTRUMENT_DIR});

	open (LOG,">validate_instruments.log") or die "unable to write log to validate_instruments.log";
	
	&initMysqlTables;
	
	&look($Prefs->{INSTRUMENT_DIR});
	
	&closeMysqlTables;
	
	close (LOG);
}

sub initMysqlTables {
	open (MYSQL_META, ">InstrumentMeta.mysql") or die "unable to open InstrumentMeta.mysql";
#	print MYSQL_META "NULL\tInstrumentName\tTitle\tVersion\tCreationDate\tNumVars\tVarListMD5\tInstrumentMD5\tLanguageList\tNumLanguages" .
#		"\tNumInstructions\tNumEquations\tNumQuestions\tNumBranches\tNumTailorings\n";

		
	open (MYSQL_CONTENTS, ">InstrumentContents.mysql") or die "unable to open InstrumentContents.mysql";
#	print MYSQL_CONTENTS "NULL\tInstrumentName\tStepNum\tVarName\tc8name\tDisplayName\tGroupNum" .
#			"\tConcept\tRelevance\tActionType" .
#			"\tValidation\tReturnType\tMinVal\tMaxVal\tOtherVals\tInputMask\tFormatMask" .
#			"\tDisplayType\tisRequired\tisMessage" .
#			"\tLevel\tSPSSformat\tSASinformat\tSASformat\tAnswersNumeric" .
#			"\tDefaultAnswer\tDefaultComment\n";
			
	open (MYSQL_HEADERS, ">InstrumentHeaders.mysql") or die "unable to open InstrumentHeaders.mysql";
#	print MYSQL_HEADERS "NULL\tInstrumentName\tReservedVarName\tValue\n";
			
	open (MYSQL_TRANSLATIONS, ">InstrumentTranslations.mysql") or die "unable to open InstrumentTranslations.mysql";
#	print MYSQL_TRANSLATIONS "NULL\tInstrumentName\tLanguageNum\tLanguageName\tVarNum\tVarName\tc8name\tActionType" . 
#			"\tDescription\tActionPhrase\tDisplayType\tAnswerOptions\tHelpURL" .
#			"\tQlen\tAlen\tQuestMD5\tAnswerMD5\n";	
			
	&createMysqlTables;
}

sub closeMysqlTables {
	close (MYSQL_META);
	close (MYSQL_CONTENTS);
	close (MYSQL_HEADERS);
	close (MYSQL_TRANSLATIONS);
}

sub look {
	my @files = glob(shift);
	
	foreach (@files) {
		&processDir($_);
	}
}

sub processDir {
	my $file = shift;
	
	if (-d $file) {
		&look("$file/*");
	}
	else {
		return unless ($file =~ /^.+\.src$/);
		print LOG "[$file]\t";
		print LOG &processFile($file) . "\n";
	}
}

sub init {
	%varnames = ();	# empty the array
	%uniqueNames = ();
	
	my @funcs = (
		"abs",
		"acos",
		"asin",
		"atan",
		"atan2",
		"ceil",
		"charAt",
		"compareTo",
		"compareToIgnoreCase",
		"cos",
		"count",
		"createTempFile",
		"desc",
		"e",
		"endsWith",
		"eraseData",
		"exec",
		"exp",
		"fileExists",
		"floor",
		"formatDate",
		"formatNumber",
		"getActionText",
		"getAnsOption",
		"getComment",
		"getConcept",
		"getrelevance",
		"getExternalName",
		"getLocalName",
		"getNow",
		"getStartTime",
		"getType",
		"gotoFirst",
		"gotoNext",
		"gotoPrevious",
		"hasComment",
		"indexOf",
		"isAnswered",
		"isAsked",
		"isDate",
		"isInvalid",
		"isNA",
		"isNotUnderstood",
		"isNumber",
		"isRefused",
		"isSpecial",
		"isUnknown",
		"jumpTo",
		"jumpToFirstUnasked",
		"lastIndexOf",
		"length",
		"list",
		"log",
		"max",
		"mean",
		"min",
		"newDate",
		"newTime",
		"numAnsOptions",
		"orlist",
		"parseDate",
		"parseNumber",
		"pi",
		"pow",
		"random",
		"regexMatch",
		"round",
		"saveData",
		"setStatusCompleted",
		"sin",
		"sqrt",
		"startsWith",
		"stddev",
		"substring",
		"suspendToFloppy",
		"tan",
		"toDate",
		"toDay",
		"toDayNum",
		"toHour",
		"toLowerCase",
		"toMinute",
		"toMonth",
		"toMonthNum",
		"toSecond",
		"toTime",
		"toUpperCase",
		"toWeekday",
		"toYear",
		"todegrees",
		"toradians",
		"trim",
		);

	my @reserveds = (
		"__ACTIVE_BUTTON_PREFIX__",
		"__ACTIVE_BUTTON_SUFFIX__",
		"__ALLOW_COMMENTS__",
		"__ALLOW_DONT_UNDERSTAND__",
		"__ALLOW_JUMP_TO__",
		"__ALLOW_LANGUAGE_SWITCHING__",
		"__ALLOW_REFUSED__",
		"__ALLOW_UNKNOWN__",
		"__ALWAYS_SHOW_ADMIN_ICONS__",
		"__ANSWER_OPTION_FIELD_WIDTH__",
		"__AUTOGEN_OPTION_NUM__",
		"__BROWSER_TYPE__",
		"__COMMENT_ICON_OFF__",
		"__COMMENT_ICON_ON__",
		"__COMPLETED_DIR__",
		"__CONNECTION_TYPE__",
		"__CURRENT_LANGUAGE__",
		"__DEBUG_MODE__",
		"__DEVELOPER_MODE__",
		"__DISALLOW_COMMENTS__",
		"__DISPLAY_COUNT__",
		"__DONT_UNDERSTAND_ICON_OFF__",
		"__DONT_UNDERSTAND_ICON_ON__",
		"__FILENAME__",
		"__FLOPPY_DIR__",
		"__HEADER_MSG__",
		"__HELP_ICON__",
		"__ICON__",
		"__IMAGE_FILES_DIR__",
		"__IP_ADDRESS__",
		"__JUMP_TO_FIRST_UNASKED__",
		"__LANGUAGES__",
		"__LOADED_FROM__",
		"__PASSWORD_FOR_ADMIN_MODE__",
		"__RECORD_EVENTS__",
		"__REDIRECT_ON_FINISH_MSG__",
		"__REDIRECT_ON_FINISH_URL__",
		"__REFUSED_ICON_OFF__",
		"__REFUSED_ICON_ON__",
		"__SCHEDULE_DIR__",
		"__SCHEDULE_SOURCE__",
		"__SCHED_AUTHORS__",
		"__SCHED_HELP_URL__",
		"__SCHED_VERSION_MAJOR__",
		"__SCHED_VERSION_MINOR__",
		"__SET_DEFAULT_FOCUS__",
		"__SHOW_ADMIN_ICONS__",
		"__SHOW_QUESTION_REF__",
		"__SHOW_SAVE_TO_FLOPPY_IN_ADMIN_MODE__",
		"__STARTING_STEP__",
		"__START_TIME__",
		"__SUSPEND_TO_FLOPPY__",
		"__SWAP_NEXT_AND_PREVIOUS__",
		"__TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS__",
		"__TITLE__",
		"__TRICEPS_FILE_TYPE__",
		"__TRICEPS_VERSION_MAJOR__",
		"__TRICEPS_VERSION_MINOR__",
		"__UNKNOWN_ICON_OFF__",
		"__UNKNOWN_ICON_ON__",
		"__WORKING_DIR__",
		"__WRAP_ADMIN_ICONS__",

		);
	
	foreach (@funcs) { $varnames{$_} = $_; }
	foreach (@reserveds) { $varnames{$_} = $_; }
}

sub processFile {
	my $srcfile = shift;
	my $errfile = "$srcfile.errs";
	my $instname = basename($srcfile,"\.src");
	my ($filename,$inst,$timestamp,$when,$title,$version,$languagelist,$numvars,$varmd5) = &Dialogix::Utils::whichInstrument($srcfile);
	my $data_for_md5;
	my ($numInstructions, $numEquations, $numQuestions, $numBranches, $numTailorings) = (0,0,0,0,0);
	
	my @languages = split(/\|/,$languagelist);
	
	&init();
	
	my $fileCreationDate = &FileCreationDate($srcfile);
	
	if (!open (SRC,$srcfile)) {
		return "unable to read from $srcfile";
	}
	my @lines = (<SRC>);	# read entire file
	close (SRC);
	if (!open (ERR,">$errfile")) {
		return "unable to open $errfile to write errors";
	}
	
	# Validate that variables are not referenced until after they are defined; and check for  unmatched parentheses in equations
	my ($linenum, $stepNum, $dispGroup, $in_block) = (0,0,0,0);
	my $reservedcount = 0;
	my ($errCount,$parsedLine) = (0,'');
	foreach (@lines) {
		chomp;
		++$linenum;
		print ERR "[Line $linenum]\t$_\n";
		my $outline;
		my @temp = split(/\t/);
		my ($qtext, $qlen, $qmd5, $amd5);
		my ($atype, $ansMap, $atext, $alen, $isString, $isNum, $level, $SPSSformat, $SASinformat, $SASformat);
	
		if (/^\s*$/) {
			next;
		}
		elsif (/^\s*(COMMENT|RESERVED)(.*)$/) {
			#if line begins with COMMENT, RESERVED, or blank, ignore it
			++$reservedcount;
			if ($temp[0] eq 'RESERVED') {
				print MYSQL_HEADERS "NULL\t$instname\t$temp[1]\t$temp[2]\n";
			}
		}
		else {
			if ($reservedcount < 5) {
				# this is clearly not a Dialogix file
				close(ERR);
				unlink $errfile unless (-d $errfile);
				return "not a Dialogix instrument file";
			}
			
			my @args;
			foreach (@temp) { push @args, &fixExcelisms($_); }
			
			my $concept = shift(@args);
			my $intName = &fixExcelisms(shift(@args));
			my $c8name = &getUniqueName($intName);

			my $extName = shift(@args);
			my $relevance = shift(@args);
			
			# now that have processed that line, make the variable defined for future equations (or should this be done after the line is processed?)
			$varnames{$intName} = $intName;				

			my $questionOrEvalType = shift(@args);
			
			$outline = qq|$concept\t$intName\t$extName\t|;
			($parsedLine, $errCount) = &parseExpr($errCount,$relevance);
			$outline .= $parsedLine . "\t";
						
			@temp = split(/;/,$questionOrEvalType);
			my ($ReturnType,$MinVal,$MaxVal,$OtherVals,$InputMask,$FormatMask) = ('','','','','','');
			my $actionTypeOnly = shift(@temp);
			my $validation = join(';',@temp);
			$outline .= $actionTypeOnly;
			$ReturnType = shift(@temp);
			$outline .= ';' . $ReturnType	if ($ReturnType);	# return type;
			my $validation_segment=2;
			while (@temp) {
				my $arg = shift(@temp);
				$MinVal = $arg if ($validation_segment == 2);
				$MaxVal = $arg if ($validation_segment == 3);
				if ($validation_segment == 4) {
					if ($arg =~ /^PERL5(.*)$/) {
						$InputMask = $1;
					}
					else {
						$FormatMask = $arg;
					}
				}
				if ($validation_segment == 5) {
					$OtherVals = join(';',($arg,@temp));
				}

				if ($validation_segment == 4) {
					($parsedLine, $errCount) = &parseString($errCount,$arg);
				}
				else {
					
					($parsedLine, $errCount) = &parseExpr($errCount,$arg);
				}
				++$validation_segment;
				$outline .= ';' . $parsedLine;
			}
			
			my ($readback,$answerType,$displayType,$qOrEval,$answerList,$helpURL);

			# now parse the rest of the data, allowing for multiple languages 
			# need to count the languages so can cross-reference
			my $langCount = 0;
			my ($defaultAnswer,$defaultComment);
			while (@args) {
				$readback = shift(@args);
				($parsedLine, $errCount) = &parseString($errCount,$readback);
				$outline .= "\t" . 	$parsedLine;	# readback
				
				# questions and expressions have different syntax, so parse accordingly
				$qOrEval = shift(@args);
				
				#determine whether a real language, or just the default values
				if ($qOrEval =~ /^\s*$/) {
					$defaultAnswer = shift(@args);
					$defaultComment = shift(@args);
					last;
				}
								
				if ($questionOrEvalType =~ /^e/i) {
					($parsedLine, $errCount) = &parseExpr($errCount,$qOrEval);
					$outline .= "\t" . $parsedLine;
				}
				else {
					($parsedLine, $errCount) = &parseString($errCount,$qOrEval);
					$outline .= "\t" . $parsedLine;
				}
				
				my $ansOptions = shift(@args);
				
				($atype, $ansMap, $atext, $alen, $isString, $isNum, $level, $SPSSformat, $SASinformat, $SASformat) = &cat_ans($ansOptions);
				
				@temp = split(/\|/,$ansOptions);	# answer options
				$displayType  = shift(@temp);
				$answerList = join('|',@temp);
				$outline .= "\t" . $displayType;	# the display type, if any
				while(@temp) {
					($parsedLine, $errCount) = &parseExpr($errCount,shift(@temp));
					$outline .= '|' . $parsedLine;	# the return value
					($parsedLine, $errCount) = &parseString($errCount,shift(@temp));
					$outline .= '|' . $parsedLine;	# the display message
				}
				$helpURL = shift(@args);
				
				$outline .= "\t" . $helpURL;					# helpURL
				
				$qtext = &strip_html($qOrEval);
				$qlen = length($qtext);
				$qmd5 = md5_hex($qtext);
				$amd5 = md5_hex($atext);
				
				print MYSQL_TRANSLATIONS "NULL\t$instname\t$langCount\t$languages[$langCount]\t$stepNum\t$intName\t$c8name\t$actionTypeOnly" . 
					"\t$readback\t$qOrEval\t$displayType\t$answerList\t$helpURL" .
					"\t$qlen\t$alen\t$qmd5\t$amd5\n";
					
				++$langCount;
			}
			$outline .= "\n";
			
			if ($outline =~ /\*NOTFOUND\:/) {
				print ERR "[ERROR: on line $linenum - undefined variables are bracketed by 'NOTFOUND']\t$outline";
			}
			
			my $isMessage = 0;
			if ($displayType eq 'nothing' and $actionTypeOnly !~ /e/i) {
				$isMessage = 1;
				++$numInstructions;
			}
			elsif ($actionTypeOnly =~ /e/i) {
				++$numEquations;
			}
			else {
				if ($qOrEval =~ /`/) {
					++$numTailorings;
				}
				++$numQuestions;
			}
			
			if ($relevance !~ /^\s*1\s*$/) {
				++$numBranches;
			}
			
			if ($isMessage == 1) {
				$level = '';
				$SPSSformat = '';
				$SASinformat = '';
				$SASformat = '';
				$isNum = '';
			}
			
			print MYSQL_CONTENTS "NULL\t$instname\t$stepNum\t$intName\t$c8name\t$extName\t$dispGroup\t" .
				"$concept\t$relevance\t$actionTypeOnly" .
				"\t$validation\t$ReturnType\t$MinVal\t$MaxVal\t$OtherVals\t$InputMask\t$FormatMask" .
				"\t$displayType\t1\t$isMessage" .
				"\t$level\t$SPSSformat\t$SASinformat\t$SASformat\t$isNum" .
				"\t$defaultAnswer\t$defaultComment\n";
				
			++$stepNum;			
			# Determine whether this is a display group
			if ($actionTypeOnly eq '[') {
				$in_block = 1;
			}
			if ($actionTypeOnly eq ']') {
				$in_block = 0;
			}
			++$dispGroup if ($in_block == 0);		
			
			my @outtemp = split(/\t/,$outline);
			shift(@outtemp);	# remove concept -- irrelevant for display purposes
			$data_for_md5 .= join("\t",@outtemp);
		}
	}
	
	close(ERR);
	
	my $instmd5 = md5_hex($data_for_md5);

	print MYSQL_META "NULL\t$instname\t$title\t$version\t$fileCreationDate\t$numvars\t$varmd5\t$instmd5\t$languagelist\t" . 
		($#languages + 1) . 
		"\t$numInstructions\t$numEquations\t$numQuestions\t$numBranches\t$numTailorings\n";
	
	if ($errCount == 0) {
		# remove it if not needed
		unlink $errfile unless (-d $errfile);
	}
	return "$errCount error(s) were detected";
}


# Excel randomly surrounds strings with quotes, and replaces internal double quotes with a pair of
# double quotes.  This function reverses that process, without replacing escaped double quotes.
sub fixExcelisms {
	my $arg = shift;

	if ($arg =~ /^"(.*?)"$/) {
		$arg = $1;
		$arg =~ s/(?<!\\)""/"/g;
	}
	return $arg;
}

# This function extracts the back-tick (`) delimited expressions from a string, and
# returns the concatenation of the surrounding strings (which are not parsed), and the
# translated contents of the identified expressions.
sub parseString {
	my $in = 0;
	my ($errCount,$arg) = @_;
	my $parsedLine;
	my @args = split(/(`)/,$arg);
	my $retVal = "";

	for my $a (@args) {
		if ($a eq '`') {
			$in = ($in) ? 0 : 1;
			$retVal .= $a;
		}
		else {
			if ($in) {
				($parsedLine, $errCount) = &parseExpr($errCount,$a);
				$retVal .= $parsedLine;
			}
			else {
				$retVal .= $a;
#				print ERR "[ignore]$a\n";
			}
		}
	}
	return ($retVal, $errCount);
}

# This function extracts all strings (both single and double quote delimited) from an expression,
# and validates the existence of the non-string tokens (variable names)
# Escaped single and double quote characters are treated appropriately, as are strings embedded within other strings.
# This function returns the translated version of the string it is passed.
sub parseExpr {
	my ($errCount,$rest) = @_;
	my $parsedLine;
	my $retVal = "";
#	print ERR "[parsingExpr]$rest\n";
	my $eqnWithoutStrings;

	# extract strings
	while ($rest ne '') {
		if ($rest =~ /^((?:\\'|\\"|.)*?)('|")(.*)$/) {
			($parsedLine, $errCount) = &validateVarsInExpr($errCount,$1);
			$retVal .= $parsedLine;
			$eqnWithoutStrings .= $1;
			my $quot = $2;
			my $inStr = $3;
			if ($quot eq "\'") {
				if ($inStr =~ /^((?:\\'|\\"|.)*?)'(.*)$/) {
					$retVal .= qq|'$1'|;
					$rest = $2;
#					print ERR "[ignore]'$1'\n";
				}
				else {
					# unterminated string?
#					$rest = $quot . $inStr;
					$rest = "";
					print ERR "[ERROR: bad string]\t$inStr";
					++$errCount;
				}
			}
			else {
				if ($inStr =~ /^((?:\\'|\\"|.)*?)"(.*)$/) {
					$retVal .= qq|"$1"|;
					$rest = $2;
#					print ERR "[ignore]\"$1\"\n";
				}
				else {
					# unterminated string?
#					$rest = $quot . $inStr;
					$rest = "";
					print ERR "[ERROR: bad string]\t$inStr";
					++$errCount;
				}
			}

		}
		else {
			($parsedLine, $errCount) = &validateVarsInExpr($errCount,$rest);
			$retVal .= $parsedLine;
			$eqnWithoutStrings .= $rest;
			$rest = "";
		}
	}
	
	# assess whether there are parentheses mismatches
	my @toks = split(/([\(\)])/,$eqnWithoutStrings);
	my $parencount = 0;
	my @parenerrs;
	my $column = 1;
	foreach my $tok (@toks) {
		if ($tok eq '(') {
			++$parencount;
		}
		if ($tok eq ')') {
			--$parencount;
			if ($parencount < 0) {
				push @parenerrs, "Extra closing ')' at column $column";
				$parencount = 0;	# so can detect multiple errors
			}
		}
		$column += length($tok);
	}
	if ($parencount > 0) {
		push @parenerrs, "Missing $parencount closing ')'s at end of equation";
	}
	if ($#parenerrs > 0) {
		print ERR "[ERROR: unmatched parentheses in]\t" . $eqnWithoutStrings . "\n";
		++$errCount;
		foreach my $i (1 .. ($#parenerrs+1)) {
			print ERR "[ERROR $i]\t$parenerrs[$i-1]\n";
		}
	}
	
	return ($retVal, $errCount);
}

# This function is passed non-string equations.  It finds all valid variable names (which can only
# contain alphanumeric characters or underscores).  If the variable is not defined, 
# the string *NOTFOUND:<$val>* is subtitued for the variable name to indicate that a problem occured.
# This function returns the string it was passed, with all problems highlighted.
sub validateVarsInExpr {
	my ($errCount,$rest) = @_;
	my $hasErrors = 0;
	my $retVal = "";
	my @tokens;
#	print ERR "[validating]$rest\n";
	my $hasErrors = 0;

	while ($rest ne '') {
		if ($rest =~ /^(\W*)(\w*)(.*)$/) {
			my $val = $2;
			$rest = $3;

			$retVal .= $1;

			if ($val =~ /^\d*$/) {
				# simply a number
				$retVal .= $val;
			}
			else {
				my $lookup = $varnames{$val};
				if ($lookup ne $val) {
					$retVal .= "*NOTFOUND:<$val>*";
					print ERR "[ERROR: undefined variable]\t$val\n";
					$hasErrors = 1;
				}
				else {
					$retVal .= $lookup;
				}
				push @tokens, $val;
			}
		}
		else {
			$retVal .= $rest;
			print ERR "[ERROR: not validating]\t$rest\n";
			$hasErrors = 1;
			$rest = "";
		}
	}
	if ($#tokens > 0) {
#		print ERR "[tokens]" . join("\t", @tokens), "\n";
	}

	return ($retVal, ($errCount + $hasErrors));
}

sub qlen {
	my $arg = shift;
	my $text = &strip_html($arg);
	return length($text);
	
}

sub cat_ans {
	my $arg = shift;
	my (@vals, $atype, $count, $text, %ansMap, $isString, $isNum, $level, $SPSSformat, $SASinformat, $SASformat);
	
	if ($arg !~ /\|/) {
		# then double, date, etc.
		@vals = ();
		$atype = lc($arg);
	}
	else {
		@vals = split(/\|/,$arg);
		$atype = lc($vals[0]);
	}
	
	# need to determine whether all internal variable names are strings or numbers -- if even a single one is a string, must make all strings
	
	if ($#vals > 0) {
		$isString = 0;
		$count=0;
		while ($count < $#vals) {
			$count += 2;
			my $key = $vals[$count-1];
			if ($key !~ /^-?[0-9.]+$/) {
				# if not a number, then must be a string
				$isString = 1;
			}
		}
		$count = 0;
		while ($count < $#vals) {
			$count += 2;
			my $strippedAns = &strip_html($vals[$count]);
			$text .= ' ' . $strippedAns;	# so have all text
			my $key = $vals[$count-1];
			if ($isString) {
				# convert single to double quotes
				if ($key =~ /^'(.+)'$/) {
					$key = qq|"$1"|;
				}
				if ($key =~ /^-?[0-9.]$/) {	# if a number, add surrounding quotes
					$key = qq|"$key"|;
				}
			}
			$ansMap{$key} = $strippedAns; # so have mapping of answer to text for data dictionary
		}
	}
	else {
		$isString = 0;
		%ansMap = {};
	}
	
	$level = $levelTypes->{$atype};
	$SPSSformat = $SPSSformats->{$atype};
	$SASinformat = $SASinformats->{$atype};
	$SASformat = $SASformats->{$atype};
	
	if ($isString) {
		$SPSSformat = 'A8' if ($SPSSformat =~ /^F/); # must be short enough that can do frequency analyses
		$SASinformat = '$25.';
		$SASformat = '$25.';
	}
	
	$isNum = !$isString;
	# dates and times do not support missing values!?
	if (!$supportsMissing->{$atype}) {
		$isString = 0;
		$isNum = 0;
	}
	
	return ($atype, \%ansMap, $text, length($text), $isString, $isNum, $level, $SPSSformat, $SASinformat, $SASformat);
}

sub strip_html {
	my $arg = shift;
	my $text = join(' ',split(/<.+?>|`.+?`|&.+?;/,$arg));
	$text = join(' ',split(/\s+/,$text));
	return $text;
}



sub getUniqueName {
	my $name = shift;
	my $ucname = uc($name);
	# replace starting underscore with 'X', since SPSS doesn't like them
	$ucname =~ s/^_/X/;
	
	my $longest = &getLongestValidSubName($ucname);
	my $c5name = substr($longest,0,5);
	
	# assess whether the name has been used before
	my $count = $uniqueNames{$name};
	
	if (defined($count) || defined($uniqueNames{$longest})) {
		# then name has been used, so look at counter of base name
		++$count;
		++$uniqueNames{$name};
		
		my $lcount = $uniqueNames{$longest};	# has the longest name been used yet?
		
		if (defined($lcount)) {
			# then the 8 char name has been used
			$lcount = 1 + $uniqueNames{$c5name};	# can't use longest, so get next c5 index
			$uniqueNames{$c5name} = $lcount;
			++$uniqueNames{$longest}	unless ($longest eq $c5name);
			
			return sprintf("%s%03d",$c5name,$lcount);
		}
		else {
			#can use longest
			++$uniqueNames{$longest}	unless ($longest eq $name);
			++$uniqueNames{$c5name}		unless ($c5name eq $longest);
			return $longest;
		}
	}
	else {
		++$uniqueNames{$c5name};	# so that base name is considered used
		++$uniqueNames{$longest}	unless ($longest eq $c5name);	# so that marked as used
		++$uniqueNames{$name}	unless ($name eq $longest);
		return $longest;	# must use truncated name
	}
}

sub getLongestValidSubName {
	my $name = shift;
	# start with length of 8
	my $len = (length($name) > 8) ? 8 : length($name);
	my $arg;
	
	while ($len > 0) {
		$arg = substr($name,0,$len);
		if ($arg =~ /^[A-Z_][A-Z0-9_]*$/) {
			return $arg;
		}
		--$len;
#		print "truncating $arg\n";
	}
#	print "bad name $name -- using XXX_\n";
	return "XXX_0000";
}

sub FileCreationDate {
	my $filename = shift;
	
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)
           = stat($filename);
           
	my $arg = localtime($mtime);
	if ($arg =~ /(\w+?)\s+(\w+?)\s+(\d+?)\s+(\d+?):(\d+?):(\d+?)\s+(\d\d\d\d)/) {
		#Wed Jun 06 14:18:33 2001
		return "$7-" . &month($2) . "-$3";
	}
}


sub month {
	$_ = shift;
	return '01' if (/Jan/i);
	return '02' if (/Feb/i);
	return '03' if (/Mar/i);
	return '04' if (/Apr/i);
	return '05' if (/May/i);
	return '06' if (/Jun/i);
	return '07' if (/Jul/i);
	return '08' if (/Aug/i);
	return '09' if (/Sep/i);
	return '10' if (/Oct/i);
	return '11' if (/Nov/i);
	return '12' if (/Dec/i);
	return '00';
}

sub createMysqlTables {
	open (MYSQL_TABLES,">InstrumentTableDefs.mysql") or die "unable to open InstrumentTableDefs.mysql";
	print MYSQL_TABLES qq|
		drop table if exists Dialogix.InstrumentMeta;
		create table Dialogix.InstrumentMeta (
			ID int(11) NOT NULL auto_increment,
			PRIMARY KEY  (ID),
			InstrumentName varchar(200) NOT NULL,
			Title text NOT NULL,
			Version varchar(20) NOT NULL,
			CreationDate varchar(10) NOT NULL,
			NumVars smallint NOT NULL,
			VarListMD5 varchar(35) NOT NULL,
			InstrumentMD5 varchar(35) NOT NULL,
			LanguageList text NOT NULL,
			NumLanguages smallint NOT NULL,
			NumInstructions smallint NOT NULL,
			NumEquations smallint NOT NULL,
			NumQuestions smallint NOT NULL,
			NumBranches smallint NOT NULL,
			NumTailorings smallint NOT NULL,
  			KEY InstrumentName (InstrumentName)
  		) TYPE=MyISAM;	
		
		drop table if exists Dialogix.InstrumentContents;
		create table Dialogix.InstrumentContents (
			ID int(11) NOT NULL auto_increment,
			PRIMARY KEY  (ID),
			InstrumentName varchar(200) NOT NULL,
			VarNum smallint NOT NULL,
			VarName varchar(100) NOT NULL,
			c8name varchar(10) NOT NULL,
			DisplayName text NULL,
			GroupNum smallint NOT NULL,
			Concept text NULL,
			Relevance text NOT NULL,
			ActionType char(1) NOT NULL,
			Validation text NULL,
			ReturnType varchar(10) NULL,
			MinVal text NULL,
			MaxVal text NULL,
			OtherVals text NULL,
			InputMask text NULL,
			FormatMask text NULL,
			DisplayType varchar(15) NOT NULL,
			IsRequired smallint NOT NULL,
			isMessage smallint NOT NULL,
			Level varchar(10) NULL,
			SPSSformat varchar(20) NULL,
			SASinformat varchar(20) NULL,
			SASformat varchar(20) NULL,
			AnswersNumeric smallint NULL,
			DefaultAnswer text NULL,
			DefaultComment text NULL,
  			KEY InstrumentName (InstrumentName)
		) TYPE=MyISAM;			
		
		drop table if exists Dialogix.InstrumentHeaders;
		create table Dialogix.InstrumentHeaders (
			ID int(11) NOT NULL auto_increment,
			PRIMARY KEY  (ID),
			InstrumentName varchar(200) NOT NULL,
			ReservedVarName varchar(100) NOT NULL,
			Value text NOT NULL,
  			KEY InstrumentName (InstrumentName)
		) TYPE=MyISAM;	
		
		drop table if exists Dialogix.InstrumentTranslations;
		create table Dialogix.InstrumentTranslations (
			ID int(11) NOT NULL auto_increment,
			PRIMARY KEY  (ID),
			InstrumentName varchar(200) NOT NULL,
			LanguageNum smallint NOT NULL,
			LanguageName varchar(10) NOT NULL,
			VarNum smallint NOT NULL,
			VarName varchar(100) NOT NULL,
			c8name varchar(10) NOT NULL,
			ActionType char(1) NOT NULL,
			Readback text NULL,
			ActionPhrase text NOT NULL,
			DisplayType varchar(15) NOT NULL,
			AnswerOptions text NOT NULL,
			HelpURL text NULL,
			QuestionLen smallint NOT NULL,
			AnswerLen smallint NOT NULL,
			QuestionMD5 varchar(35) NOT NULL,
			AnswerMD5 varchar(35) NOT NULL,
  			KEY InstrumentName (InstrumentName)
		) TYPE=MyISAM;
		
		LOAD DATA LOW_PRIORITY LOCAL 
				INFILE '/home/tmw/data0_for_mysql/InstrumentMeta.mysql' 
				INTO TABLE Dialogix.InstrumentMeta 
				FIELDS TERMINATED BY '\\t' ESCAPED BY '\\\\' LINES TERMINATED BY '\\r\\n';
				
		LOAD DATA LOW_PRIORITY LOCAL 
				INFILE '/home/tmw/data0_for_mysql/InstrumentContents.mysql' 
				INTO TABLE Dialogix.InstrumentContents 
				FIELDS TERMINATED BY '\\t' ESCAPED BY '\\\\' LINES TERMINATED BY '\\r\\n';
				
		LOAD DATA LOW_PRIORITY LOCAL 
				INFILE '/home/tmw/data0_for_mysql/InstrumentHeaders.mysql' 
				INTO TABLE Dialogix.InstrumentHeaders 
				FIELDS TERMINATED BY '\\t' ESCAPED BY '\\\\' LINES TERMINATED BY '\\r\\n';
				
		LOAD DATA LOW_PRIORITY LOCAL 
				INFILE '/home/tmw/data0_for_mysql/InstrumentTranslations.mysql' 
				INTO TABLE Dialogix.InstrumentTranslations 
				FIELDS TERMINATED BY '\\t' ESCAPED BY '\\\\' LINES TERMINATED BY '\\r\\n';												

	|;
	
	close (MYSQL_TABLES);
}
		
				
