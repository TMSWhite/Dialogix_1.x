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

use Digest::MD5 qw(md5_hex);

use strict;

use File::Basename;
use Dialogix::Utils;

# levelType assumes wither nominal or scale -- many may be ordinal, but impossible to tell from data file -- should be a field
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

my @reservedVars = ('STARTDAT', 'STOPDATE', 'UNIQUEID', 'FINISHED', 'TITLE', 'VERSION' );

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

my (@gargs,$Prefs,$conf_file);
@gargs = @ARGV;
$conf_file = shift(@gargs);

my $missingListForNums='()';
my $missingListForStrings='()';
my $missingValLabelsForStrings='';
my $missingValLabelsForNums='';
my %uniqueNames = ();
my %c8name2vars = ();
my %modules = ();


&main;

sub main {
	# process all files on the command line
	
	$Prefs = &Dialogix::Utils::readDialogixPrefs($conf_file);
	&Dialogix::Utils::mychdir($Prefs->{INSTRUMENT_DIR});
	
	&compileMissingValueList;
	
	foreach(@gargs) {
		my @files = glob($_);
		foreach my $filename (@files) {
			%uniqueNames = ();
			%c8name2vars = ();
			%modules = ();			
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
	if ($Prefs->{NA} ne '*' && $Prefs->{NA} ne '.') {
		if ($Prefs->{NA} =~ /^[0-9]+$/) { $val = $Prefs->{NA}; } else { $val = "\"$Prefs->{NA}\""; }
		push @missings, $val;
		$num_missing .= "\t$val SAS_SPSS \"*NA*\"\n";
		$str_missing .= "\t\"$Prefs->{NA}\" SAS_SPSS \"*NA*\"\n";
	}
	if ($Prefs->{REFUSED} ne '*' && $Prefs->{REFUSED} ne '.') {
		if ($Prefs->{REFUSED} =~ /^[0-9]+$/) { $val = $Prefs->{REFUSED}; } else { $val = "\"$Prefs->{REFUSED}\""; }
		push @missings, $val;
		$num_missing .= "\t$val SAS_SPSS \"*REFUSED*\"\n";
		$str_missing .= "\t\"$Prefs->{REFUSED}\" SAS_SPSS \"*REFUSED*\"\n";
	}
	if ($Prefs->{UNKNOWN} ne '*' && $Prefs->{UNKNOWN} ne '.') {
		if ($Prefs->{UNKNOWN} =~ /^[0-9]+$/) { $val = $Prefs->{UNKNOWN}; } else { $val = "\"$Prefs->{UNKNOWN}\""; }
		push @missings, $val;
		$num_missing .= "\t$val SAS_SPSS \"*UNKNOWN*\"\n";
		$str_missing .= "\t\"$Prefs->{UNKNOWN}\" SAS_SPSS \"*UNKNOWN*\"\n";
	}	if ($Prefs->{HUH} ne '*' && $Prefs->{HUH} ne '.') {
		if ($Prefs->{HUH} =~ /^[0-9]+$/) { $val = $Prefs->{HUH}; } else { $val = "\"$Prefs->{HUH}\""; }
		push @missings, $val;
		$num_missing .= "\t$val SAS_SPSS \"*HUH*\"\n";
		$str_missing .= "\t\"$Prefs->{HUH}\" SAS_SPSS \"*HUH*\"\n";
	}	if ($Prefs->{INVALID}  ne '*' && $Prefs->{INVALID}  ne '.') {
		if ($Prefs->{INVALID}  =~ /^[0-9]+$/) { $val = $Prefs->{INVALID} ; } else { $val = "\"$Prefs->{INVALID} \""; }
		push @missings, $val;
		$num_missing .= "\t$val SAS_SPSS \"*INVALID*\"\n";
		$str_missing .= "\t\"$Prefs->{INVALID} \" SAS_SPSS \"*INVALID*\"\n";
	}	if ($Prefs->{UNASKED} ne '*' && $Prefs->{UNASKED} ne '.') {
		if ($Prefs->{UNASKED} =~ /^[0-9]+$/) { $val = $Prefs->{UNASKED}; } else { $val = "\"$Prefs->{UNASKED}\""; }
		push @missings, $val;
		$num_missing .= "\t$val SAS_SPSS \"*UNASKED*\"\n";
		$str_missing .= "\t\"$Prefs->{UNASKED}\" SAS_SPSS \"*UNASKED*\"\n";
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

sub transform_schedule {
	my $file = shift;
	my $newname;
	my $basename;
	
	if ($file =~ /^(.*)\.txt$/i) {
		$basename = $1;
	}
	elsif ($file =~ /^(.*)\.jar$/i) {
		# first unjar the instrument and create new .txt filename for the instrument
		$basename = $1;
		
		&doit("$Prefs->{JAR}  xvf $file");
		
		#will create header and body components
		open (NEWINST, ">$basename.txt") or die "unable to write to $basename.txt";
		open (HEADER, "<headers") or die "unable to open headers portion of instrument";
		open (BODY, "<body") or die "unable to open body portion of instrument";
		foreach (<HEADER>) {
			print NEWINST $_;
		}
		foreach (<BODY>) {
			print NEWINST $_;
		}
		close (HEADER);
		close (BODY);
		close (NEWINST);
	}
	else {
		return;
	}
	$newname = &determine_full_instrument_name("$basename.txt");
	# change name of file
	open (NEWINST, ">$newname.src") or die "unable to write to $newname.src";
	open (OLDINST, "<$basename.txt") or die "unable to read from $basename.txt";
	foreach (<OLDINST>) {
		print NEWINST $_;
	}
	close (OLDINST);
	close (NEWINST);
	
	&transform_schedule_sub("$newname.src");
	&showLogic("$newname.src","$newname.htm","$newname");
}

sub determine_full_instrument_name {
	my $file = shift;
	my ($filename,$inst,$timestamp,$when,$title,$version,$languages,$numvars,$varmd5) = &Dialogix::Utils::whichInstrument($file);
	return $inst;
}

sub transform_schedule_sub {
	my $file = shift;
	my $basename = basename($file,"\.src");
	
	open (SRC, $file) or die "unable to open $file";
	my @lines = (<SRC>);
	close (SRC);
	print "Processing Instrument '$file'\n";
	
	my @nodes;
	my @c8names;
	my $step = -1;
	my $module;
	my @stepLabels;
	
	# %uniqueNames = ();
	# %c8name2vars = ();
	
	my $varnameColumn = 1;
	if ($Prefs->{VARNAME_FROM_COLUMN} =~ /^[012]$/) {
		$varnameColumn = $Prefs->{VARNAME_FROM_COLUMN};
	}
	
	#initialize reserved variable names
	foreach (@reservedVars) {
		&getUniqueName(uc($_));		# these are already valid names
	}
	
	foreach my $line (@lines) {
		my ($atype, $ansMap, $atext, $alen, $isString, $isNum, $level, $SPSSformat, $SASinformat, $SASformat);

		chomp($line);
		next if ($line =~ /^\s*((RESERVED)|(COMMENT))/);
		next if ($line =~ /^\s*$/);	# skip blank lines
		my @vals = split(/\t/,$line);
		++$step;
		
		my $ucname = uc($vals[$varnameColumn]);
		my $c8name = &getUniqueName($ucname);
		
		push @c8names, $c8name;
		$c8name2vars{$c8name} = $vals[1];
		
		my $question = &deExcelize($vals[6]);
		my $ansOptions = &deExcelize($vals[7]);
		my $type = lc($vals[4]);		
		($atype, $ansMap, $atext, $alen, $isString, $isNum, $level, $SPSSformat, $SASinformat, $SASformat) = &cat_ans($ansOptions);
		
		
		if ($Prefs->{discardVarsMatchingPattern} ne '*' && $vals[1] =~ /^$Prefs->{discardVarsMatchingPattern}$/) {
			$module = "${basename}_DISCARD";
		}
		elsif ($atype eq 'nothing' && $type !~ /^e/i) {
			$module = "${basename}_NOTHING";
		}
		elsif ($Prefs->{modularizeByPrefix} ne '*' && $vals[1] =~ /^($Prefs->{modularizeByPrefix})/) {
			$module = "${basename}_$1";
		}
		else {
			$module = "${basename}_MAIN";
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
			isNum => $isNum,
			level => $level,
			SPSSformat => $SPSSformat,
			SASinformat => $SASinformat,
			SASformat => $SASformat,
			module => $module,
			c8name => $c8name,	# will be the "true" variable name
			qa_md5 => 	md5_hex("$question|$ansOptions"),
			displayName => $vals[2],
			relevance => $vals[3],
			actionType => $vals[4],
			readback => $vals[5],
			actionPhrase => $question,
			answerOptions => $ansOptions
		}
	}
	
	my $sched_root = dirname($file) ."/" .  basename($file,"\.src");
	open (NODES, ">$sched_root.nodes") or die "unable to open $sched_root.nodes";
	print NODES "Step\tConcept\tName\tType\tQlen\tAlen\tAtype\tc8name\tqa_md5\tDisplay\n";
	open (STEPS, ">$sched_root.steps") or die "unable to open $sched_root.steps";
	print STEPS "Display\tFirstStep\tQlen\tAlen\tTlen\tNumSteps\tNames\n";
	open (MYSQL, ">$sched_root.mysql_inst") or die "unable to open $sched_root.mysql_inst";
	print MYSQL "StepNum\tVarName\tc8name\tDisplayName\tDisplayGroup" .
			"\tConcept\tRelevance\tActionType\tValidation\tAnswerType\tisMessage" .
			"\tActionPhrase\tAnswerOptions\tReadback\tQlen\tAlen\tqa_md5\tDefault\n";
			
	
	my $in_block = 0;
	my ($first, $tqlen, $talen) = (0,0,0);
	my @names;
	my $count = 0;
	
	my ($schedSteps, $schedDisplayFmt);
	$schedSteps = ($#nodes + 1);
	if ($schedSteps > 10000) { $schedDisplayFmt = "%05d"; }
	elsif ($schedSteps > 1000) { $schedDisplayFmt = "%04d"; }
	elsif ($schedSteps > 100) { $schedDisplayFmt = "%03d"; }
	elsif ($schedSteps > 10) { $schedDisplayFmt = "%02d"; }
	else { $schedDisplayFmt = "%d"; }

	foreach (@nodes) {
		my %n = %{ $_ };
		
#		print NODES "$sched_root\t$n{'step'}\t$n{'concept'}\t$n{'name'}\t$n{'type'}\t$n{'qlen'}\t$n{'alen'}\t$n{'qtext'}\t$n{'atext'}\n";
		print NODES "$n{'step'}\t$n{'concept'}\t$n{'name'}\t$n{'type'}\t$n{'qlen'}\t$n{'alen'}\t$n{'atype'}\t$n{'c8name'}\t$n{'qa_md5'}\t" .
			sprintf($schedDisplayFmt,$count) . "\n";
			
#		print MYSQL "StepNum\tConcept\tVarName\tQType\tQLen\tALen\tAType\tc8name\tqa_md5\tDisplayNum" .
#			"\tDisplayName\tRelevance\tActionType\tReadback\tActionPhrase\tAnswerOptions\n";
#		
#		print MYSQL "$n{'step'}\t$n{'concept'}\t$n{'name'}\t$n{'type'}\t$n{'qlen'}\t$n{'alen'}\t$n{'atype'}\t$n{'c8name'}\t$n{'qa_md5'}\t" .
#			sprintf($schedDisplayFmt,$count) . 
#			"\t$n{'displayName'}\t$n{'relevance'}\t$n{'actionType'}\t$n{'readback'}\t$n{'actionPhrase'}\t$n{'answerOptions'}\n";
			
		my @actionTypeParts = split(/;/,$n{'actionType'});
		my $actionTypeOnly = $actionTypeParts[0];
		shift(@actionTypeParts);
		my $validation = join(';',@actionTypeParts);
		my $isMessage = 0;
		if ($n{'atype'} eq 'nothing' and $actionTypeOnly !~ /e/i) {
			$isMessage = 1;
		}

		print MYSQL "$n{'step'}\t$n{'name'}\t$n{'c8name'}\t$n{'displayName'}\t" .
			sprintf($schedDisplayFmt,$count) . 
			"\t$n{'concept'}\t$n{'relevance'}\t$actionTypeOnly\t$validation\t$n{'atype'}\t$isMessage\t" .
			"$n{'actionPhrase'}\t$n{'answerOptions'}\t$n{'readback'}\t$n{'qlen'}\t$n{'alen'}\t$n{'qa_md5'}\t\n";
			
		
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
	close (MYSQL);
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
#	&createSPSSforValidModules;
#	&createSPSSforPathStepTiming(\@stepLabels);
	&createSPSSforPerScreen($sched_root,\@stepLabels);
	&createSPSSforPathStepSummary($sched_root,\@stepLabels);
	&createSPSSforPerVar($sched_root);
}

sub createSPSSforPerVar {
	my $sched_root = shift;
	my $file="$Prefs->{RESULTS_DIR}/${sched_root}_PerVar";
	if ($Prefs->{UNIX_DOS} eq 'dos') {
		$file =~ s/\//\\/g;	
	}

	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* __PerVar__ */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.tsv'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";	
 	print SPSS "UniqueID A50\n";
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
	my $sched_root = shift;
	my $file="$Prefs->{RESULTS_DIR}/${sched_root}_PathStep-summary";	
	my $arg = shift;
	my @stepLabels = @$arg;
	
	if ($Prefs->{UNIX_DOS} eq 'dos') {
		$file =~ s/\//\\/g;	
	}
	
	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* pathstep-summary */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.tsv'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";
 	print SPSS "UniqueID A50\n";
  	print SPSS "Title A50\n";
 	print SPSS "Version A8\n";
 	print SPSS "Finished F8.2\n";
 	print SPSS "tDur TIME11.2\n";
 	print SPSS "tDurSec F8.2\n"; 
	print SPSS "NumSteps F8.2\n";
	print SPSS "Path A255\n";
	print SPSS "lastAns F8.2\n";
#	print SPSS "lastAnsN A255\n";
	print SPSS "lstView F8.2\n";
#	print SPSS "lstViewN A255\n";
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
#	print SPSS "VARIABLE LABELS LASTANSN \"Last set of questions answered by subject\".\n";
	print SPSS "VARIABLE LABELS LSTVIEW \"Last set of questions viewed by subject\".\n";
#	print SPSS "VARIABLE LABELS LSTVIEWN \"Last set of questions viewed by subject\".\n";
	
	if ($Prefs->{MAKE_SPSS_VALUE_LABELS} eq '1') {
		print SPSS "VALUE LABELS LASTANS LSTVIEW\n";
		my $count = 0;
		foreach my $label (@stepLabels) {
			++$count;
			print SPSS "\t$count " . &splitLongLabel($label,60) . "\n";
		}
		print SPSS "\t.\n";	# line terminator
	}

	print SPSS "\nSAVE OUTFILE='$file.sav' /COMPRESSED.\n";
	
	print SPSS "\nCROSSTABS\n";
	print SPSS "\t/TABLES = lastans lstview BY finished\n";
	print SPSS "\t/FORMAT = AVALUE TABLES\n";
	print SPSS "\t/CELLS = COUNT.\n";
	
	close (SPSS);	
}


sub createSPSSforPerScreen {
	my $sched_root = shift;
	my $file="$Prefs->{RESULTS_DIR}/${sched_root}_PerScreen";
	my $arg = shift;
	my @stepLabels = @$arg;
	
	if ($Prefs->{UNIX_DOS} eq 'dos') {
		$file =~ s/\//\\/g;	
	}
	
	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* __PerScreen__ */\n";
	print SPSS "/**********************************************/\n\n";

	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.tsv'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";
 	print SPSS "UniqueID A50\n";
 	print SPSS "DispCnt F8.2\n"; 
 	print SPSS "Group F8.2\n";
 	print SPSS "When TIME11.2\n";
 	print SPSS "Qlen F8.2\n";
 	print SPSS "Alen F8.2\n";
 	print SPSS "Tlen F8.2\n";
 	print SPSS "NumQs F8.2\n";
  	print SPSS "Title A50\n";
 	print SPSS "Version A8\n";
  	print SPSS "tDurSec F8.2\n"; 
 	print SPSS "tTimevsQ F16.5\n"; 
 	print SPSS "tTimevsT F16.5\n";  	
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
	
	if ($Prefs->{MAKE_SPSS_VALUE_LABELS} eq '1') {
		print SPSS "VALUE LABELS GROUP\n";
		my $count = 0;
		foreach my $label (@stepLabels) {
			++$count;
			print SPSS "\t$count " . &splitLongLabel($label,60) . "\n";
		}
		print SPSS "\t.\n";	# line terminator
	}

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

	my $file="$Prefs->{RESULTS_DIR}/pathstep-timing";
	if ($Prefs->{UNIX_DOS} eq 'dos') {
		$file =~ s/\//\\/g;	
	}
	open (SPSS, ">$file.sps") or die "uanble to open $file.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* pathstep-timing */\n";
	print SPSS "/**********************************************/\n\n";
	
	print SPSS "GET DATA  /TYPE = TXT\n";
 	print SPSS "/FILE = '$file.tsv'\n";
 	print SPSS "/DELCASE = LINE\n";
 	print SPSS "/DELIMITERS = \"\\t\"\n";
 	print SPSS "/ARRANGEMENT = DELIMITED\n";
 	print SPSS "/FIRSTCASE = 2\n";
 	print SPSS "/IMPORTCASE = ALL\n";
 	print SPSS "/VARIABLES =\n";
 	print SPSS "UniqueID A50\n";
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
 	print SPSS "Title A50\n";
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
	
	if ($Prefs->{MAKE_SPSS_VALUE_LABELS} eq '1') {
		print SPSS "VALUE LABELS GROUP\n";
		my $count = 0;
		foreach my $label (@stepLabels) {
			++$count;
			print SPSS "\t$count " . &splitLongLabel($label,60) . "\n";
		}
		print SPSS "\t.\n";	# line terminator	
	}
	

	print SPSS "\nSAVE OUTFILE='$file.sav' /COMPRESSED.\n";
	
	close (SPSS);
}


sub createSPSSdictionaries {
	my ($sched_root, $nodes) = @_;
	my $allSpss;
	
	foreach (sort(keys(%modules))) {
		print "creating dictionary for module $_\n";
		
		my $file="$Prefs->{RESULTS_DIR}/$_";
		if ($Prefs->{UNIX_DOS} eq 'dos') {
			$file =~ s/\//\\/g;	
		}			
		&createSPSSdictionary($_,$file,$sched_root,$nodes);
		&createSASdictionary($_,$file,$sched_root,$nodes);
		
		$allSpss .= "INCLUDE FILE='$file.sps'.\n";
	}
}

sub createSPSSforValidModules {
	my $all_spss_file = "$Prefs->{RESULTS_DIR}/all_spss.sps";
	
	open (SPSS, ">$all_spss_file") or die "unable to open $all_spss_file";
	foreach (sort(keys(%modules))) {
		next if (/^(__NOTHING__)|(__DISCARD__)$/);
		my $file="$Prefs->{RESULTS_DIR}/$_-summary.sps";
		open (IN, "<$file") or die "unable to open $file";
		my @lines = (<IN>);
		foreach (@lines) { 
			chomp;
			print SPSS "$_\n";
		}
		close (IN);
		
		$file="$Prefs->{RESULTS_DIR}/$_-complete.sps";
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
	my $sortfn;
	
	if ($Prefs->{SORTBY} eq 'sortby_order_asked') {
		print "Using sortby='sortby_order_asked'\n";
		$sortfn = \&sortbyOrderAsked;
	}
	else {
		# default sort alphabetically by name
		print "Using sortby='sortby_variable_name'\n";
		$sortfn = \&sortbyVariableName;
	}
	
	open (SPSS, ">$file-summary.sps") or die "uanble to open $file-summary.sps";
	print "Writing to file $file-summary.sps ...";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* Module $_-summary */\n";
	print SPSS "/**********************************************/\n\n";

	print SPSS "GET DATA /TYPE = TXT\n";
	print SPSS "/FILE = '$file-summary.tsv'\n";
	print SPSS "/DELCASE = LINE\n";
	print SPSS "/DELIMITERS = \"\\t\"\n";
	print SPSS "/ARRANGEMENT = DELIMITED\n";
	print SPSS "/FIRSTCASE = 2\n";		# 4\n";
	print SPSS "/IMPORTCASE = ALL\n";
	print SPSS "/VARIABLES =\n";
	print SPSS "\tUniqueID A50\n";
	print SPSS "\tFinished F8.0\n";
	print SPSS "\tStartDat ADATE10\n";
	print SPSS "\tStopDate ADATE10\n";
	print SPSS "\tTitle A50\n";
	print SPSS "\tVersion A8\n";
	
	
	foreach (sort $sortfn @nodes) {
		my %n = %{ $_ };
		next if ($n{'module'} ne $module);
		
		print SPSS "\t$n{'c8name'} $n{'SPSSformat'}\n";
		push @freqVars, $n{'c8name'};
	}		

	print SPSS ".\n\n";
	
 	print SPSS "VARIABLE LABELS UNIQUEID \"Unique Identifier\".\n";
 	print SPSS "VARIABLE LABELS FINISHED \"Whether instrument was finalized (last next button pressed)\".\n";
	print SPSS "VARIABLE LABELS TITLE \"Instrument Title\".\n";
	print SPSS "VARIABLE LABELS VERSION \"Instrument Version\".\n";	
	
	if ($Prefs->{MAKE_SPSS_VALUE_LABELS} eq '1' or $Prefs->{MAKE_SPSS_VARIABLE_LABELS} eq '1') {
		foreach (sort $sortfn @nodes) {
			my %n = %{ $_ };
			
			next if ($n{'module'} ne $module);
			
			# want correct data types.  If pick list, unclear whether nominal or ordinal (but not likely to be scale).  Double and date are scale
			
			if ($Prefs->{MAKE_SPSS_VARIABLE_LABELS} eq '1') {
				print SPSS "VARIABLE LABELS $n{'c8name'}\n\t" . &splitLongLabel("[$n{'name'}] $n{'qtext'}",255) . ".\n";
			}
			
			if ($Prefs->{MAKE_SPSS_VALUE_LABELS} eq '1') {
				if ($n{'alen'} > 0) {
					# then has a data dictionary
					print SPSS "VALUE LABELS $n{'c8name'}\n";
					print SPSS &makeMissingList($missingValLabelsForStrings,"SPSS")	if $n{'isString'};
					print SPSS &makeMissingList($missingValLabelsForNums,"SPSS")		if $n{'isNum'};
		
					my %amap = %{ $n{'amap'} };
					foreach my $key (sort(keys(%amap))) {
						# determine data type first (so don't mix text and numbers?
						print SPSS "\t$key " . &splitLongLabel("[$key] $amap{$key}",60) . "\n";
					}
					print SPSS "\t.\n";	# line terminator
		
				}
			
				print SPSS "VARIABLE LEVEL $n{'c8name'} ($n{'level'}).\n";
				print SPSS "FORMATS $n{'c8name'} ($n{'SPSSformat'}).\n";
				print SPSS "MISSING VALUES $n{'c8name'} $missingListForNums.\n"		if ($n{'isNum'});
				print SPSS "MISSING VALUES $n{'c8name'} $missingListForStrings.\n"	if ($n{'isString'});
				print SPSS "\n";
			}
		}
	}

	print SPSS "FORMATS STARTDAT STOPDATE (ADATE10).\n";
	
	
	#save data and spo files
	print SPSS "\nSAVE OUTFILE='$file-summary.sav' /COMPRESSED.\n";
	
	#calc SPSS frequencies
	if ($Prefs->{MAKE_SPSS_FREQS} eq '1') {
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
	}
	print "... Done\n";

	
	########################################
	# Now create dictionaries for *-complete
	########################################
	
	open (SPSS, ">$file-complete.sps") or die "uanble to open $file-complete.sps";
	
	print SPSS "\n/**********************************************/\n";
	print SPSS "/* Module $_-complete */\n";
	print SPSS "/**********************************************/\n\n";

	print SPSS "GET DATA /TYPE = TXT\n";
	print SPSS "/FILE = '$file-complete.tsv'\n";
	print SPSS "/DELCASE = LINE\n";
	print SPSS "/DELIMITERS = \"\\t\"\n";
	print SPSS "/ARRANGEMENT = DELIMITED\n";
	print SPSS "/FIRSTCASE = 2\n";		#4\n";
	print SPSS "/IMPORTCASE = ALL\n";
	print SPSS "/VARIABLES =\n";
	print SPSS "\tUniqueID A50\n";
	print SPSS "\tFinished F8.0\n"; ##
	print SPSS "\tc8name A8\n";
	print SPSS "\tLanguage F8.2\n";
	print SPSS "\tVersion A8\n";
	print SPSS "\tAnswers A254\n";
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
	if ($Prefs->{MAKE_SPSS_VALUE_LABELS} eq '1') {
		print SPSS "VALUE LABELS C8NAME\n";
		foreach (sort $sortfn @nodes) {
			my %n = %{ $_ };
			next if ($n{'module'} ne $module);
			
			print SPSS "\t\"$n{'c8name'}\"\n\t" . &splitLongLabel("[$n{'name'}] $n{'qtext'}",255) . "\n";
		}
		print SPSS "\t.\n";
	}
	
	#save data and spo files
	print SPSS "\nSAVE OUTFILE='$file-complete.sav' /COMPRESSED.\n";
	
	#analyses
	print SPSS "\nCROSSTABS\n";
	print SPSS "\t/TABLES=c8name  BY nonans ok2ok ok2na na2ok nexts prevs repeats\n";
	print SPSS "\t/FORMAT= AVALUE TABLES\n";
	print SPSS "\t/CELLS= COUNT .\n";
	
	close (SPSS);
	
}

sub sortbyVariableName {
	return $a->{'name'} cmp $b->{'name'};
}
sub sortbyOrderAsked {
	return $a->{'step'} <=> $b->{'step'};
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
		if (length($arg) > ($maxlen-5)) {
			$text .= "\"" . substr($arg,0,($maxlen-5)) . "\"";
			$arg = substr($arg,($maxlen-5),length($arg));
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
	
#********* Here is the code for SAS ***************#


sub createSASdictionary {
	my $module = shift;
	my $file = shift;
	my $sched_root = shift;
	my $nodelist = shift;
	my @nodes = @{ $nodelist };
	my @freqVars;
	my $sortfn;
	
	if ($Prefs->{SORTBY} eq 'sortby_order_asked') {
		print "Using sortby='sortby_order_asked'\n";
		$sortfn = \&sortbyOrderAsked;
	}
	else {
		# default sort alphabetically by name
		print "Using sortby='sortby_variable_name'\n";
		$sortfn = \&sortbyVariableName;
	}
	
	open (SAS, ">$file-summary.sas") or die "uanble to open $file-summary.sas";
	print "Writing to file $file-summary.sas ...";
	
	print SAS "\n/**********************************************/\n";
	print SAS "/* SAS Module $_-summary */\n";
	print SAS "/**********************************************/\n\n";
	
	# [] Should I determine maximum line length for data files so that lrecl can be set accordingly?
	# Create import file for SAS
	print SAS "data WORK.SUMMARY;\n";
	print SAS "	%let _EFIERR_ = 0; /* set the ERROR detection macro variable */\n";
	print SAS "	infile '$file-summary.tsv'\n";
	print SAS "	delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;\n";
	
	# Define input and display formats for variables
	print SAS "\tinformat UniqueID \$50.; format UniqueID \$50.;\n";
	print SAS "\tinformat Finished best32.; format Finished best12.;\n";
	print SAS "\tinformat StartDat mmddyy10.; format StartDat mmddyy10.;\n";
	print SAS "\tinformat StopDate mmddyy10.; format StopDate mmddyy10.;\n";
	print SAS "\tinformat Title \$50.; format Title \$50.;\n";
	print SAS "\tinformat Version \$50.; format Version \$50.;\n";
	
	foreach (sort $sortfn @nodes) {
		my %n = %{ $_ };
		next if ($n{'module'} ne $module);
		
		print SAS "\tinformat $n{'name'} $n{'SASinformat'};  format $n{'name'} $n{'SASformat'};\n";
		push @freqVars, $n{'name'};
	}		
	
	# Create input statement to load data
	print SAS "\n\n\tINPUT\n";
	print SAS "\t\tUniqueID \$\n";
	print SAS "\t\tFinished\n";
	print SAS "\t\tStartDat\n";
	print SAS "\t\tStopDate\n";
	print SAS "\t\tTitle \$\n";
	print SAS "\t\tVersion \$\n";
	
	foreach (sort $sortfn @nodes) {
		my %n = %{ $_ };
		next if ($n{'module'} ne $module);
		
		if ($n{'isString'}) {
			print SAS "\t\t$n{'name'} \$\n";
		}
		else {
			print SAS "\t\t$n{'name'}\n";
		}
	}
	print SAS "\t\t;\n";
	
	# Add error checking conditions
	
	print SAS "\tif _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */\n";
	print SAS "run;\n\n";
	
	my @sasformatted;
	my $sasfmt_counter = 0;
	
	# Create proc format statements so can optionally display text of answer options
	if ($Prefs->{MAKE_SAS_FORMATS} eq '1') {
		print SAS "proc format;\n";
		foreach (sort $sortfn @nodes) {
			my %n = %{ $_ };
			
			next if ($n{'module'} ne $module);
			
			# want correct data types.  If pick list, unclear whether nominal or ordinal (but not likely to be scale).  Double and date are scale
			
			if ($n{'alen'} > 0) {
				# then has a data dictionary
				++$sasfmt_counter;
				my $fmtname = 	sprintf("%sDF%04df",($n{'isString'}?'$':''),$sasfmt_counter);
	
				print SAS "\tvalue $fmtname\n";
				
				my %amap = %{ $n{'amap'} };
				foreach my $key (sort(keys(%amap))) {
					# determine data type first (so don't mix text and numbers?
					print SAS "\t\t$key = " . &splitLongLabel("[$key]$amap{$key}",10000) . "\n";
				}
				print SAS &makeMissingList($missingValLabelsForStrings,"SAS")	if $n{'isString'};
				print SAS &makeMissingList($missingValLabelsForNums,"SAS")		if $n{'isNum'};
				print SAS "\t\t. = ' '\n";
				print SAS "\t\tOTHER = '?'\n";
				print SAS "\t;\n";	# line terminator
	
				push @sasformatted, { name=>$n{'name'}, fmt=>$fmtname };
			}
		}
		print SAS "run;\n";
	
		# Add the sas formatting to the data set
		print SAS "data WORK.SUMMARY; set WORK.summary;\n";
		
		foreach (@sasformatted) {
			my %n = %{ $_ };
			print SAS "\tformat $n{'name'} $n{'fmt'}.;\n";
		}
		print SAS "run;\n";
		
		# Save it somewhere 
		print SAS "options compress=BINARY;\n";
		print SAS "data '${file}summary.sas7bdat'; set WORK.summary; run;\n";
		print SAS "/*proc sql; drop table WORK.summary;*/\n";
		
		close (SAS);
	}
	print "... Done\n";
}

sub makeMissingList {
	my $txt = shift;
	my $type = shift;
	
	if ($type eq 'SAS') {
		$txt =~ s/SAS_SPSS/=/g;
	}
	elsif ($type eq 'SPSS') {
		$txt =~ s/SAS_SPSS//g;
	}
	return $txt;
}

sub doit {
	my $cmd = shift;
	print "$cmd\n";
	(system($cmd) == 0)	or die "ERROR";
}


sub showLogic {
	my $infile = shift;
	my $outfile = shift;
	my $title = shift;
	my $command = "perl $Prefs->{SHOWLOGIC} $infile $outfile \"$title\"";
	&doit($command);
}

sub createInstrumentTables {
	print qq|CREATE TABLE Dialogix.Instrument (
  InstrumentID int(11) NOT NULL auto_increment,
  Name text,
  Description text,
  Version varchar(20) default NULL,
  Publication date default NULL,
  Authors text,
  Citation text,
  Copyrighted enum('Y','N') default NULL,
  PRIMARY KEY  (InstrumentID)
) TYPE=MyISAM;


CREATE TABLE Dialogix.Instrument_Details (
  InstrumentsDetailsID int(11) NOT NULL auto_increment,
  Instrument_FK int(11) NOT NULL default '0',
  Concept text NOT NULL,
  InternalName text NOT NULL,
  ExternalName text NOT NULL,
  Relevance text NOT NULL,
  ActionType text NOT NULL,
  ReadBack text NOT NULL,
  ActionPhrase text NOT NULL,
  AnswerOptions text NOT NULL,
  HelpURL text NOT NULL,
  DefaultAnswer text NOT NULL,
  DefaultComment text NOT NULL,
  Sequence int(11) NOT NULL default '0',
  DisplayGroup int(11) NOT NULL default '0',
  PRIMARY KEY  (InstrumentsDetailsID)
) TYPE=MyISAM;
    |;
}
