# Module to load a list of variables from ASCII file in format VAR=VAL

package Dialogix::Utils;

use strict;

BEGIN {
    use Exporter   ();
    use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    
    @ISA = qw(Exporter);

    # set the version for version checking
    $VERSION     = 2.00;

    @EXPORT      = qw(readPrefs,whichInstrument);
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
	my $type = 'DATA';	# if unlabeled, assume that it is data
	my $timestamp = 0;
	while (<IN>) {
		++$count;
		last if ($count > 50);	# don't go beyond reasonable header section length
		my @vals = split(/\t/);
		if ($vals[0] eq 'RESERVED') {
			if ($vals[1] eq '__TRICEPS_FILE_TYPE__') {
				$type = $vals[2];
				$filename = $datfile;
			}					
			elsif ($vals[1] eq '__SCHEDULE_SOURCE__') {
				$filename = $vals[2];
				$timestamp = $vals[3];
			}
			elsif ($vals[1] eq '__TITLE__') {
				$title = $vals[2];
			}
			elsif ($vals[1] eq '__SCHED_VERSION_MAJOR__') {
				$version_major = $vals[2];
			}
			elsif ($vals[1] eq '__SCHED_VERSION_MINOR__') {
				$version_minor = $vals[2];
			}
		}
	}
	close (IN);
	
	if ($filename =~ /^.+[\\\/](.+)(\.(jar|txt))$/) {
		$filename = $1;
	}
	else {
		$filename = '';
	}
	
	if (($filename =~ /^\s*$/) || ($title =~ /^\s*$/)) {
		return ($UNKNOWN_INST,$UNKNOWN_INST,$timestamp);
	}
	else {
		my $name = "$title-v$version_major.$version_minor-($filename)";
		$name =~ s/\.\././g;
		$name =~ s/[\\\/:\*\?\"<>\| 	]/_/g;
		return ($filename,$name,$timestamp);
	}
}



1;	# module must return a true value
