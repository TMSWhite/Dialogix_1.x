#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 
# perl script to translate .dat files from old to new format
# usage - takes lists of globs, translates all of them, overwriting original files
# 
# Several types of changes have and can occur:
#	(1) Triceps changes - data and event files have changed three times
#		(a) pre __VERSION__:  
#			no event files
#			datafile was same as schedule file
#		(b) pre __VERSION__ 2.5: 
#			event file format used commas, not tabs, had different organization, and had different file extension
#			datafile had different column order and different timestamp encoding
#		(c) since __VERSION__ 2.5
#			current event file format
#			current data file format
#	(2) Schedule changes
#		(a) the name or location of the schedule file might change
#		(b) variable names within the schedule file might change (this should avoided if at all possible!)
#
# What this perl script does (for all files in the directory)
#	(1) Triceps changes
#		(a) reads the version number to determine which type of Triceps data files these are
#		(b) brings the column order, timestamp representation, and event filenames up to date, regardless of format
#		(c) keeps the version number tag the same - should this be altered.
#	(2) Schedule changes
#		(a) reads from "varMapInfo.txt" - a tab-delimited file with one study per line, using the following format:
#				scheduleSearchString	newScheduleLocation	varMapFileLocation	appendFile	copyToDir	
#			where
#				scheduleSearchString = a string uniquely identifying an old schedule from __SCHEDULE_SOURCE__
#					e.g. 'BYS-Adult' or 'BYS-Adult_10_14'
#				newScheduleLocation = the location of the new schedule file
#					e.g. '/usr/local/triceps/webapps/BYS/WEB-INF/schedule/BYS-Adult.jar'
#				varMapFileLocation = the location of the file that contains the mappings of old to new variable names
#					e.g. '/cvs/triceps/src/BYS-Adult.varmap'
#				appendFile = a file of Triceps data lines that should be appended e.g. to set flags indicating review mode and the new starting step
#					e.g. '.' - to indicate that no file should be appended
#					e.g. '/cvs/triceps/src/BYS-Adult-review.append'
#				copyToDir = the location that the modified files should be copied to
#					e.g. '/usr/local/triceps/webapps/BYS/WEB-INF/working'
#					e.g. '.' - to indicate that the files should not be copied.
#		(b) reads from varMapFileLocation, a tab-delimited file with one variable per line, using the following format
#				oldName	newName
#			where
#				oldName = the old variable name - can also leave this blank to deal with versions of Triceps that did not require internalName\
#				newName = the new name that should be used instead
#					e.g. "PDP1902	PDP19O2"	- to replace the '0' with a 'O'
#					e.g. "	_tmp0000"	- to replace blanks with _tmp0000
#	(3) Optionally append data lines to set flags, change starting step, etc.
#		(a) append the contents of appendFile to the end of the file, unless the value for appendFile is ';'
#	(4) Optionally copy files
#		(a) copy the .dat and .dat.evt files to copyToDir (if the value for copyDir is not '.')
#
# FIXME
#  (1) does this work sequentially on older files?  May be moot, since few old files exist
#

use strict;
use Time::Local;

my $varMapInfoFile = "";

#global variables
my $conversionStyle = '>2.5';
my %varMaps;
my %newFiles;
my %appendFiles;
my %copyToDirs;
my $studyType = '';
my %varMap;

&main;

sub main {
	$varMapInfoFile = shift(@ARGV);
	&loadVarMaps;
	
	foreach(@ARGV) {
		my @files = glob($_);
	
		foreach my $filename (@files) {
			my $ans = &update_dat($filename);
#			&moveToWorking($filename,$ans);
		}
	}
}

sub update_dat {
	my $filename = shift;
	my (@vars, $line);
	my $displayCount=1;
	my $triceps_major=0;
	my $triceps_minor=0;
	my $triceps_version=0;
	my $scheduleName = '';

	open (SRC,$filename)		or die("unable to read from $filename");
	my @lines = (<SRC>);	# read entire file
	close (SRC);

	
	# first assess whether this version needs modification
	foreach (@lines) {
		chomp;
		if (/^RESERVED/) {
			my @vars = split(/\t/);
			$triceps_major = $vars[2]	if ($vars[1] eq '__TRICEPS_VERSION_MAJOR__');
			$triceps_minor = $vars[2]	if ($vars[1] eq '__TRICEPS_VERSION_MINOR__');
			$scheduleName = $vars[2]	if ($vars[1] eq '__SCHEDULE_SOURCE__');
		}
		else {
			last;
		}
	}
	
	$triceps_version = "$triceps_major.$triceps_minor";
	$triceps_version =~ s/\.\././g;	# remove adjacent periods
	
	if ($triceps_version >= '2.5') {
		print "skipping file $filename -- already up to date (version $triceps_version)\n";
		$conversionStyle = '>2.5';
	}
	else {
		print "updating file $filename -- (version $triceps_version)\n";
		$conversionStyle = '2.0';
	}

	open (OUT,">$filename")		or die("unable to write to $filename");
	binmode(OUT);
	
	# change the version number so won't get confused
	if ($triceps_version < '2.5') {
		print OUT "RESERVED\t__TRICEPS_VERSION_MAJOR__\t9.9\n";
		print OUT "RESERVED\t__TRICEPS_VERSION_MINOR__\t.$triceps_version\n";
	}
		
	foreach (@lines) {
		chomp;
		$line = $_;
		if (/^RESERVED/) {
			if (/__START_TIME__/) {
				@vars = split(/\t/);
				print OUT "$vars[0]\t$vars[1]\t" . &fixTime($vars[2]) . "\n";
			}
			elsif (/__STARTING_STEP__/) {
				print OUT "$line\n";
				print OUT "RESERVED	__DISPLAY_COUNT__	$displayCount	\n";
				++$displayCount;
			}
			elsif (/__SCHEDULE_SOURCE__/) {
				# update the schedule source here, if desired
				$studyType = '';
				
				foreach my $key (keys(%newFiles)) {
					if ($scheduleName =~ /$key/) {
						$studyType = $key;
						last;
					}
				}
				
				if ($studyType) {
					my $newname = $newFiles{$studyType};
					%varMap = %{ $varMaps{$studyType} };
					print "$scheduleName -> $newname\n";
					print OUT "RESERVED	__SCHEDULE_SOURCE__	$newname\n";
				}
				else {
					%varMap = ();	# no mapping found
					print OUT "$line\n";
				}

			}
			else {
				print OUT "$line\n";
			}
		}
		elsif (/^COMMENT/) {
			print OUT "$line\n";
		}
		elsif (/^\s*$/) {
			print OUT "$line\n";
		}
		else {
			@vars = split(/\t/);
			
			if ($conversionStyle eq '>2.5') {
				print OUT "$vars[0]\t" . &fixVarName($vars[1]) . "\t$vars[2]\t$vars[3]\t$vars[4]\t" . &fixAns($vars[5]) . "\t" . &fixComment($vars[6]) . "\n";
			}
			else {
#				print OUT "$vars[0]\t" . &fixVarName($vars[1]) . "\t$vars[2]\t" . &fixTime($vars[6]) . "\t$vars[3]\t" .
#					&fixAns($vars[4]) . "\t" . &fixComment($vars[5]) . "\n";
				print OUT "\t" . &fixVarName($vars[1]) . "\t$vars[-5]\t" . &fixTime($vars[-1]) . "\t$vars[-4]\t" . &fixAns($vars[-3]) . "\t" . $vars[-2] . "\n";
			}
		}
	}
	&appendData;
	
	close(OUT);
	return 1;	# did update the file
}

sub fixTime {
	my $arg = shift;
	if ($conversionStyle eq '>2.5') {
		return $arg;
	}
	elsif ($arg =~ /^(\d+?)\.(\d+?)\.(\d+?)\.\.(\d+?)\.(\d+?)\.(\d+?)$/) {
		# e.g. 2000.10.26..02.20.48
		return timelocal($6,$5,$4,$3,$2-1,$1-1900) . "000";	# artificially add milliseconds
	}
	else {
		return -1;
	}
}

sub fixAns {
	my $arg = shift;
	if ($conversionStyle eq '>2.5') {
		return &fixComment($arg);
	}
	elsif ($arg =~ /^\*N\/A\*$/) {
		return "*NA*";
	}
	elsif ($arg =~ /^\*DONT_UNDERSTAND\*$/) {
		return "*HUH*";
	}
	else {
		return &fixComment($arg);
	}
}

sub fixComment {
	my $arg = shift;
	$arg =~ s/\+/ /g;
	$arg =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg;	# URI unescape
	return $arg;
}

sub appendData {
	my $appendFile = $appendFiles{$studyType};
	
	return unless (defined($appendFile) && $appendFile && $appendFile ne '.');
	
	print "appending file $appendFile";
	
	if (open(APPEND,$appendFile)) {
		my @lines = (<APPEND>);
		close (APPEND);
		foreach (@lines) {
			chomp;
			print OUT "$_\n";
		}
	}
	else {
		print "unable to open append file '$appendFile'\n";
	}
}

sub moveToWorking {
	my ($arg, $status) = (shift, shift);
	if ($arg =~ /^(.*?)\.dat$/) {
		$arg = $1;
	}
	my $workingDir = $copyToDirs{$studyType};
	my $command = '';
	
	return unless (defined($workingDir) && $workingDir && $workingDir ne '.');
	
	$command = "copy $arg.dat $workingDir"; print "$command\n"; system($command);
	if (-e "$arg.evt") {
		$command = "copy $arg.evt $workingDir\\$arg.dat.evt"; print "$command\n"; system($command);	# old naming system
	}
	elsif (-e "$arg.dat.evt") {
		$command = "copy $arg.dat.evt $workingDir"; print "$command\n"; system($command); # current naming system
	}
	else {
		my $newfile = "$workingDir\\$arg.dat.evt";
		open(EVT,">$newfile")	or die "unable to create $newfile";
		binmode(EVT);
		close (EVT);
	}
}


sub loadVarMaps {
	# read in variable name translations
	open (SRC,"$varMapInfoFile")	or die "unable to open $varMapInfoFile";
	my @lines = (<SRC>);
	close (SRC);
	
	foreach (@lines) {
		chomp;
		my ($teststr,$newfile,$varmapfile,$appendFile,$copyToDir) = split(/\t/);
		my %trans=();
		
		open(SRC,$varmapfile) or die "unable to open $varmapfile";
		while (<SRC>) {
			chomp;
			my @vars = split(/\t/);
			$trans{$vars[0]} = $vars[1];
		}
		close (SRC);
		
		$varMaps{$teststr} = \%trans;
		$newFiles{$teststr} = $newfile;
		$appendFiles{$teststr} = $appendFile;
		$copyToDirs{$teststr} = $copyToDir;
	}
}

sub fixVarName {
	my $arg = shift;
	
	my $trans = $varMap{$arg};
	if (defined($trans)) {
#		print "$arg->$trans\n";
		return $trans;
	}
	else {
		return $arg;
	}
}
