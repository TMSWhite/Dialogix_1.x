#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# Perl script to read data from study datafiles & convert from vertical to horizontal format
# usage:
#		perl perl dat2sas.pl uniqueID modularizeByPrefix discardVarsMatchingPattern GLOB
# reads all files conforming to GLOB pattern (e.g. *P.)
# extracts most current data from each, as well as the unique identifier
# creates one file per module
# foreach source file, writes the most current data from each module to the appropriate file
# if any variables are '*', then ignores them (e.g. huid, modulePrefix, discardPrefix)
#
# now prints out both vertical and horizontal files
# Horizontal - one line per file, with first column = huid
# Vertical
#   - preserves data column order
#   - prefixes one column: containing huid
#   - only prints most recent data
#   - does so in order of variables in schedule file (not collection order)
#   - The following columns are generated:
#       huid  count  internalName  languageNum  timeStamp  questionAsAsked  answerGiven  comment  when  duration
#     where the variables mean the following:
#       huid = unique identifier
#       count = index of this variable in the schedule file (not order collected) - first is 0
#       internalName = the unique name of the variable
#       languageNum = which language was used, 0-n index of the languages available in the schedule
#       timeStamp = milliseconds since 1/1/1970
#       questionAsAsked = the question, as the subject saw it
#       answerGiven = the answer the subject gave - either text, or the number corresponding to a pick-list
#       comment = any optional comment the subject made about a question
#       when = the number of seconds since the start of the interview
#       duration = the number of seconds spent on that question (roughly - only the first question of a block will have the correct duration recorded


use IO::File;
use strict;

if ($#ARGV < 9) {
	print "Usage:\nperl dat2sas.pl instrument uniqueID modularizeByPrefix discardVarsMatchingPattern NA REFUSED UNKNOWN HUH INVALID UNASKED *.dat\n";
	print "e.g. perl dat2sas.pl FullHUID [A-Za-z]+ ND.* 9999 8888 7777 6666 5555 4444 *.dat\n";
	exit(0);
}

my $MAX_PREV = 27;

my ($instrument, %sched, %sched_nodes);
my ($uniqueID, $modulePrefix, $discardPrefix,@gargs,$filename);
my ($NA, $REFUSED, $UNKNOWN, $HUH, $INVALID, $UNASKED);
@gargs = @ARGV;
my (@pathLog,@pathHash,@pathByStep);
my (@stepOrder, @stepDirection);	# make global for faster processing by &computeVarHistory?

$instrument = shift(@gargs);
$uniqueID = shift(@gargs);
$modulePrefix = shift(@gargs);
$discardPrefix = shift(@gargs);

$NA = shift(@gargs);
$REFUSED = shift(@gargs);
$UNKNOWN = shift(@gargs);
$HUH = shift(@gargs);
$INVALID = shift(@gargs);
$UNASKED = shift(@gargs);

&load_instrument($instrument);

foreach(@gargs) {
	my @files = glob($_);

	
	foreach my $filename (@files) {
		open (SRC,$filename)		or die("unable to open $filename");
		my @lines = (<SRC>);	# read entire file
		close (SRC);
		my %data;
		my %modules;
		my %outs;
		my $huid='';
		my $internalName;
		my $module='';
		my $out='';
		my @vals=();
		my $count = -1;
		my $print_count = 0;
		my $datum;
		my $startTime = '';
		my $stopTime = '';
		my $lastSendTime = '';
		my @path_info;
		my $instrument;
		my $ip;
		my $finished;
		my $currentStep=0;
		my $lastWasDisplay=0;
		my $schedMajor = 0;
		my $schedMinor = 0;
		my @sendTimes;
		my @receiveTimes;
		my $schedVersion = 0;
		my $currentDispCnt=0;
		@stepOrder = ();
		@stepDirection = (1);	# always start going forward
		
		my $lastDisplayStep = 0;
		
		# recording the duration is a bit of a pain due to the file format
		# DISPLAY_COUNT is set immediately before the page is sent.  
		# Then, the first item recorded after it is the time the page was received back (minus some minimal processing.
		
		# Extract the data values from the lines, keeping the most recent value
		foreach(@lines) {
			chomp;
			
			@vals = split(/\t/);
			
			next if ($vals[0] =~ /^\s*COMMENT/);
			
			# capture timing and path information
			if ($lastWasDisplay) {
				# valid values, going backwards, or no content between pages
				$lastWasDisplay = 0;
				push @path_info, { 
					step=>$currentStep, 
					when=>($vals[3] - $startTime), # should be when started, or when received?
					duration => ($vals[3] - $lastSendTime),	# receive time
				};
				push @stepOrder, $sched{$currentStep}{'display'};	# the normalized step number from *.steps.			
			}			
			
			if ($vals[0] eq 'RESERVED') {
				if ($vals[1] eq '__START_TIME__') {
					$startTime = $vals[2];
					$stopTime = $startTime;	# so that have something to compare against
					$lastSendTime = $startTime;
				}
				elsif ($vals[1] eq '__STARTING_STEP__') {
					$currentStep = $vals[2];
				}
				elsif ($vals[1] eq '__DISPLAY_COUNT__') {
					$lastDisplayStep = $currentStep;
					$lastWasDisplay = 1;
					$lastSendTime = $vals[3];
					$currentDispCnt = $vals[2];
#					next;	# so don't reset $lastWasDisplay
				}
				elsif ($vals[1] eq '__TITLE__') {
					$instrument = $vals[2];
				}
				elsif ($vals[1] eq '__IP_ADDRESS__') {
					$ip = $vals[2];
				}
				elsif ($vals[1] eq '__SCHED_VERSION_MAJOR__') {
					if ($vals[2] =~ /^\s*$/) {
						$schedMajor = "0";
					}
					else {
						$schedMajor = $vals[2];
					}
				}
				elsif ($vals[1] eq '__SCHED_VERSION_MINOR__') {
					if ($vals[2] =~ /^\s*$/) {
						$schedMinor = "0";
					}
					else {
						$schedMinor = $vals[2];
					}
					$schedVersion = "$schedMajor.$schedMinor";
					$schedVersion =~ s/\.\././g;
				}
#				$lastWasDisplay = 0;
				next;
			}
			
			++$count;
			
			if ($uniqueID ne '*' && $vals[1] =~ /^$uniqueID$/) {
				$huid = $vals[5];
			}
			
			if ($discardPrefix ne '*' && $vals[1] =~ /^$discardPrefix/) {
				$module = "__DISCARD__";
			}
			elsif ($sched_nodes{$vals[1]}{'atype'} eq 'nothing' && $sched_nodes{$vals[1]}{'type'} !~ /^e/i) {	# an instructional question
				$module = "__NOTHING__";
			}
			elsif ($modulePrefix ne '*' && $vals[1] =~ /^($modulePrefix)/) {
				$module = $1;
			}
			else {
				$module = "__MAIN__";
			}			
			
			$internalName = $vals[1];
			
			if (defined($internalName) && $internalName !~ /^\s*$/) {
				my @ansList;
				my @dispCntList;
				
				my $ans = &fixSpecialAnswers($vals[5]);
				if ($ans =~ /^\s*$/) {
					if ($sched_nodes{$vals[1]}{'atype'} eq 'nothing') {
						$ans = '.';	# assumes that a missing value, with a value of '.', since nothing elements should not have results (unless an eval)
						$vals[5] = '.';
					}
				}
				
				$datum = $data{$internalName};
				if (defined($datum) && defined($datum->{'count'})) {
					# XXX what does this do?
					$print_count = $datum->{'count'};	# keep count the same as first appearance
					@ansList = @{ $datum->{'answers'} };	# get old values
					@dispCntList = @{ $datum->{'dispCnts'} };
				}
				else {
					$print_count = $count;
				}
				push @ansList, $vals[5];	# use unmodified value to faciliate assessment for NA
				push @dispCntList, $currentDispCnt;	# so that normalized to display#
				
				$datum = {
					module => $module,
					count => $print_count,
					internalName => $internalName,
					languageNum => $vals[2],
					timeStamp => $vals[3],
					questionAsAsked => $vals[4],
					answerGiven => $ans,
					comment => &fixComment($vals[6]),
					when => ($vals[3] - $startTime) / 1000,
					duration => ($vals[3] - $stopTime) / 1000,
					concept => $sched_nodes{$vals[1]}{'concept'},
					c8name => $sched_nodes{$vals[1]}{'c8name'},
					
					# record changes in variable values
					answers => \@ansList,	# want raw answer value to facilitate assessment for changes
					dispCnts => \@dispCntList,	# list of indicies where this answer occurred
				};
				$data{$internalName} = $datum;
				$modules{$module} = $module;
				
				$stopTime = $vals[3];	# ending time of the this event - used to determine duration of next event
			}
		}
		# if last line in the file is DISPLAY_COUNT, then this was unfinished, and last line indicates which question was viewed but not answered.
		if ($lastWasDisplay) {
			# valid values, going backwards, or no content between pages
			$lastWasDisplay = 0;
			push @path_info, { 
				step=>$currentStep, 
				when=>($vals[3] - $startTime), # should be when started, or when received?
				duration => ($vals[3] - $lastSendTime),	# receive time
			};
			push @stepOrder, $sched{$currentStep}{'display'};	# the normalized step number from *.steps.			
		}
		
		shift(@stepOrder);	# since first is duplicate
		
		# determine the order in which steps were visited (e.g. whether prev, next, or repeat)
		for (my $i=0;$i < $#stepOrder;++$i) {
			push @stepDirection, ($stepOrder[$i+1] <=> $stepOrder[$i]);	# does three-way comparison between adjacent steps.
		}
		
		# skip the file if wrong IP or schedule
#		next if (&badInstrument($instrument));			
#		next if (&IPtype($ip) > 0);		
		
		# now convert the time stamps to usable format
		my $startDate = &fixTime($startTime);
		my $stopDate = &fixTime($stopTime);
		
		# use default filename, if necessary
		my $filebase = &calc_huid($filename);
		if ($filebase =~ /^tri[0-9]+$/) {
			$finished = 0;
		}
		else {
			$finished = 1;
		}
		if ($huid eq '') {
			$huid = $filebase;
		}
		
#		print "$huid\t" . join(',',@stepOrder) . "\t" . join(',',@stepDirection) . "\n";	# debuging order and direction -- success
		
		shift(@path_info);	# remove first reference to STARTING_STEP -- since first is duplicated
		
		push @pathHash, &pathHash($huid, $ip, $instrument, "$schedVersion", $startTime, $stopTime, $finished, \@path_info);
		
		#open module files for output, creating hash of filehandles
		foreach my $key (sort(keys(%modules))) {
			$out = $key . '-summary.log';
			my $fh = new IO::File;
			die "error opening file $out" unless ($fh->open(">>$out"));	# append to existing files
			$outs{$key} = $fh;
			
			if (-z $out) {
				# file doesn't exist yet, so create it with the proper column headings
				print { $fh } "UniqueID\tFinished\tStartDate\tStopDate\tTitle\tVersion";
				
#				foreach my $arg (sort { $a->{'count'} <=> $b->{'count'} } values(%data)) {		# this sorts by order asked
#					my %datum = %{ $arg };					
				foreach my $arg (sort(keys(%data))) {	# this sorts alphabetically by variable name
					my %datum = %{ $data{$arg} };
					next unless ($key eq $datum{'module'});
					print { $fh } "\t", $datum{'internalName'};	#separate labels by tab
				}
				print { $fh } "\n";	# add newline
				
				# now do the same for the concept
				print { $fh } "UniqueID\tFinished\tStartDate\tStopDate\tTitle\tVersion";
				
#				foreach my $arg (sort { $a->{'count'} <=> $b->{'count'} } values(%data)) {
#					my %datum = %{ $arg };					
				foreach my $arg (sort(keys(%data))) {
					my %datum = %{ $data{$arg} };
					next unless ($key eq $datum{'module'});
					print { $fh } "\t", $datum{'concept'};	#separate labels by tab
				}
				print { $fh } "\n";	# add newline	
				
				print { $fh } "UniqueID\tFinished\tStartDat\tStopDate\tTitle\tVersion";
				
#				foreach my $arg (sort { $a->{'count'} <=> $b->{'count'} } values(%data)) {
#					my %datum = %{ $arg };					
				foreach my $arg (sort(keys(%data))) {
					my %datum = %{ $data{$arg} };
					next unless ($key eq $datum{'module'});
					print { $fh } "\t", $datum{'c8name'};	#separate labels by tab
				}
				print { $fh } "\n";	# add newline								
			}
		}
		
		#print huid at beginning of row for each module file
		foreach my $key (sort(keys(%outs))) {
			# also print start time, stop time, and duration?
			print { $outs{$key} } "$huid\t$finished\t$startDate\t$stopDate\t$instrument\t$schedVersion";
		}
		
		# foreach variable, print it in row form to the appropriate file
		foreach my $key (sort(keys(%data))) {
			my %datum = %{ $data{$key} };
#		foreach my $key (sort { $a->{'count'} <=> $b->{'count'} } values(%data)) {
#			my %datum = %{ $key };
			next unless defined(%datum);
			print { $outs{$datum{'module'}} } "\t", $datum{'answerGiven'};
		}
		
		#close all output files, add newline and close
		foreach my $key (sort(keys(%outs))) {
			$out = $outs{$key};
			
			print { $out } "\n";
			close($out);
		}
		
		#write status file - vertical with most recent values
		
		foreach my $module (sort(keys(%modules))) {
			unless (-e "$module-complete.log") {
				print "creating $module-complete.log\n";
				open (OUT, ">$module-complete.log");	
#				print OUT "UniqueID\tStep\tName\tc8name\tLanguage\tAnswer\tComment\tVersion";
				print OUT "UniqueID\tFinished\tc8name\tLanguage\tVersion";
				print OUT "\tAnswers\tDispCnts\tDirectns\tVisits\tPrevs\tRepeats\tNexts\tChanges\tRetains\tNa2Na\tNa2Ok\tOk2Na\tOk2Ok\tNonAns\n";				
				close (OUT);
			}
		}	
		
		foreach my $module (sort(keys(%modules))) {
			open (OUT, ">>$module-complete.log");
			foreach my $key (sort { $a->{'count'} <=> $b->{'count'} } values(%data)) {
				my %datum = %{ $key };
				next if ($datum{'module'} ne $module);
#				print OUT "$huid\t$datum{'count'}\t$datum{'internalName'}\t$datum{'c8name'}\t$datum{'languageNum'}\t$datum{'timeStamp'}\t$datum{'answerGiven'}\t$datum{'comment'}\t$datum{'when'}\t$datum{'duration'}\t$datum{'concept'}\t$instrument\t$schedVersion";
#				print OUT "$huid\t$datum{'count'}\t$datum{'internalName'}\t$datum{'c8name'}\t$datum{'languageNum'}\t$datum{'answerGiven'}\t$datum{'comment'}\t$schedVersion";
				print OUT "$huid\t$finished\t$datum{'c8name'}\t$datum{'languageNum'}\t$schedVersion";
				
				my $msg = &computeVarHistory($datum{'answers'},$datum{'dispCnts'});
				print OUT "\t$msg\n";
			}
			close (OUT);
		}
	}
}

&processPath;

sub computeVarHistory {
	# determine path taken through answers to variables
	my ($answers_ref, $dispCnts_ref) = @_;
	my @answers = @$answers_ref;
	my @dispCnts = @$dispCnts_ref;
	
	my @directions;
	my $visits = $#answers;
	my $prevs = 0;
	my $nexts = 0;
	my $repeats = 0;	
	
	shift(@dispCnts);	# since first will always be 1 for forward
	
	foreach (@dispCnts) {
		my $dir = $stepDirection[$_ - 1];	# dispCnt is base 1, so index is its value - 1
		push @directions, $dir;	
		++$prevs if ($dir == -1);
		++$repeats if ($dir == 0);
		++$nexts if ($dir == 1);
	}
	
	my $changes = 0;
	my $retains = 0;
	my $na2ok = 0;
	my $ok2na = 0;
	my $ok2ok = 0;
	my $nonAns = 0;
	
	for (my $i=0;$i< $#answers;++$i) {
		my $a = $answers[$i];
		my $b = $answers[$i+1];
		if ($a eq $b) {
			++$retains unless ($i == 0);
		}
		else {
			++$changes unless ($i == 0);
		}
		if ($b eq '*UNASKED*') {
			++$nonAns;
		}
		if ($a eq '*NA*') {
			++$na2ok unless ($b eq '*NA*');
		}
		elsif ($i > 0) {	# so that first setting of value doesn't look like a mistake
			if ($b eq '*NA*') {
				++$ok2na;	
			}
			else {
				++$ok2ok if ($b ne $a);	# meaans that changed from one valid value to another
			}
		}
	}
	
	shift(@answers);	# since first will always be *UNKNOWN*
	
	if ($visits == 0) {
		@answers = @dispCnts = @directions = ('.');
	}

	#print OUT "\tAnswers\tDispCnts\tDirectns\tVisits\tPrevs\tRepeats\tNexts\tChanges\tRetains\tNa2Na\tNa2Ok\tOk2Na\tOk2Ok\tNonAns\n";				
	#print Answers DispCnts Directions Visits Prevs Repeats Nexts Changes Retains Na2Na Na2Ok Ok2Na Ok2Ok
	
	my $msg =	join(',',@answers) . "\t" . join(',',@dispCnts) . "\t" . join(',',@directions) . 
		"\t$visits\t$prevs\t$repeats\t$nexts\t$changes\t$retains\t$na2ok\t$ok2na\t$ok2ok\t$nonAns";
		
	return $msg;
}



sub processPath {
	&processPathHash;
	&showPathLog;
	&pathTotals;
	&pathByStep;
}

sub pathByStep {
	open (PATH,">pathstep-timing.log")	or die("unable to open pathstep-timing.log");
	print PATH "UniqueID\tDispCnt\tGroup\tWhen\ttDur\tQlen\tAlen\tTlen\tNumQs\ttDurSec\tTimevsQ\tTimevsT\tTitle\tVersion\n";
	
	foreach (@pathByStep) {
		print PATH "$_\n";
	}
	close(PATH);
}
		
	
sub showPathLog {
	open (PATH,">pathstep-summary.log")	or die("unable to open pathstep-summary.log");
#	print PATH "UniqueID\tType\tTitle\tVersion\tIP\tStartTime\tStopTime\ttDur\ttDurSec\tNumSteps\tPath\tRawPath\n";
	print PATH "UniqueID\tTitle\tVersion\tFinished\ttDur\ttDurSec\tNumSteps\tPath\tlastAns\tlastAnsN\tlstView\tlstViewN\n";
	
	foreach my $line (@pathLog) {
		print PATH $line;
	}

	close (PATH);
}

sub load_instrument {
	my $arg = shift;
	
	&load_instrument_steps($arg);
	&load_instrument_nodes($arg);
}


sub load_instrument_steps {
	my $arg = shift;
	
	open (INST, "$arg.steps") or die "unable to open instrument $arg.steps";
	my @lines = (<INST>);
	close (INST);
	
	shift(@lines);	# remove header row
	
	foreach my $line (@lines) {
		chomp($line);
		my @vals = split(/\t/,$line);
		$sched{$vals[1]} = { 
			firstStep => $vals[1],
			display => $vals[0],
			qlen => $vals[2],
			alen => $vals[3],
			tlen => $vals[4],
			numSteps => $vals[5],
			name => $vals[6]
		};
	}
}

sub load_instrument_nodes {
	my $arg = shift;
	
	open (INST, "$arg.nodes") or die "unable to open instrument $arg. nodes";
	my @lines = (<INST>);
	close (INST);
	
	shift(@lines);	# remove header row
	
	foreach my $line (@lines) {
		chomp($line);
		my @vals = split(/\t/,$line);
		$sched_nodes{$vals[2]} = { 	# index by name so can lookup concept
			firstStep => $vals[0],
			concept => $vals[1],
			name => $vals[2],
			type => lc($vals[3]),	# e.g. q, e, [, ]
			qlen => $vals[4],
			alen => $vals[5],
			atype => $vals[6],		# e.g. date, double, nothing, ...
			c8name => $vals[7],		# unique 8 char name
		};
	}
}

sub fixSpecialAnswers {
	my $arg = &fixAns(shift);
	
	if ($NA ne '*' && $arg eq '*NA*') { return $NA; }
	elsif ($REFUSED ne '*' && $arg eq '*REFUSED*') { return $REFUSED; }
	elsif ($UNKNOWN ne '*' && $arg eq '*UNKNOWN*') { return $UNKNOWN; }
	elsif ($HUH ne '*' && $arg eq '*HUH*') { return $HUH; }
	elsif ($INVALID ne '*' && $arg eq '*INVALID*') { return $INVALID; }
	elsif ($UNASKED ne '*' && $arg eq '*UNASKED*') { return $UNASKED; }	
	else { return $arg; }
}

sub fixTime {
	my $arg = shift;
	
	my @timeArray = localtime(int($arg/1000));
	my $ans = ($timeArray[4]+1) . "/$timeArray[3]/" . ($timeArray[5] + 1900);
	return $ans;
}	

sub fixAns {
	my $arg = shift;
	if ($arg eq "*N/A*") { return "*NA*"; }
	elsif ($arg eq "*DONT_UNDERSTAND*") { return "*HUH*"; }
	else { return &fixComment($arg); }
}

sub fixComment {
	my $arg = shift;
	if ($arg =~ m/\+/ && $arg !~ m/ /) {
		$arg =~ s/\+/ /g;
	}
	$arg =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eog;	# URI unescape
	$arg =~ s/\s+/ /og;	# convert all whitespace to simple space character
	return $arg;
}

sub pathTotals {
	open (PATH,">pathstep-visits.log")	or die("unable to open pathstep-visits.log");
	
	# print headers - will be variable number based on max # of possible display steps - may be limited by Excel's ~250 column limit
	print PATH "UniqueID\tType\tInstrument\tIP\tStartTime\tStopTime\ttDur\ttDurSec\tNumSteps\tFinish\tEnd\tJump\tPrev\tRepeat\t";
	
	my @extra;
	my @vals;
	my $max_disp = keys(%sched);	# assumes that all schedules require a visit to the same final node
	
	foreach (1 .. $MAX_PREV) {
		push @extra, "Prev$_";
	}
	foreach my $step (sort { $a <=> $b } keys(%sched)) {
		my %n = %{ $sched{$step} };
		push @extra, "s$n{'display'}-$n{'name'}";
	}
	print PATH join("\t",@extra) . "\n";
	
	# print contents
	foreach my $path (@pathHash) {
		my %p = %{ $path };
		undef @vals;
		
		my ($finish,$end) = (0,0);
		$finish = 1 if ($p{'huid'} !~ /^tri/);
		my @ds = split(/\s/,$p{'path'});
		
		# print the typical stuff
		print PATH "$p{'huid'}\t$p{'type'}\t$p{'instrument'}\t$p{'ip'}\t$p{'startTime'}\t$p{'stopTime'}\t$p{'duration'}\t$p{'durSec'}\t";
		print PATH "$p{'numSteps'}\t$finish\t";
		
		# calculate number of visits to each node
		my (@d, @prevs);
		foreach (0 .. ($MAX_PREV-1)) { $prevs[$_] = 0; }	# is there a better way to do this?
		foreach (0 .. ($max_disp-1)) { $d[$_] = 0; }
		my ($prevLen, $prevCount,$repeats,$jump) = (0,0,0,0);
		my $lastStep = -1;
		
		foreach my $step (@ds) {
			next unless (defined($step));
			$d[($step-1)] += 1;
			if ($step < $lastStep) {
				if (($lastStep - $step) > 10) {	# FIXME - a hack - really want to know whether it is a valid undo by back-tracking the path
					++$jump;
					$prevCount = 0;
				}
				else {
					++$prevLen;
					$prevs[($prevLen-1)] += 1	if ($prevLen <= $MAX_PREV);
					$prevs[($MAX_PREV-1)] += 1 if ($prevLen > $MAX_PREV);	# so that last index is N+
					++$prevCount;
				}
			}
			elsif ($step == $lastStep) {
				++$repeats;
			}
			else {
				# now adjust for the maximum length of going previous - only keep maximum depth
				if ($prevLen > 1) { 
					for (0 .. ($prevLen-2)) {
						--$prevs[$_] if ($_ < ($MAX_PREV-1));
					}
				}
				$prevLen = 0;
			}
			$lastStep = $step;
		}
		
		$end = 1 if ($d[($max_disp-1)] > 0);
		print PATH "$end\t$jump\t$prevCount\t$repeats\t";
		print PATH join("\t",@prevs) . "\t";
		print PATH join("\t",@d);
		print PATH "\n";
	}

	close (PATH);
}

# A generic path analysis function
sub pathHash {
	my ($huid, $ip, $instrument, $version, $startTime, $stopTime, $finished, $path_info_ref) = @_;
	my (@path, @path_step, @path_info);
	my $counter = 0;
	my ($node, %n);
	@path_info = @$path_info_ref;
	
	foreach my $s (@path_info) {
		my %step = %{ $s };
		$node = $sched{$step{'step'}};
		push @path_step, $step{'step'};
		next unless defined($node);
		%n = %{ $node };
		push @path, $n{'display'};
		
		#step vs display logs
		my $TimevsT = '.';
		my $TimevsQ = '.';
		if ($n{'tlen'} != 0) {
			$TimevsT = ($step{'duration'} / $n{'tlen'}) / 1000;
		}
		if ($n{'qlen'} != 0) {
			$TimevsQ = ($step{'duration'} / $n{'qlen'}) / 1000;
		}
		++$counter;
		push @pathByStep, "$huid\t$counter\t$n{'display'}\t" . &convertDuration($step{'when'}) . "\t" . &convertDuration($step{'duration'}) .
			"\t$n{'qlen'}\t$n{'alen'}\t$n{'tlen'}\t$n{'numSteps'}\t" . ($step{'duration'}/1000) . "\t$TimevsQ\t$TimevsT\t$instrument\t$version";
	}
	
	my ($lastAnswered, $lastViewed, $lastAnsweredStep, $lastViewedStep);
	$lastViewed = $path_step[$#path_step];
	if ($finished) {
		$lastAnswered = $lastViewed;
	}
	else {
		$lastAnswered = '.';	# means none answered -- the default.
		my @path_step_copy = (@path_step);
		while (@path_step_copy) {
			my $step = pop(@path_step_copy);
			if ($step ne $lastViewed) {
				$lastAnswered = $step;
				last;
			}
		}
	}
	my ($lastAnsweredName, $lastViewedName);
	$node = $sched{$lastViewed};
	$lastViewedStep = $node->{'display'};
	$lastViewedName = "[$lastViewedStep] $node->{'name'}";
	$node = $sched{$lastAnswered};
	if ($lastAnswered eq '.' || !defined($node)) {
		$lastAnsweredName = '.';
		$lastAnsweredStep = '.';
	}
	else {
		$lastAnsweredStep = $node->{'display'};
		$lastAnsweredName = "[$lastAnsweredStep] $node->{'name'}";
	}
	
	return {
		huid => $huid,
		type => &IPtype($ip),
		instrument => $instrument,
		version => $version,
		ip => $ip,
		startTime => &convertTime($startTime),
		stopTime => &convertTime($stopTime),
		duration => &convertDuration($stopTime - $startTime),
		durSec => (($stopTime - $startTime) / 1000),
		numSteps => ($#path_info + 1),
		path => join(' ',@path),
		pathStep => join(' ',@path_step),
		finished => $finished,
		lastViewed => $lastViewedStep,
		lastViewedName => $lastViewedName,
		lastAnswered => $lastAnsweredStep,
		lastAnsweredName => $lastAnsweredName,
	};
}

sub processPathHash {
	
	foreach my $path (@pathHash) {
		my %p = %{ $path };
		
		# print PATH "UniqueID\tInstrument\tVersion\tFinished\ttDur\ttDurSec\tNumSteps\tPath\tlastAns\tlastAnsN\tlstView\tlstViewN\n";
		
#		push @pathLog, "$p{'huid'}\t$p{'type'}\t$p{'instrument'}\t$p{'version'}\t$p{'ip'}\t$p{'startTime'}\t$p{'stopTime'}\t$p{'duration'}\t$p{'durSec'}\t$p{'numSteps'}\t$p{'path'}\t$p{'pathStep'}\n";
		push @pathLog, "$p{'huid'}\t$p{'instrument'}\t$p{'version'}\t$p{'finished'}\t$p{'duration'}\t$p{'durSec'}\t$p{'numSteps'}\t$p{'path'}" .
			"\t$p{'lastAnswered'}\t$p{'lastAnsweredName'}\t$p{'lastViewed'}\t$p{'lastViewedName'}\n";

	}
}

sub IPtype {
	my $ip = shift;
	return 1 if ($ip eq '156.111.139.159');	# mine
	return 1 if ($ip eq '156.111.178.193');	# piwhite
	return 2 if ($ip eq '156.111.179.171'); # Terman's Mac
	return 0;
}

sub badInstrument {
	my $inst = shift;
	return 1 unless $inst eq $instrument;
	return 0;
}

sub convertTime {
	my $arg = shift;
	$arg = localtime(int($arg/1000));
	if ($arg =~ /(\w+?)\s+(\w+?)\s+(\d+?)\s+(\d+?):(\d+?):(\d+?)\s+(\d\d\d\d)/) {
		#Wed Jun 06 14:18:33 2001
		return &month($2) . "/$3/$7 $4:$5:$6";
	}
}

sub convertDuration {
	my $arg = shift;
	
	return 
		int($arg / (1000 * 60 * 60)) . ":" .
		(int($arg / (1000 * 60)) % 60) . ":" .
		(int($arg / (1000)) % 60) . "." .
		($arg % 1000);
}

sub month {
	$_ = shift;
	return 1 if (/Jan/i);
	return 2 if (/Feb/i);
	return 3 if (/Mar/i);
	return 4 if (/Apr/i);
	return 5 if (/May/i);
	return 6 if (/Jun/i);
	return 7 if (/Jul/i);
	return 8 if (/Aug/i);
	return 9 if (/Sep/i);
	return 10 if (/Oct/i);
	return 11 if (/Nov/i);
	return 12 if (/Dec/i);
	return 0;
}

sub calc_huid {
	use File::Basename;
	my $base = basename(shift,"\.dat.*");
	return (split(/\./,$base))[0];
}
		
