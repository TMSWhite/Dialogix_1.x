#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# event files have the following syntax
#   each line has 8 tab-delimited values
#   the column layout is:
#     displayCount varName actionType eventType timestamp duration value1 value2

use strict;

if ($#ARGV < 2) {
	print "Usage:\nperl evt2sas.pl uniqueID discardVarsMatchingPattern *.evt\n";
	exit(0);
}

my ($uniqueID, $discardPrefix,@gargs,$filename,$instrument);
my (%huidStep2path, %sched_nodes);
@gargs = @ARGV;

$instrument = shift(@gargs);
$uniqueID = shift(@gargs);
$discardPrefix = shift(@gargs);

my ($varName, %vars, %varInfo, @vals);
my ($networkDelay, $turnaroundTime, $displayTime, $networkSendTime, $loadTime, $clientReceiveTS, $serverSendTS, $serverTime);
my ($networkReceiveTime, $serverReceiveTS, $clientSendTS, $displayCount, $firstPostFocusTS, $focusTS);
my ($lastTS, $loadTS, $lastLoadTS, $loadDiff);
my ($name, $type, $focus, $blur, $change, $click, $keypress, $mouseup, $totalTime, $inputTime, $answered, $skipped);
my ($huid);

&load_instrument_nodes($instrument);


# this section is dependent upon dat2sas.pl's section for pathstep-timing.log -- reads directly from it!
open(PATHSTEP,"<pathstep-timing.log") or die("unable to open 'pathstep-timing.log'");
my @lines = (<PATHSTEP>);
close(PATHSTEP);
foreach (@lines) {
	chomp;
	my @vars = split(/\t/);
	
	# Group When Qlen Alen Tlen NumQs Title Version tDurSec tTimeVsQ tTimeVsT:  keyed on "huid.dispCnt"
	$huidStep2path{"$vars[0].$vars[1]"} = "$vars[2]\t$vars[3]\t$vars[5]\t$vars[6]\t$vars[7]\t$vars[8]\t$vars[9]\t$vars[10]\t$vars[11]\t$vars[12]\t$vars[13]";
}

open(PERVAR,">__PerVar__.log")	or die("unable to write to '__PerVar__.log'");
print PERVAR "UniqueID\tdispCnt\tnumQs\twhichQ\tc8name\tname\tinpType\ttotTime\tinpTime\tanswered\tskipped\tfocus\tblur\tchange\tclick\tkeypress\tmouseup";
print PERVAR "\tAtype\tAlen\tQlen\tTlen\tqTimevsT\tiTimevsA\n";

open(PERSCREEN,">__PerScreen__.log")	or die("unable to write to '__PerScreen__.log'");
#print PERSCREEN "UniqueID\tdispCnt\tservSec\tloadSec\tdispSec\tturnSec\tntwkSec\tntwkSend\tntwkRecv\tloadDate\tloadTime\tloadDiff\n";
print PERSCREEN "UniqueID\tdispCnt\tGroup\tWhen\tQlen\tAlen\tTlen\tNumQs\ttDurSec\ttTimevsQ\ttTimevsT\tTitle\tVersion\tservSec\tloadSec\tdispSec\tturnSec\tntwkSec\tdTimevsQ\tdTimevsT\n";

foreach(@gargs) {
	my @files = glob($_);
	
	foreach my $filename (@files) {
		open (SRC,$filename)		or die("unable to read $filename");
		my @lines = (<SRC>);	# read entire file
		close (SRC);
		
		$huid = &calc_huid($filename);
		
		$displayCount = 0;	# reset to 0 for each new file
		$lastLoadTS = -1;
		
		# Extract the data values from the lines, keeping the most recent value
		foreach(@lines) {
			chomp;
			
			if (/^\*\*/) {
				&printVarInfo;	# in case of early termination;
				next;
			}
			
			@vals = split(/\t/);
			
			if ($vals[0] != $displayCount) {
				&printVarInfo;	# when find new display count, print info about previous one
				$displayCount = $vals[0];
			}
			
			# switch on types of events
			if ($vals[3] eq 'sent_request') {
				$serverTime = ($vals[5] / 1000);		# total processing time by the server from time received one page to time sent the next
				$serverSendTS = $vals[4];	# server side timestamp of when sent HTML
			}
			elsif ($vals[3] eq 'load') {
				$loadTime = ($vals[5] / 1000);			# total page rendering time (from time received HTML to time it was displayed to user
				$clientReceiveTS = $vals[4];	# client side timestamp when received HTML
				$loadTS = $vals[4];				# the timestamp of when loaded
			}
			elsif ($vals[3] eq 'received_response') {
				$turnaroundTime = ($vals[5] / 1000);	# total time between sending and receiving data
				$serverReceiveTS = $vals[4];	# server side timestamp of when received response to a page
				
				# if user pressed ENTER on a single-entry text box, then could advance without clicking a button
				if ($displayTime == -1) {
					$displayTime = ($lastTS - $loadTS) / 1000;
					$clientSendTS = $lastTS;
				}
			}
			
			# now assess question by question metrics
			next if (($vals[1] =~ m/^\s*$/) || ($vals[1] eq 'null'));	# can safely ignore these - only used for load, received_response, and sent_request
			
			
			$firstPostFocusTS = 0		if ($varName ne $vals[1]);
			$varName = $vals[1];
			&retrieveInfo;
						
			# count metrics for each display variable
			my $action = $vals[3];
			
			++$focus		if ($action eq 'focus');
			++$blur			if ($action eq 'blur');
			++$change		if ($action eq 'change');
			++$click		if ($action eq 'click');
			++$keypress		if ($action eq 'keypress');
			++$mouseup		if ($action eq 'mouseup');
			
			if ($action eq 'focus') {
				$focusTS = $vals[4];	# time when focus started
				$name = $vals[1];
				$type = $vals[2];
			}
			elsif ($action eq 'blur') {
				$totalTime += (($vals[4] - $focusTS) / 1000);
				if ($firstPostFocusTS>0) {
					++$answered;
					$inputTime += (($vals[4] - $firstPostFocusTS) / 1000);
				}
				else {
					++$skipped
				}
			}
			else {
				$firstPostFocusTS = $vals[4]	unless ($firstPostFocusTS>0);
			}
			

			# submit events are only followed by click events, not blur - so use different approach to get $totalTime
			if (($vals[2] eq 'submit') && ($vals[3] eq 'click')) {
				$displayTime = ($vals[5] / 1000);		# total time the screen is viewed before submit is clicked
				$clientSendTS = $vals[4];	# client side timestamp of when sent response back to server
				$totalTime += ($clientSendTS - $focusTS) / 1000;
			}			
			
			# singleton text entry boxes can be submitted by pressing enter - so "next" button never touched.
			# for now, keep as is - will record 0 response time for such entries, which indicates that "enter" key was pressed
			if ($vals[3] eq 'received_response') {
			}			

			
			$lastTS = $vals[4];
			
			&storeInfo;
			
			#navigation time - sum(blur-focus) + sum(click-focus) on submit buttons?
			#per question info:
			# total = (blur - focus) for a given question
			# focus follows load, blur, mouseup
			# within a question, count how many change, click, keypress events?  Also count how many focus & blur (in case revist on the screen)
			# track the order in which the questions were answered?
			# _REFUSED, etc. buttons
			
			# also make sure to detect end of file, and new ** - in case stopped without receiving response
			
			# store $actionType for each variable too - so can track time vs. type
			
		}
		&printVarInfo;	# print last varInfo when end of file reached

	}
}
close(PERVAR);
close(PERSCREEN);

sub printVarInfo {
	# then have moved onto a next display block - collate data
	# check if same clock being used by server and client ($networkSendTime <= $loadTime without being < 0)
	$networkDelay = $turnaroundTime - $displayTime;
	$networkSendTime = ($clientReceiveTS - $serverSendTS) / 1000;
	$networkReceiveTime = ($serverReceiveTS - $clientSendTS) / 1000;
	
	if ($displayCount > 0 && $loadTime != -1) {
		# if ($loadTime == -1);	# FIXME means that server didn't receive the response - so a crash or planned suspension - how to indicate it?
		
		my @k = keys(%vars);
		my $num = ($#k + 1);
		my $count = 0;
		
		# print per-question info
		
		foreach (sort keys(%vars)) {
			++$count;
			my %vi = %{ $vars{$_} };
			my $name = $vi{'name'};
			my $sched = $sched_nodes{$name};
			my $c8name = $sched->{'c8name'};
			my $type = $vi{'type'};
			my ($alen, $qlen, $atype, $tlen);
			my ($qTimevsT, $iTimevsA);
			
			# set reverved words -- FIXME -- Dialogix should prevent them from being used within instrument
			if ($type eq 'submit') {
				$c8name = "_" . uc(substr($name,0,6)) . "_";
				$alen = $qlen = $atype = $tlen = $qTimevsT = $iTimevsA = '.';
			}
			else {
				$alen = $sched->{'alen'};
				$qlen = $sched->{'qlen'};
				$atype = $sched->{'atype'};
				$tlen = ($alen + $qlen);
				if ($tlen > 0) {
					$qTimevsT = $vi{'totalTime'} / $tlen;
				}
				else {
					$qTimevsT = '.';
				}
				if ($alen > 0) {
					$iTimevsA = $vi{'inputTime'} / $alen;
				}
				else {
					$iTimevsA = '.';
				}
			}
			
			
			print PERVAR "$huid\t$displayCount\t$num\t$count\t$c8name\t$name\t$type";
			print PERVAR "\t$vi{'totalTime'}\t$vi{'inputTime'}\t$vi{'answered'}\t$vi{'skipped'}";
			print PERVAR "\t$vi{'focus'}\t$vi{'blur'}\t$vi{'change'}\t$vi{'click'}\t$vi{'keypress'}\t$vi{'mouseup'}";
			print PERVAR "\t$atype\t$alen\t$qlen\t$tlen\t$qTimevsT\t$iTimevsA\n";
			
			# FIXME - need to print info about button presses
		}
		
		my $Tratio=0;
		my $Qratio = 0;		
		
		my $pathInfo = $huidStep2path{"$huid.$displayCount"};
		if (!defined($pathInfo) || $pathInfo =~ /^\s*$/) {
			$pathInfo = ".\t.\t.\t.\t.\t.\t.\t.\t.\t.";
			$Tratio = '.';
			$Qratio = '.';
			$displayTime = '.';
			$turnaroundTime = '.';
			$networkDelay = '.';
			$serverTime = '.';
			$loadTime = '.';
		}
		else {
			my @pvals = split(/\t/,$pathInfo);
			
			# Group When Qlen Alen Tlen NumQs Title Version:  keyed on "huid.dispCnt"
			if ($displayTime < 0) {
				$displayTime = '.';
				$Qratio = '.';
				$Tratio = '.';
			}
			else {
				if ($pvals[2] > 0) {
					$Qratio = $displayTime / $pvals[2];
				}
				if ($pvals[4] > 0) {
					$Tratio = $displayTime / $pvals[4];
				}
			}
			
			# fix bad subtractions
			if ($turnaroundTime < $displayTime || $turnaroundTime < 0) {
				# this is an error -- why is it happening?
				$turnaroundTime = '.';
				$networkDelay = '.';
			}
			elsif ($networkDelay > $turnaroundTime || $networkDelay < 0) {
				# why is this happening?
				$networkDelay = '.';
			}
			
			if ($loadTime < 0) {
				$loadTime = '.';
			}
			if ($serverTime < 0) {
				$serverTime = '.';
			}
		}
		
		# print per-screen info
		# "UniqueID\tdispCnt\tGroup\tWhen\tQlen\tAlen\tTlen\tNumQs\ttDurSec\ttTimevsQ\ttTimevsT\tTitle\tVersion\tservSec\tloadSec\tdispSec\tturnSec\tntwkSec\tdTimevsQ\tdTimevsT\n";
		
		print PERSCREEN "$huid\t$displayCount\t$pathInfo\t$serverTime\t$loadTime\t$displayTime\t$turnaroundTime\t$networkDelay\t$Qratio\t$Tratio\n";
		# FIXME - need to print total navigation time (blur to next event?)
	}
	
	&resetVars;
}

sub resetVars {
	$lastLoadTS = $loadTS	unless ($loadTS == -1);
	%vars = ();
	undef %varInfo;
	$varName = '';	# null so that first comparison to $vals[1] is false	
	($networkDelay, $turnaroundTime, $displayTime, $networkSendTime, $loadTime, $clientReceiveTS, $serverSendTS, $serverTime) = (-1,-1,-1,-1,-1,-1,-1);
	($networkReceiveTime, $serverReceiveTS, $clientSendTS, $displayCount, $firstPostFocusTS, $focusTS) = (-1,-1,-1,-1,-1,-1);
	($lastTS, $loadTS) = (-1, -1);
}

sub retrieveInfo {
	my $temp = $vars{$varName};
	if (defined $temp) {
		my %vi = %$temp;
		$name = $vi{'name'};
		$type = $vi{'type'};
		$focus = $vi{'focus'};
		$blur = $vi{'blur'};
		$change = $vi{'change'};
		$click = $vi{'click'};
		$keypress = $vi{'keypress'};
		$mouseup = $vi{'mouseup'};
		$totalTime = $vi{'totalTime'};
		$inputTime = $vi{'inputTime'};
		$answered = $vi{'answered'};
		$skipped = $vi{'skipped'};
	}
	else {
		($name, $type, $focus, $blur, $change, $click, $keypress, $mouseup, $totalTime, $inputTime, $answered, $skipped) = 
		('', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}
}

sub storeInfo {
	$vars{$varName} = {
		name=>$name,		# the variable name
		type=>$type,		# type of event - can be skipped if merge with schedule file
		focus=>$focus,		# count of focus events
		blur=>$blur,		# count of blur events
		change=>$change,		# count of change events
		click=>$click,		# count of click events
		keypress=>$keypress,	# count of keypress events
		mouseup=>$mouseup,		# count of mouseup events
		totalTime=>$totalTime,	# sum of (blur-focus)
		inputTime=>$inputTime,	# sum of (blur - <1st event after focus>)
		answered=>$answered,	# count of times the question was answered (e.g. via click, change, or keypress events)
		skipped=>$skipped,		# count of times the question was skipped (e.g. user tabbed past the question without changing the answer)
	}
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

sub fixDate {
	my $arg = shift;
	
	my @timeArray = localtime(int($arg/1000));
	my $ans = sprintf "%02d/%02d/%04d", ($timeArray[4]+1), $timeArray[3], ($timeArray[5] + 1900);
	return $ans;
}	

sub fixTime {
	my $arg = shift;
	
	my @timeArray = localtime(int($arg/1000));
	my $ans = sprintf "%02d:%02d:%02d", $timeArray[2], $timeArray[1], $timeArray[0];
	return $ans;
}	

sub timeDiff {
	return '00:00:00' if ($displayCount == 1);
	
	my $diff = ($loadTS - $lastLoadTS) / 1000;
	my $sec = $diff;
	++$sec if ($sec - int($sec) >= .5);
	$sec %= 60;
	my $min = ($diff / 60) % 60;
	my $hour = ($diff / 3600);
	
	return sprintf "%02d:%02d:%02d", $hour, $min, $sec;
}

sub calc_huid {
	use File::Basename;
	my $base = basename(shift,"\.dat.*");
	$base =~ s/\.dat(\.evt)?$//;
	return $base;
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
