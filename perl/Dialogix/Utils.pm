# Module to load a list of variables from ASCII file in format VAR=VAL

package Dialogix::Utils;

use strict;
use Digest::MD5 qw(md5_hex);

BEGIN {
    use Exporter   ();
    use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    
    @ISA = qw(Exporter);

    # set the version for version checking
    $VERSION     = 2.00;

    @EXPORT      = qw(readPrefs,whichInstrument,readDialogixPrefs,mychdir);
    %EXPORT_TAGS = ( FIELDS => [ @EXPORT_OK, @EXPORT ] );

    # your exported package globals go here,
    # as well as any optionally exported functions
    @EXPORT_OK   = qw();
}
use vars @EXPORT_OK;

sub readPrefs(\%$) {
	my $Vars = shift;
	my $filename = shift;
	
	open (IN, "<$filename") or die "unable to open $filename to read runtime parameters";
	my @lines = (<IN>);
	close (IN);
	
	my $linenum=0;
	my @errs=();
	foreach my $line (@lines) {
		chomp($line);
		++$linenum;
		#expects format name=value
		if ($line =~ /^(.*?)\s*\#/) {
			$line = $1;	# allow comments
		}		
		next if ($line =~ /^\s*$/);	# allow blank lines

		if ($line =~ /^\s*(.+?)\s*=\s*(.+?)\s*$/) {
			my $var = $1;
			my $val = $2;
			if (defined($Vars->{$var})) {
				$Vars->{$var} = $val;
#				print "\tsetting $var=\"$Vars->{$var}\"\n";			
			}
			else {
				push @errs, "undefined var \"$var\" in [$filename:$linenum].";
			}
		}
		else {
			push @errs, "expected syntax VARNAME=VALUE [$filename:$linenum].  Got\n\t$line";
		}
	}
	if ($#errs > 0) {
		foreach (@errs) {
			print "ERR: $_\n";
		}
		die;
	}
	return $Vars;
}

sub whichInstrument($) {
	# Need to identify interviews not only by name, but also by title and version #s -- otherwise same name might be re-used
	# Reads a data or instrument file and returns the following as an array:
	#	(1) filename -- the name of the file containing the instrument, without the path descriptors
	#	(2) uniquename -- which contains the title, and version information of the instrument
	#	(3) timestamp -- when the file was created
	#	(4) # variables
	#	(5) MD5 Hash of ordered variable names
	#
	my $UNKNOWN_INST = '_unknown_';
	my $datfile = shift;
	unless (open (IN, "<$datfile")) {
		print "unable to open $datfile\n";
		return $UNKNOWN_INST;
	}
	print "read data from $datfile\n";
	my $count = 0;
	my $filename = '';
	my ($title, $version_major, $version_minor);
	my $triceps_major = 0;
	my $triceps_minor = 0;
	my $type = 'DATA';	# if unlabeled, assume that it is data
	my $timestamp = 0;
	my $numvars = 0;
	my $varlist = '';
	while (<IN>) {
		++$count;
#		last if ($count > 50);	# don't go beyond reasonable header section length
		my @vals = split(/\t/);
		if ($vals[0] eq 'RESERVED') {
			if ($vals[1] eq '__TRICEPS_FILE_TYPE__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$type = $1;
				}					
				$filename = $datfile;
			}					
			elsif ($vals[1] eq '__SCHEDULE_SOURCE__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$filename = $1;
				}				
			}
			elsif ($vals[1] eq '__START_TIME__' && $timestamp==0) {
				# only set timestamp once
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$timestamp = $1;
				}				
			}
			elsif ($vals[1] eq '__TITLE__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$title = $1;
				}				
			}
			elsif ($vals[1] eq '__SCHED_VERSION_MAJOR__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$version_major = $1;
				}
			}
			elsif ($vals[1] eq '__SCHED_VERSION_MINOR__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$version_minor = $1;
				}
			}
			elsif ($vals[1] eq '__TRICEPS_VERSION_MAJOR__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$triceps_major = $1;
				}				
			}
			elsif ($vals[1] eq '__TRICEPS_VERSION_MINOR__') {
				if ($vals[2] =~ /^\s*(.*)\s*$/) {
					$triceps_minor = $1;
				}		
			}
			elsif ($vals[1] eq '__CURRENT_LANGUAGE__') {
				last;	# break out of while loop
			}
		}
		else {
			# this is a variable declaration
			if ($vals[5] eq '*UNASKED*') {
				++$numvars;
				$varlist .= '$vals[1]';
			}
		}
	}
	close (IN);
	
	# Calculate MD5 hash of $varlist;
	my $varhash = md5_hex($varlist);
	
	my	$triceps_version = "$triceps_major.$triceps_minor";
	$triceps_version =~ s/\.\././g;	# remove adjacent periods
	
	my $when = &fixTime($triceps_version,$timestamp);
	$when =~ s/[\/:\s]/_/g;
	
	if ($filename =~ /^.+[\\\/](.+)(\.(jar|txt))$/) {
		$filename = $1;
	}
	else {
		$filename = '';
	}
	
	if (($filename =~ /^\s*$/) || ($title =~ /^\s*$/)) {
		return ($UNKNOWN_INST,$UNKNOWN_INST,$timestamp,$when);
	}
	else {
#		my $name = "$title-v$version_major.$version_minor-($filename)";
		my $name = "${filename}_v$version_major.${version_minor}_n${numvars}_$varhash";
		
		$name =~ s/\.\././g;
		$name =~ s/[\\\/:\*\?\"<>\|\s]/_/g;	# remove spaces and characters disallowed in Windows folder names
		return ($filename,$name,$timestamp,$when);
	}
}

sub readDialogixPrefs($) {
	#
	# study specific variables
	#
	my $conf_file = shift;
	
	my $Defaults = {
		JAR =>  '/jdk1.3/bin/jar',	# path to jar program (will be different on Unix)
		JAR_FILES => '../jars/*.jar',	# path to jar files (e.g. if on a server)
		RESULTS_DIR => '../analysis',	# path to where analyses should be put
		UNJAR_DIR => '../unjar',			# path where unjared files should be put
		UNFINISHED_DIR => '../working',	# path where incomplete files are stored
		INSTRUMENT_DIR => '../instrument',	# path where source schedule / instrument stored
		DAT_FILES => '../unjar/*.dat ../working/*',
		EVT_FILES => '../unjar/*.evt ../working/*.evt',
		PERL_SCRIPTS_PATH => '../perl',	# path to perl scripts - use '*' if in same directory as files
		
		UNIQUE_ID => '*',	#unique identifier
		modularizeByPrefix => '*',
		discardVarsMatchingPattern => '*',
		NA => 99999,		# values to substitute for reserved words ('*' means do not substitute)
		REFUSED => 55555,
		UNKNOWN => 33333,
		HUH => 22222,
		INVALID => 11111,
		UNASKED => 44444,
		INSTRUMENT => '',	# name of the instrument file (without .txt extensions)
		SORTBY => 'sortby_variable_name',	# 'sortby_order_asked'
		VARNAME_FROM_COLUMN => 1,	# use '0' for concept, '1' for internalName, '2' for externalName
		
		VARMAP_INFO_FILE => 'varMapInfo',
		
		sched2sas => 0,					
		unjarall => 0,				
		moveWorkingFiles => 0,		
		removeOldAnalysisFiles => 0,
		update_dat => 0,			
		dat2sas => 0,				
		evt2sas => 0,				
		# cleanup               
		removeEvtFiles => 0,		
		removeErrFiles => 0,		
		removeDatFiles => 0,	
		# COPY => 'cp -fp',	
		COPY => 'copy',
	};
	
	my $Prefs = &readPrefs($Defaults,$conf_file);

	# create composite variables	
	$Prefs->{DAT2SAS} = "$Prefs->{PERL_SCRIPTS_PATH}/dat2sas.pl";
	$Prefs->{EVT2SAS} = "$Prefs->{PERL_SCRIPTS_PATH}/evt2sas.pl";
	$Prefs->{UPDATE_DAT} = "$Prefs->{PERL_SCRIPTS_PATH}/update_dat.pl";
	$Prefs->{SCHED2SAS} = "$Prefs->{PERL_SCRIPTS_PATH}/sched2sas.pl";
	$Prefs->{INSTRUMENT_FILE} = "$Prefs->{INSTRUMENT_DIR}/$Prefs->{INSTRUMENT}.txt";	
	
	return ($Prefs);
}

sub mychdir($) {
	my $path = shift;
	chdir($path) or die "unable to chdir($path)";
}

sub fixTime($$) {
	my $triceps_version = shift;
	my $arg = shift;
	if ($triceps_version >= 2.5) {
		return convertTime($arg);
	}
	elsif ($arg =~ /^(\d+?)\.(\d+?)\.(\d+?)\.\.(\d+?)\.(\d+?)\.(\d+?)$/) {
		# e.g. 2000.10.26..02.20.48
		my $ans = sprintf("%04d-%02d-%02d %02d:%02d", $1, $2, $3, $4, $5);
		return $ans;
	}
	else {
		return 'unknown';
	}
}

sub convertTime($) {
	my $arg = shift;
	$arg = localtime(int($arg/1000));
	if ($arg =~ /(\w+?)\s+(\w+?)\s+(\d+?)\s+(\d+?):(\d+?):(\d+?)\s+(\d\d\d\d)/) {
		#Wed Jun 06 14:18:33 2001
		my $ans = sprintf("%04d-%02d-%02d %02d:%02d", $7, &month($2), $3, $4, $5);
		return $ans;
	}
}

sub month($) {
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

1;	# module must return a true value
