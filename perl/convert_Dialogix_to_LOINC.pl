#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# This perl script checks whether any equation references a variable before it is defined
# Usage:
#		perl validate_inst.pl <directory name> <log file>
#	(so reads instrument from inst.txt, and writes writes the file with embedded error messages to out.txt, and writes just the errors to errs.txt)

use strict;

my %varnames;

&main(@ARGV);

sub main {
	if (!($#ARGV == 1)) {
		print "Usage:\nperl validate_inst.pl <directory> <logfile_name>";
		exit;
	}
	my $dir = shift(@ARGV);
	my $log = shift(@ARGV);
	open (LOG,">$log") or die "unable to write log to $log";
	
	&look($dir);
	
	close (LOG);
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
		return unless ($file =~ /^.+\.txt$/);
		print LOG "[$file]\t";
		print LOG &processFile($file) . "\n";
	}
}

sub init {
	%varnames = ();	# empty the array
	
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
	
	&init();
	
	if (!open (SRC,$srcfile)) {
		return "unable to read from $srcfile";
	}
	my @lines = (<SRC>);	# read entire file
	close (SRC);
	if (!open (ERR,">$errfile")) {
		return "unable to open $errfile to write errors";
	}
	
	# Validate that variables are not referenced until after they are defined; and check for  unmatched parentheses in equations
	my $linenum = 0;
	my $reservedcount = 0;
	my ($errCount,$parsedLine) = (0,'');
	foreach (@lines) {
		chomp;
		++$linenum;
		print ERR "[Line $linenum]\t$_\n";
		my $outline;
	
		if (/^\s*$/) {
		}
		elsif (/^\s*(COMMENT|RESERVED)(.*)$/) {
			#if line begins with COMMENT, RESERVED, or blank, ignore it
			++$reservedcount;
		}
		else {
			if ($reservedcount < 5) {
				# this is clearly not a Dialogix file
				close(ERR);
				unlink $errfile unless (-d $errfile);
				return "not a Dialogix instrument file";
			}
			
			my @temp = split(/\t/);
			my @args;
			foreach (@temp) { push @args, &fixExcelisms($_); }
			
			my $concept = shift(@args);
			my $intName = &fixExcelisms(shift(@args));
			my $extName = shift(@args);
			my $relevance = shift(@args);
			
			# now that have processed that line, make the variable defined for future equations (or should this be done after the line is processed?)
			$varnames{$intName} = $intName;				

			my $questionOrEvalType = shift(@args);
			
			$outline = qq|$concept\t$intName\t$extName\t|;
			($parsedLine, $errCount) = &parseExpr($errCount,$relevance);
			$outline .= $parsedLine . "\t";
						
			@temp = split(/;/,$questionOrEvalType);
			$outline .= shift(@temp);
			$_ = shift(@temp);
			$outline .= ';' . $_	if ($_);	# return type;
			my $validation_segment=2;
			while(@temp) {
				if ($validation_segment++ == 4) {
					($parsedLine, $errCount) = &parseString($errCount,shift(@temp));
				}
				else {
					($parsedLine, $errCount) = &parseExpr($errCount,shift(@temp));
				}
				$outline .= ';' . $parsedLine;
			}

			# now parse the rest of the data, allowing for multiple languages 
			while (@args) {
				($parsedLine, $errCount) = &parseString($errCount,shift(@args));
				$outline .= "\t" . 	$parsedLine;	# readback
				
				# questions and expressions have different syntax, so parse accordingly
				my $qOrEval = shift(@args);
				if ($questionOrEvalType =~ /^e/i) {
					($parsedLine, $errCount) = &parseExpr($errCount,$qOrEval);
					$outline .= "\t" . $parsedLine;
				}
				else {
					($parsedLine, $errCount) = &parseString($errCount,$qOrEval);
					$outline .= "\t" . $parsedLine;
				}
				
				@temp = split(/\|/,shift(@args));	# answer options
				$outline .= "\t" . shift(@temp);		# the display type, if any
				while(@temp) {
					($parsedLine, $errCount) = &parseExpr($errCount,shift(@temp));
					$outline .= '|' . $parsedLine;	# the return value
					($parsedLine, $errCount) = &parseString($errCount,shift(@temp));
					$outline .= '|' . $parsedLine;	# the display message
				}
				$outline .= "\t" . shift(@args);					# helpURL
			}
			$outline .= "\n";
			
			if ($outline =~ /\*NOTFOUND\:/) {
				print ERR "[ERROR: on line $linenum - undefined variables are bracketed by 'NOTFOUND']\t$outline";
			}
		}
	}
	
	close(ERR);
	
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


