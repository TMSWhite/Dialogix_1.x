#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# Perl Script to read info from schedule file for merging with data files
# also creates data dictionary commands for SPSS
# N.B. that SPSS allows for unlimited rows for data input, but has limit of 500 vars for FREQ
#
# TODO
# (1) create import files for timing data
# 

use strict;

use File::Basename;

# levelType assumes wither nominal or scale -- many may be ordinal, but impossible to tell from data file -- should be a field
my $levelTypes = {
	check => 'NOMINAL',
	combo => 'NOMINAL',
	date => 'SCALE',
	day => 'SCALE',
	day_num => 'SCALE',		# since start of year.
	double => 'SCALE',
	hour => 'SCALE',
	list => 'NOMINAL',
	memo => 'NOMINAL',
	minute => 'SCALE',
	month => 'NOMINAL',		# since name of the month
	month_num => 'SCALE',
	nothing => 'NOMINAL',
	password => 'NOMINAL',
	radio => 'NOMINAL',
	radio2 => 'NOMINAL',
	second => 'SCALE',
	text => 'NOMINAL',
	time => 'SCALE',
	weekday => 'NOMINAL',	# since name of weekday
	year => 'SCALE',
};

my @reservedVars = ('STARTDAT', 'STOPDATE', 'UNIQUEID', 'FINISHED', 'TITLE', 'VERSION' );

# formats reference SPSS data types -- the date formats have not been validated yet
my $formats = {
	check => 'F8.0',
	combo => 'F8.0',
	date => 'ADATE10',
	day => 'date|dd',		# what is syntax for this?
	day_num => 'date|dd',		# since start of year.
	double => 'F8.3',
	hour => 'date|hh',
	list => 'F8.0',
	memo => 'A254',
	minute => 'date|mm',
	month => 'MONTH',		# since name of the month
	month_num => 'date|mm',
	nothing => 'F8.2',
	password => 'A50',
	radio => 'F8.0',
	radio2 => 'F8.0',
	second => 'date|ss',
	text => 'A50',
	time => 'TIME5.3',
	weekday => 'WKDAY',	# since name of weekday
	year => 'date|yyyy',	
};

my (@gargs, $modulePrefix, $discardPrefix, $resultsDir);
my (%modules);
@gargs = @ARGV;
$modulePrefix = shift(@gargs);
$discardPrefix = shift(@gargs);
$resultsDir = shift(@gargs);

my ($NA, $REFUSED, $UNKNOWN, $HUH, $INVALID, $UNASKED);
$NA = shift(@gargs);
$REFUSED = shift(@gargs);
$UNKNOWN = shift(@gargs);
$HUH = shift(@gargs);
$INVALID = shift(@gargs);
$UNASKED = shift(@gargs);
my $missingListForNums='()';
my $missingListForStrings='()';
my $missingValLabelsForStrings='';
my $missingValLabelsForNums='';
my %uniqueNames = ();
my %c8name2vars = ();

&main;

sub main {
#	print "modularize = $modulePrefix\n";
	# process all files on the command line
	&compileMissingValueList;
	
	foreach(@gargs) {
		my @files = glob($_);
		foreach my $filename (@files) {
			&transform_schedule($filename);
		}
	}
}

sub compileMissingValueList {
	# need to create missing value statements for strings and numbers.  For strings, must add to list of value labels
	my @missings;
	my $str_missing;
	my $num_missing;

	my $val = '';
	if ($NA ne '*' && $NA ne '.') {
		if ($NA =~ /^[0-9]+$/) { $val = $NA; } else { $val = "\"$NA\""; }
		push @missings, $val;
		$num_missing .= "\t$val \"*NA*\"\n";
		$str_missing .= "\t\"$NA\" \"*NA*\"\n";
	}
	if ($REFUSED ne '*' && $REFUSED ne '.') {
		if ($REFUSED =~ /^[0-9]+$/) { $val = $REFUSED; } else { $val = "\"$REFUSED\""; }
		push @missings, $val;
		$num_missing .= "\t$val \"*REFUSED*\"\n";
		$str_missing .= "\t\"$REFUSED\" \"*REFUSED*\"\n";
	}
	if ($UNKNOWN ne '*' && $UNKNOWN ne '.') {
		if ($UNKNOWN =~ /^[0-9]+$/) { $val = $UNKNOWN; } else { $val = "\"$UNKNOWN\""; }
		push @missings, $val;
		$num_missing .= "\t$val \"*UNKNOWN*\"\n";
		$str_missing .= "\t\"$UNKNOWN\" \"*UNKNOWN*\"\n";
	}	if ($HUH ne '*' && $HUH ne '.') {
		if ($HUH =~ /^[0-9]+$/) { $val = $HUH; } else { $val = "\"$HUH\""; }
		push @missings, $val;
		$num_missing .= "\t$val \"*HUH*\"\n";
		$str_missing .= "\t\"$HUH\" \"*HUH*\"\n";
	}	if ($INVALID ne '*' && $INVALID ne '.') {
		if ($INVALID =~ /^[0-9]+$/) { $val = $INVALID; } else { $val = "\"$INVALID\""; }
		push @missings, $val;
		$num_missing .= "\t$val \"*INVALID*\"\n";
		$str_missing .= "\t\"$INVALID\" \"*INVALID*\"\n";
	}	if ($UNASKED ne '*' && $UNASKED ne '.') {
		if ($UNASKED =~ /^[0-9]+$/) { $val = $UNASKED; } else { $val = "\"$UNASKED\""; }
		push @missings, $val;
		$num_missing .= "\t$val \"*UNASKED*\"\n";
		$str_missing .= "\t\"$UNASKED\" \"*UNASKED*\"\n";
	}	
	$missingListForNums = "(" . join(',',@missings) . ")";
	$missingListForStrings = "(\"" . join("\",\"",@missings) . "\")";
	$missingValLabelsForStrings = $str_missing;	# guarantees that the missing value (presumably a number) is mapped to a string
	$missingValLabelsForNums = $num_missing;	# only uses number => string mapping if all missing values are numbers -- else uses strings => string
	
	if ($num_missing =~ /\t\"/) {
		$missingValLabelsForNums = $str_missing;
	}
}

sub getUniqueName {
	my $name = shift;
	my $ucname = uc($name);
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
#	print "bad name $name -- using _VAR_\n";
	return "_VAR_000";
}

sub transform_schedule {
	my $file = shift;
	
	open (SRC, $file) or die "unable to open $file";
	my @lines = (<SRC>);
	close (SRC);
	
	my @nodes;
	my @c8names;
	my $step = -1;
	my $module;
	my @stepLabels;
	
	%uniqueNames = ();
	%c8name2vars = ();
	
	#initialize reserved variable names
	foreach (@reservedVars) {
		&getUniqueName(uc($_));		# these are already valid names
	}
	
	foreach my $line (@lines) {
		my ($atype, $ansMap, $atext, $alen, $isString, $level, $format);

		chomp($line);
		next if ($line =~ /^\s*((RESERVED)|(COMMENT))/);
		next if ($line =~ /^\s*$/);	# skip blank lines
		my @vals = split(/\t/,$line);
		++$step;
		
		my $ucname = uc($vals[1]);
		my $c8name = &getUniqueName($ucname);
		
		push @c8names, $c8name;
		$c8name2vars{$c8name} = $vals[1];
		
		my $question = &deExcelize($vals[6]);
		my $ansOptions = &deExcelize($vals[7]);
		my $type = lc($vals[4]);		
		($atype, $ansMap, $atext, $alen, $isString, $level, $format) = &cat_ans($ansOptions);
		
		
		if ($discardPrefix ne '*' && $vals[1] =~ /^$discardPrefix/) {
			$module = "__DISCARD__";
		}
		elsif ($atype eq 'nothing' && $type !~ /^e/i) {
			$module = "__NOTHING__";
		}
		elsif ($modulePrefix ne '*' && $vals[1] =~ /^($modulePrefix)/) {
			$module = $1;
		}
		else {
			$module = "__MAIN__";
		}
		$modules{$module} = $module;
		
		push @nodes, {
			step => $step,
			concept => $vals[0],
			name => $vals[1],
			type => $type,
			qtext => &strip_html($question),
			qlen => &qlen($question),
			atext => $atext,
			alen => $alen,
			atype => $atype,
			amap => $ansMap,
			isString => $isString,
			level => $level,
			format => $format,
			module => $module,
			c8name => $c8name,	# will be the "true" variable name
		}
	}
	
	my $sched_root = dirname($file) ."/" .  basename($file,"\.txt");
	open (NODES, ">$sched_root.nodes") or die "unable to open $sched_root.nodes";
	print NODES "Step\tConcept\tName\tType\tQlen\tAlen\tAtype\tc8name\n";
	open (STEPS, ">$sched_root.steps") or die "unable to open $sched_root.steps";
	print STEPS "Display\tFirstStep\tQlen\tAlen\tTlen\tNumSteps\tNames\n";
	
	my $in_block = 0;
	my ($first, $tqlen, $talen) = (0,0,0);
	my @names;
	my $count = 0;
	
	my ($schedSteps, $schedDisplayFmt);
	$schedSteps = ($#nodes + 1);
	if ($schedSteps > 1000) { $schedDisplayFmt = "%04d"; }
	elsif ($schedSteps > 100) { $schedDisplayFmt = "%03d"; }
	elsif ($schedSteps > 10) { $schedDisplayFmt = "%02d"; }
	else { $schedDisplayFmt = "%d"; }

	foreach (@nodes) {
		my %n = %{ $_ };
		
#		print NODES "$sched_root\t$n{'step'}\t$n{'concept'}\t$n{'name'}\t$n{'type'}\t$n{'qlen'}\t$n{'alen'}\t$n{'qtext'}\t$n{'atext'}\n";
		print NODES "$n{'step'}\t$n{'concept'}\t$n{'name'}\t$n{'type'}\t$n{'qlen'}\t$n{'alen'}\t$n{'atype'}\t$n{'c8name'}\n";
		
		#calculate the membership and size of display screens
		
		$first = $n{'step'} unless ($in_block == 1);
		
		if ($n{'type'} eq '[') {
			$in_block = 1;
		}
		if ($n{'type'} eq ']') {
			$in_block = 0;
		}

		push @names, $n{'name'};
		$tqlen += $n{'qlen'};
		$talen += $n{'alen'};
		
		if ($in_block == 0) {
			++$count;
			print STEPS sprintf($schedDisplayFmt,$count) . "\t$first\t$tqlen\t$talen\t" . ($tqlen + $talen) . "\t" . ($#names + 1) . "\t" . join(',',@names) . "\n";
			($first, $tqlen, $talen) = (0,0,0);	#reset counters only if not within a block
			
			push @stepLabels, "[" . sprintf($schedDisplayFmt,$count) . "] " . join(',',@names); 	# labels for steps in SPSS
			
			undef @names;
		}
	}
	
	close (NODES);
	close (STEPS);
	
	#create list of variable names (e.g. for translating among schedules
	open (VARS, ">$sched_root.vars") or die "unable to open $sched_root.vars";
	foreach (sort(@c8names)) {
		print VARS "$_\t$c8name2vars{$_}\n";
	}
	close (VARS);
	
	#create SPSS data dictionary import file 
	&createSPSSdictionaries($sched_root,\@nodes);
	&createSPSSforValidModules;
#	&createSPSSforPathStepTiming(\@stepLabels);
	&createSPSSforPerScreen(\@stepLabels);
	&createSPSSforPathStepSummary(\@stepLabels);
	&createSPSSforPerVar;
}

sub createSPSSforPerVar {
	my $file="$resultsDir/__PerVar__";
	$file =~ s/\//\\/g;	

	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* __PerVar__ */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.log'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";	
 	print SPSS "UniqueID A15\n";
 	print SPSS "dispCnt F8.2\n";
 	print SPSS "numQs F8.2\n";
 	print SPSS "whichQ F8.2\n";
 	print SPSS "c8name A8\n";
 	print SPSS "name A40\n";
 	print SPSS "inpType A8\n";
 	print SPSS "totalTim F8.2\n";
 	print SPSS "inputTim F8.2\n";
 	print SPSS "answered F8.2\n";
 	print SPSS "skipped F8.2\n";
 	print SPSS "focus F8.2\n";
 	print SPSS "blur F8.2\n";
 	print SPSS "change F8.2\n";
 	print SPSS "click F8.2\n";
 	print SPSS "keypress F8.2\n";
 	print SPSS "mouseup F8.2\n";
 	print SPSS "atype A8\n";
 	print SPSS "alen F8.2\n";
 	print SPSS "qlen F8.2\n";
 	print SPSS "tlen F8.2\n";
 	print SPSS "qTimevsT F16.5\n";
 	print SPSS "iTimevsA F16.5\n";
 	print SPSS ".\n";
 	
 	print SPSS "FORMATS DISPCNT NUMQS WHICHQ ANSWERED SKIPPED FOCUS BLUR CHANGE CLICK KEYPRESS MOUSEUP ALEN QLEN TLEN (F8.0).\n";
 	print SPSS "FORMATS TOTALTIM INPUTTIM (F8.3).\n";
 	print SPSS "FORMATS QTIMEVST ITIMEVSA (F16.5).\n";
 	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
 	print SPSS "VARIABLE LABELS DISPCNT \"# Screens seen by subject\".\n";
	print SPSS "VARIABLE LABELS NUMQS \"Number of questions on this screen\".\n";
	print SPSS "VARIABLE LABELS WHICHQ \"Index of this question number on the screen\".\n";
	print SPSS "VARIABLE LABELS C8NAME \"Variable Name\".\n";
	print SPSS "VARIABLE LABELS NAME \"Variable Label\".\n";
	print SPSS "VARIABLE LABELS INPTYPE \"Input Type\".\n";
	print SPSS "VARIABLE LABELS TOTALTIM \"Seconds spent on this question\".\n";
	print SPSS "VARIABLE LABELS INPUTTIM \"Seconds spent entering an answer for this question\".\n";
	print SPSS "VARIABLE LABELS ANSWERED \"# Times this question was answered before moving to next screen\".\n";
	print SPSS "VARIABLE LABELS SKIPPED \"# Times this question was skipped before moving to next screen\".\n";
	print SPSS "VARIABLE LABELS FOCUS \"# Times this question was focused before moving on next screen\".\n";
	print SPSS "VARIABLE LABELS BLUR \"# Times this question lost focus before moving on to next screen\".\n";
	print SPSS "VARIABLE LABELS CHANGE \"# Times the answer for this question was changed before moving to next screen\".\n";
	print SPSS "VARIABLE LABELS CLICK \"# Times the mouse was clicked while answering this question\".\n";
	print SPSS "VARIABLE LABELS KEYPRESS \"# Times the keyboard was pressed while answering this question\".\n";
	print SPSS "VARIABLE LABELS MOUSEUP \"# Times a non-answer (like *REFUSED* or Comment) was selected for this question\".\n";
	print SPSS "VARIABLE LABELS ATYPE \"Answer type\".\n";
 	print SPSS "VARIABLE LABELS QLEN \"Amount of text (chars) in questions\".\n";
 	print SPSS "VARIABLE LABELS ALEN \"Amount of text (chars) in answer optiosn\".\n";
	print SPSS "VARIABLE LABELS TLEN \"Total amount of text (chars) in questions and answers\".\n";
	print SPSS "VARIABLE LABELS QTIMEVST \"Ratio of TotalTime / Tlen\".\n";
	print SPSS "VARIABLE LABELS ITIMEVSA \"Ratio of InputTime / Alen\".\n";

	print SPSS "\nSAVE OUTFILE='$file.sav' /COMPRESSED.\n";
	
	print SPSS "\nCROSSTABS\n";
	print SPSS "\t/TABLES=atype c8name BY change answered skipped\n";
	print SPSS "\t/FORMAT= AVALUE TABLES\n";
	print SPSS "\t/CELLS= COUNT .\n";
	
	close (SPSS);	
 
}


sub createSPSSforPathStepSummary {
	my $arg = shift;
	my @stepLabels = @$arg;
	
	my $file="$resultsDir/pathstep-summary";
	$file =~ s/\//\\/g;	

	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* pathstep-summary */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.log'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";
 	print SPSS "UniqueID A15\n";
  	print SPSS "Title A20\n";
 	print SPSS "Version A8\n";
 	print SPSS "Finished F8.2\n";
 	print SPSS "tDur TIME11.2\n";
 	print SPSS "tDurSec F8.2\n"; 
	print SPSS "NumSteps F8.2\n";
	print SPSS "Path A255\n";
	print SPSS "lastAns F8.2\n";
	print SPSS "lastAnsN A255\n";
	print SPSS "lstView F8.2\n";
	print SPSS "lstViewN A255\n";
 	print SPSS ".\n";
 	
 	print SPSS "FORMATS FINISHED NUMSTEPS LASTANS LSTVIEW (F8.0).\n";
 	print SPSS "FORMATS TDUR (TIME11.2).\n";
 	print SPSS "FORMATS TDURSEC (F8.3).\n";
 	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
	print SPSS "VARIABLE LABELS TITLE \"Instrument Title\".\n";
	print SPSS "VARIABLE LABELS VERSION \"Instrument Version\".\n";	
 	print SPSS "VARIABLE LABELS FINISHED \"Whether instrument was finalized (last next button pressed)\".\n";
 	print SPSS "VARIABLE LABELS TDUR \"Time spent interacting with this screen\".\n";
	print SPSS "VARIABLE LABELS TDURSEC \"Seconds spent interacting with this screen\".\n";
	print SPSS "VARIABLE LABELS NUMSTEPS \"Total number of pages seen by subject\".\n";
	print SPSS "VARIABLE LABELS PATH \"Path taken through instrument by subject\".\n";
	print SPSS "VARIABLE LABELS LASTANS \"Last set of questions answered by subject\".\n";
	print SPSS "VARIABLE LABELS LASTANSN \"Last set of questions answered by subject\".\n";
	print SPSS "VARIABLE LABELS LSTVIEW \"Last set of questions viewed by subject\".\n";
	print SPSS "VARIABLE LABELS LSTVIEWN \"Last set of questions viewed by subject\".\n";
	
	print SPSS "VALUE LABELS LASTANS LSTVIEW\n";
	my $count = 0;
	foreach my $label (@stepLabels) {
		++$count;
		print SPSS "\t$count " . &splitLongLabel($label,60) . "\n";
	}
	print SPSS "\t.\n";	# line terminator

	print SPSS "\nSAVE OUTFILE='$file.sav' /COMPRESSED.\n";
	
	print SPSS "\nCROSSTABS\n";
	print SPSS "\t/TABLES = lastans lstview BY finished\n";
	print SPSS "\t/FORMAT = AVALUE TABLES\n";
	print SPSS "\t/CELLS = COUNT.\n";
	
	close (SPSS);	
}


sub createSPSSforPerScreen {
	my $arg = shift;
	my @stepLabels = @$arg;
	
	my $file="$resultsDir/__PerScreen__";
	$file =~ s/\//\\/g;	

	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* __PerScreen__ */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.log'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";
 	print SPSS "UniqueID A15\n";
 	print SPSS "DispCnt F8.2\n"; 
 	print SPSS "Group F8.2\n";
 	print SPSS "When TIME11.2\n";
 	print SPSS "Qlen F8.2\n";
 	print SPSS "Alen F8.2\n";
 	print SPSS "Tlen F8.2\n";
 	print SPSS "NumQs F8.2\n";
 	print SPSS "tDurSec F8.2\n"; 
 	print SPSS "tTimevsQ F16.5\n"; 
 	print SPSS "tTimevsT F16.5\n";  	
  	print SPSS "Title A20\n";
 	print SPSS "Version A8\n";
 	print SPSS "ServSec F8.2\n";
 	print SPSS "LoadSec F8.2\n";
 	print SPSS "DispSec F8.2\n";
 	print SPSS "TurnSec F8.2\n";
 	print SPSS "NtwkSec F8.2\n";
 	print SPSS "dTimeVsQ F16.5\n";
 	print SPSS "dTimeVsT F16.5\n";
 	print SPSS ".\n";
 	
 	print SPSS "FORMATS DISPCNT GROUP QLEN ALEN TLEN NUMQS (F8.0).\n";
 	print SPSS "FORMATS WHEN (TIME11.2).\n";
 	print SPSS "FORMATS DTIMEVSQ DTIMEVST TTIMEVSQ TTIMEVST (F16.5).\n";
 	print SPSS "FORMATS TDURSEC SERVSEC LOADSEC DISPSEC TURNSEC NTWKSEC (F8.3).\n";
 	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
 	print SPSS "VARIABLE LABELS DISPCNT \"# Screens seen by subject\".\n";
 	print SPSS "VARIABLE LABELS GROUP \"Which group of questions from instrument\".\n";
 	print SPSS "VARIABLE LABELS WHEN \"Time since start of instrument\".\n";
 	print SPSS "VARIABLE LABELS QLEN \"Amount of text (chars) in questions\".\n";
 	print SPSS "VARIABLE LABELS ALEN \"Amount of text (chars) in answer optiosn\".\n";
	print SPSS "VARIABLE LABELS TLEN \"Total amount of text (chars) in questions and answers\".\n";
	print SPSS "VARIABLE LABELS NUMQS \"Number of questions on this screen\".\n";
	print SPSS "VARIABLE LABELS TDURSEC \"Seconds spent interacting with this screen\".\n";
	print SPSS "VARIABLE LABELS TTIMEVSQ \"TotalTime vs Question Length\".\n";
	print SPSS "VARIABLE LABELS TTIMEVST \"TotalTime vs (Question + Answer) Length\".\n";
	print SPSS "VARIABLE LABELS TITLE \"Instrument Title\".\n";
	print SPSS "VARIABLE LABELS VERSION \"Instrument Version\".\n";	
	print SPSS "VARIABLE LABELS SERVSEC \"ServerTime -- time required for server to process answers and prepare next page (sec)\".\n";
	print SPSS "VARIABLE LABELS LOADSEC \"LoadTime -- time required for browser to load page (sec)\".\n";
	print SPSS "VARIABLE LABELS DISPSEC \"DisplayTime -- time the subject spent interacting with the screen (sec)\".\n";
	print SPSS "VARIABLE LABELS TURNSEC \"TurnaroundTime -- time elapsed between sending a page and receiving response (sec)\".\n";
	print SPSS "VARIABLE LABELS NTWKSEC \"Network Delay: (TurnaroundTime - DisplayTime - LoadTime)\".\n";
	print SPSS "VARIABLE LABELS DTIMEVSQ \"DisplayTime vs. Question Length\".\n";
	print SPSS "VARIABLE LABELS DTIMEVST \"DisplayTime vs. (Question + Answer) Length\".\n";
	
	print SPSS "VALUE LABELS GROUP\n";
	my $count = 0;
	foreach my $label (@stepLabels) {
		++$count;
		print SPSS "\t$count " . &splitLongLabel($label,60) . "\n";
	}
	print SPSS "\t.\n";	# line terminator

	print SPSS "\nSAVE OUTFILE='$file.sav' /COMPRESSED.\n";
	
	print SPSS "\nMEANS\n";
	print SPSS "\t/TABLES=dispsec dtimevsq dtimevst loadsec ntwksec servsec ttimevsq BY group\n";
	print SPSS "\t/CELLS COUNT MEDIAN MEAN STDDEV MIN MAX KURT SEKURT SKEW SESKEW .\n";
	
	print SPSS "\nPARTIAL CORR\n";
	print SPSS "\t/VARIABLES=qlen dispsec BY group\n";
	print SPSS "\t/STATISTICS=DESCRIPTIVES\n";
	print SPSS "\t/MISSING=LISTWISE .\n";
	
	close (SPSS);	
}

sub createSPSSforPathStepTiming {
	my $arg = shift;
	my @stepLabels = @$arg;

	my $file="$resultsDir/pathstep-timing";
	$file =~ s/\//\\/g;	

	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* pathstep-timing */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.log'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";
 	print SPSS "UniqueID A15\n";
 	print SPSS "DispCnt F8.2\n";
 	print SPSS "Group F8.2\n";
 	print SPSS "When TIME11.2\n";
 	print SPSS "TDur TIME11.2\n";
 	print SPSS "Qlen F8.2\n";
 	print SPSS "Alen F8.2\n";
 	print SPSS "Tlen F8.2\n";
 	print SPSS "NumQs F8.2\n";
 	print SPSS "tDurSec F8.2\n";
 	print SPSS "tTimevsQ F16.5\n";
 	print SPSS "tTimevsT F16.5\n";
 	print SPSS "Title A20\n";
 	print SPSS "Version A8\n";
 	print SPSS ".\n";
 	
 	print SPSS "FORMATS DISPCNT GROUP QLEN ALEN TLEN NUMQS (F8.0).\n";
 	print SPSS "FORMATS WHEN TDUR (TIME11.2).\n";
 	print SPSS "FORMATS TTIMEVSQ TTIMEVSQ (F16.5).\n";
 	print SPSS "FORMATS TDURSEC (F8.3).\n";
 	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
 	print SPSS "VARIABLE LABELS DISPCNT \"# Screens seen by subject\".\n";
 	print SPSS "VARIABLE LABELS GROUP \"Which group of questions from instrument\".\n";
 	print SPSS "VARIABLE LABELS WHEN \"Time since start of instrument\".\n";
 	print SPSS "VARIABLE LABELS TDUR \"Time spent interacting with this screen\".\n";
 	print SPSS "VARIABLE LABELS QLEN \"Amount of text (chars) in questions\".\n";
 	print SPSS "VARIABLE LABELS ALEN \"Amount of text (chars) in answer optiosn\".\n";
	print SPSS "VARIABLE LABELS TLEN \"Total amount of text (chars) in questions and answers\".\n";
	print SPSS "VARIABLE LABELS NUMQS \"Number of questions on this screen\".\n";
	print SPSS "VARIABLE LABELS TDURSEC \"Seconds spent interacting with this screen\".\n";
	print SPSS "VARIABLE LABELS TTIMEVSQ \"Ratio of DurSEC / Qlen\".\n";
	print SPSS "VARIABLE LABELS TTIMEVST \"Ratio of DurSEC / Tlen\".\n";
	print SPSS "VARIABLE LABELS TITLE \"Instrument Title\".\n";
	print SPSS "VARIABLE LABELS VERSION \"Instrument Version\".\n";
	
	print SPSS "VALUE LABELS GROUP\n";
	my $count = 0;
	foreach my $label (@stepLabels) {
		++$count;
		print SPSS "\t$count " . &splitLongLabel($label,60) . "\n";
	}
	print SPSS "\t.\n";	# line terminator	
	

	print SPSS "\nSAVE OUTFILE='$file.sav' /COMPRESSED.\n";
	
	close (SPSS);
}


sub createSPSSdictionaries {
	my ($sched_root, $nodes) = @_;
	my $allSpss;
	
	foreach (sort(keys(%modules))) {
		print "creating dictionary for module $_\n";
		
		my $file="$resultsDir/$_";
		$file =~ s/\//\\/g;
			
		&createSPSSdictionary($_,$file,$sched_root,$nodes);
		
		$allSpss .= "INCLUDE FILE='$file.sps'.\n";
	}
}

sub createSPSSforValidModules {
	my $all_spss_file = "$resultsDir/all_spss.sps";
	
	open (SPSS, ">$all_spss_file") or die "unable to open $all_spss_file";
	foreach (sort(keys(%modules))) {
		next if (/^(__NOTHING__)|(__DISCARD__)$/);
		my $file="$resultsDir/$_-summary.sps";
		open (IN, "<$file") or die "unable to open $file";
		my @lines = (<IN>);
		foreach (@lines) { 
			chomp;
			print SPSS "$_\n";
		}
		close (IN);
		
		$file="$resultsDir/$_-complete.sps";
		open (IN, "<$file") or die "unable to open $file";
		my @lines = (<IN>);
		foreach (@lines) { 
			chomp;
			print SPSS "$_\n";
		}
		close (IN);		
	}
	close (SPSS);
}


sub createSPSSdictionary {
	my $module = shift;
	my $file = shift;
	my $sched_root = shift;
	my $nodelist = shift;
	my @nodes = @{ $nodelist };
	my @freqVars;
	
	open (SPSS, ">$file-summary.sps") or die "uanble to open $file-summary.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* Module $_-summary */\n";
	print SPSS "/**********************************************/\n\n";

	print SPSS "GET DATA /TYPE = TXT\n";
	print SPSS "/FILE = '$file-summary.log'\n";
	print SPSS "/DELCASE = LINE\n";
	print SPSS "/DELIMITERS = \"\\t\"\n";
	print SPSS "/ARRANGEMENT = DELIMITED\n";
	print SPSS "/FIRSTCASE = 4\n";
	print SPSS "/IMPORTCASE = ALL\n";
	print SPSS "/VARIABLES =\n";
	print SPSS "\tUniqueID A15\n";
	print SPSS "\tFinished F8.0\n";
	print SPSS "\tStartDat ADATE10\n";
	print SPSS "\tStopDate ADATE10\n";
	print SPSS "\tTitle A25\n";
	print SPSS "\tVersion A8\n";
	
	
	foreach (sort { $a->{'name'} cmp $b->{'name'} } @nodes) {
		my %n = %{ $_ };
		next if ($n{'module'} ne $module);
		
		print SPSS "\t$n{'c8name'} $n{'format'}\n";
		push @freqVars, $n{'c8name'};
	}
	print SPSS ".\n\n";
	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
 	print SPSS "VARIABLE LABELS FINISHED \"Whether instrument was finalized (last next button pressed)\".\n";
	print SPSS "VARIABLE LABELS TITLE \"Instrument Title\".\n";
	print SPSS "VARIABLE LABELS VERSION \"Instrument Version\".\n";	

	
	foreach (sort { $a->{'name'} cmp $b->{'name'} } @nodes) {
		my %n = %{ $_ };
		
		next if ($n{'module'} ne $module);
		
		# want correct data types.  If pick list, unclear whether nominal or ordinal (but not likely to be scale).  Double and date are scale
		
		print SPSS "VARIABLE LABELS $n{'c8name'}\n\t" . &splitLongLabel("[$n{'name'}] $n{'qtext'}",255) . ".\n";
		
		if ($n{'alen'} > 0) {
			# then has a data dictionary
			print SPSS "VALUE LABELS $n{'c8name'}\n";
			print SPSS $missingValLabelsForStrings	if $n{'isString'};
			print SPSS $missingValLabelsForNums		unless $n{'isString'};

			my %amap = %{ $n{'amap'} };
			foreach my $key (sort(keys(%amap))) {
				# determine data type first (so don't mix text and numbers?
				print SPSS "\t$key " . &splitLongLabel("[$key] $amap{$key}",60) . "\n";
			}
			print SPSS "\t.\n";	# line terminator

		}
	
		print SPSS "VARIABLE LEVEL $n{'c8name'} ($n{'level'}).\n";
		print SPSS "FORMATS $n{'c8name'} ($n{'format'}).\n";
		print SPSS "MISSING VALUES $n{'c8name'} $missingListForNums.\n"		unless ($n{'isString'});
		print SPSS "MISSING VALUES $n{'c8name'} $missingListForStrings.\n"	if ($n{'isString'});
		print SPSS "\n";

	}

	print SPSS "FORMATS STARTDAT STOPDATE (ADATE10).\n";
	
	
	#save data and spo files
	print SPSS "\nSAVE OUTFILE='$file-summary.sav' /COMPRESSED.\n";
	
	#calc SPSS frequencies
	
	my $freq_count = 0;
	
	do {
		++$freq_count;
		print SPSS "\nPROCEDURE OUTPUT OUTFILE='${file}_$freq_count'.\n";
		print SPSS "FREQUENCIES VARIABLES=\n";
		
		for (my $i=0;$i<450;++$i) {
			print SPSS "\t" . shift(@freqVars) . "\n";
			last unless (@freqVars);
		}
		print SPSS "\t/BARCHART PERCENT\n";
		print SPSS "\t/ORDER= VARIABLE .\n";
	} while (@freqVars);	
	
	close (SPSS);
	
	########################################
	# Now create dictionaries for *-complete
	########################################
	
	open (SPSS, ">$file-complete.sps") or die "uanble to open $file-complete.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* Module $_-complete */\n";
	print SPSS "/**********************************************/\n\n";

	print SPSS "GET DATA /TYPE = TXT\n";
	print SPSS "/FILE = '$file-complete.log'\n";
	print SPSS "/DELCASE = LINE\n";
	print SPSS "/DELIMITERS = \"\\t\"\n";
	print SPSS "/ARRANGEMENT = DELIMITED\n";
	print SPSS "/FIRSTCASE = 4\n";
	print SPSS "/IMPORTCASE = ALL\n";
	print SPSS "/VARIABLES =\n";
	print SPSS "\tUniqueID A15\n";
	print SPSS "\tFinished F8.0\n"; ##
	print SPSS "\tc8name A8\n";
	print SPSS "\tLanguage F8.2\n";
	print SPSS "\tVersion A8\n";
	print SPSS "\tAnswers A100\n";
	print SPSS "\tDispCnts A20\n";
	print SPSS "\tDirectns A20\n";
	print SPSS "\tVisits F8.2\n";
	print SPSS "\tPrevs F8.2\n";
	print SPSS "\tRepeats F8.2\n";
	print SPSS "\tNexts F8.2\n";
	print SPSS "\tChanges F8.2\n";
	print SPSS "\tRetains F8.2\n";
	print SPSS "\tNa2Ok F8.2\n";
	print SPSS "\tOk2Na F8.2\n";
	print SPSS "\tOk2Ok F8.2\n";
	print SPSS "\tNonAns F8.2\n";
	print SPSS "\t.\n";

 	print SPSS "FORMATS FINISHED VISITS PREVS REPEATS NEXTS CHANGES RETAINS NA2OK OK2NA OK2OK NONANS (F8.0).\n";
 	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
 	print SPSS "VARIABLE LABELS FINISHED \"Whether instrument was finalized (last next button pressed)\".\n";
	print SPSS "VARIABLE LABELS C8NAME \"Variable Name\".\n";
	print SPSS "VARIABLE LABELS LANGUAGE \"The language in which this question was asked\".\n";
	print SPSS "VARIABLE LABELS VERSION \"Instrument Version\".\n";
	print SPSS "VARIABLE LABELS ANSWERS \"List of answers given to this question\".\n";
 	print SPSS "VARIABLE LABELS DISPCNTs \"List of Screen #s immediately preceding changes to this value\".\n";
 	print SPSS "VARIABLE LABELS DIRECTNS \"List of Directions taken by subject after answering: -1=prev, 0=repeat, 1=next\".\n";
 	print SPSS "VARIABLE LABELS VISITS \"# Times this question was visited\".\n";
 	print SPSS "VARIABLE LABELS PREVS \"# Times that 'previous' was pressed after answering this question\".\n";
 	print SPSS "VARIABLE LABELS REPEATS \"# Times that 'next' was pressed after answering this question, but could not proceed\".\n";
 	print SPSS "VARIABLE LABELS NEXTS \"# Times that 'next' was pressed successfully after answering this question\".\n";
 	print SPSS "VARIABLE LABELS CHANGES \"# Times the answer for this question was changed\".\n";
 	print SPSS "VARIABLE LABELS RETAINS \"# Times this question was revisited, but answer was unchanged\".\n";
 	print SPSS "VARIABLE LABELS NA2OK \"# Times the answer changed from *NA* to a valid value\".\n";
 	print SPSS "VARIABLE LABELS OK2NA \"# Times the answer changed from a valid value to *NA*\".\n";
 	print SPSS "VARIABLE LABELS OK2OK \"# Times the answer changed from one valid value to another valid value\".\n";
	print SPSS "VARIABLE LABELS NONANS \"# Times the question was unanswered, and subject was reminded to answer it\".\n";
	
	# value labels for STEP
	
	print SPSS "VALUE LABELS C8NAME\n";
	foreach (sort { $a->{'name'} cmp $b->{'name'} } @nodes) {
		my %n = %{ $_ };
		next if ($n{'module'} ne $module);
		
		print SPSS "\t\"$n{'c8name'}\"\n\t" . &splitLongLabel("[$n{'name'}] $n{'qtext'}",255) . "\n";
	}
	print SPSS "\t.\n";
	
	#save data and spo files
	print SPSS "\nSAVE OUTFILE='$file-complete.sav' /COMPRESSED.\n";
	
	#analyses
	print SPSS "\nCROSSTABS\n";
	print SPSS "\t/TABLES=c8name  BY nonans ok2ok ok2na na2ok nexts prevs repeats\n";
	print SPSS "\t/FORMAT= AVALUE TABLES\n";
	print SPSS "\t/CELLS= COUNT .\n";
	
	close (SPSS);
	
}

sub deExcelize {
	my $arg = shift;
	
	if ($arg =~ /^\s*["'](.+)["']\s*$/) {
		# then like Excel with its double quotes
		$arg = $1;
	}
	$arg =~ s/["']+/'/g;	# replace any double quotes with single qoutes, and remove duplicates
	return $arg;
}	
	

sub splitLongLabel {
	# N.B. that SPSS limits value label lengths to 60 characters, and variable label lengths to 255 chars
	my $arg = &deExcelize(shift);
	my $maxlen = shift;
	
	$arg = substr($arg,0,$maxlen);
	
	my $text;
	
	while (length($arg) > 0) {
		if (length($text) > 0) {
			# add continuation characters
			$text .= "\n\t+";
		}
		if (length($arg) > 55) {
			$text .= "\"" . substr($arg,0,55) . "\"";
			$arg = substr($arg,55,length($arg));
		}
		else {
			$text .= "\"" . $arg . "\"";
			$arg = '';
		}
	}
	return $text;
}

sub qlen {
	my $arg = shift;
	my $text = &strip_html($arg);
	return length($text);
	
}

sub cat_ans {
	my $arg = shift;
	my (@vals, $atype, $count, $text, %ansMap, $isString, $level, $format);
	
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
			if ($key !~ /^[0-9]+$/) {
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
				if ($key =~ /^[0-9]$/) {	# if a number, add surrounding quotes
					$key = qq|'$key'|;
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
	$format = $formats->{$atype};
	
	if ($format =~ /^F/) {
		if ($isString) {
			$format = 'A8';	# must be short enough that can do frequency analyses
		}
	}
	return ($atype, \%ansMap, $text, length($text), $isString, $level, $format);
}

sub strip_html {
	my $arg = shift;
	my $text = join(' ',split(/<.+?>|`.+?`|&.+?;/,$arg));
	$text = join(' ',split(/\s+/,$text));
	return $text;
}
	
	
# dataTypes reference SPSS data types -- the date formats have not been validated yet
sub oldDataType {
my $dataTypes = {
	check => 'numeric|8',
	combo => 'numeric|8',
	date => 'date|mm/dd/yyyy',
	day => 'date|dd',		# what is syntax for this?
	day_num => 'date|dd',		# since start of year.
	double => 'numeric|8.3',
	hour => 'date|hh',
	list => 'numeric|8',
	memo => 'string|255',
	minute => 'date|mm',
	month => 'date|mm',		# since name of the month
	month_num => 'date|mm',
	nothing => 'string|1',
	password => 'string|50',
	radio => 'numeric|8',
	radio2 => 'numeric|8',
	second => 'date|ss',
	text => 'string|255',
	time => 'date|hh:mm:ss',
	weekday => 'date|ww',	# since name of weekday
	year => 'date|yyyy',	
};
}	

