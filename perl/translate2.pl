#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# This perl script makes it easy to globally change variable names.
# Usage:
#		perl translate2.pl src.txt dst.txt
#	(so reads from src.txt, translates the variables, and writes to dst.txt)
#	requires the following format:
#		1st column = new internalName
#		2nd column = new externalName
#		3rd - nth columns = original schedule
# The program replaces the any instance of the old names with the new ones, even within expressions

use strict;

my %i2e;

&main();

sub init {
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
		"getDependencies",
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
	
	foreach (@funcs) { $i2e{$_} = $_; }
	foreach (@reserveds) { $i2e{$_} = $_; }
}

sub main {
	&init();
	
	open (SRC,$ARGV[0])		or die("unable to open $ARGV[0]");
	my @lines = (<SRC>);	# read entire file
	close (SRC);
	open (OUT,">$ARGV[1]")	or die("unable to open $ARGV[1] for writing");
	
	# Capture all of the variable names throughout the file
	foreach (@lines) {
		if (/^\s*(COMMENT|RESERVED)(.*)$/) {
			#if line begins with COMMENT or RESERVED, print it out unchanged
		}
		elsif (/^(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*?)\t/) {
			my $oldInt = &fixExcelisms($4);
			my $oldExt = &fixExcelisms($5);
			my $newInt = &fixExcelisms($1);
			my $newExt = &fixExcelisms($2);
	
			# replace all equation-based usages of oldInt and oldExt with newInt
			$i2e{$oldInt} = $newInt;
			$i2e{$oldExt} = $newInt;
		}
	}
	
	# Replace the old names with the new names throughout the file.
	foreach (@lines) {
		chomp;
	
		if (/^\s*(COMMENT|RESERVED)(.*)$/) {
			#if line begins with COMMENT or RESERVED, print it out unchanged
			print OUT qq|$1$2\n|;
		}
		else {
			my @temp = split(/\t/);
			my @args;
			foreach (@temp) { push @args, &fixExcelisms($_); }
			
			my $newInt = shift(@args);
			my $newExt = shift(@args);
			my $concept = shift(@args);
			my $oldInt = shift(@args);
			my $oldExt = shift(@args);
			my $dependencies = shift(@args);
			
			my $questionOrEvalType = shift(@args);
			
			print OUT qq|$concept\t$newInt\t$newExt\t|;
			print OUT &translate($dependencies), "\t";
						
			@temp = split(/;/,$questionOrEvalType);
			print OUT shift(@temp);
			$_ = shift(@temp);
			print OUT ';', $_	if ($_);	# return type;
			while(@temp) {
				print OUT ';', &translate(shift(@temp));
			}

			
			while (@args) {
				print OUT "\t", &translate(shift(@args));		# readback
				
				# questions and expressions have different syntax, so parse accordingly
				my $qOrEval = shift(@args);
				if ($questionOrEvalType =~ /^e/i) {
					print OUT "\t", &translate($qOrEval);
				}
				else {
					print OUT "\t", &extractExprs($qOrEval);
				}
				
				@temp = split(/\|/,shift(@args));	# answer options
				print OUT "\t", shift(@temp);		# the display type, if any
				while(@temp) {
					print OUT '|', &translate(shift(@temp));	# the return value
					print OUT '|', &extractExprs(shift(@temp));	# the display message
				}
				
				print OUT "\t", shift(@args);					# helpURL
			}
			print OUT "\n";
		}
	}
	
	close(OUT);
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
sub extractExprs {
	my $in = 0;
	my $arg = shift;
	my @args = split(/(`)/,$arg);
	my $retVal = "";

	for my $a (@args) {
		if ($a eq '`') {
			$in = ($in) ? 0 : 1;
			$retVal .= $a;
		}
		else {
			if ($in) {
				$retVal .= &translate($a);
			}
			else {
				$retVal .= $a;
			}
		}
	}
	return $retVal;
}

# This function extracts all strings (both single and double quote delimited) from an expression,
# and performs the translation (of Internal to External names) on the non-string tokens (variable names)
# Escaped single and double quote characters are treated appropriately, as are strings embedded within other strings.
# This function returns the translated version of the string it is passed.
sub translate {
	my $rest = shift;
	my $retVal = "";

	# extract strings
	while ($rest ne '') {
		if ($rest =~ /^((?:\\'|\\"|.)*?)('|")(.*)$/) {
			$retVal .= &replaceI2E($1);
			my $quot = $2;
			my $inStr = $3;
			if ($quot eq "\'") {
				if ($inStr =~ /^((?:\\'|\\"|.)*?)'(.*)$/) {
					$retVal .= qq|'$1'|;
					$rest = $2;
				}
				else {
					# unterminated string?
					$rest = $quot . $inStr;
				}
			}
			else {
				if ($inStr =~ /^((?:\\'|\\"|.)*?)"(.*)$/) {
					$retVal .= qq|"$1"|;
					$rest = $2;
				}
				else {
					# unterminated string?
					$rest = $quot . $inStr;
				}
			}

		}
		else {
			$retVal .= &replaceI2E($rest);
			$rest = "";
		}
	}
	return $retVal;
}

# This function is passed non-string equations.  It finds all valid variable names (which can only
# contain alphanumeric characters or underscores).  If a mapping from Internal to External name is found, then
# the variable name is substituted with the External name.  If not, the string *NOTFOUND:<$val>* is subtitued for
# the Internal name to indicate that a problem occured.
# This function returns the string it was passed, with all old variable names substituted with new ones.
sub replaceI2E {
	my $rest = shift;
	my $retVal = "";

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
				my $lookup = $i2e{$val};
				$lookup = "*NOTFOUND:<$val>*"	if ($lookup eq '');
				$retVal .= $lookup;
			}
		}
		else {
			$retVal .= $rest;
			$rest = "";
		}
	}

	return $retVal;
}


