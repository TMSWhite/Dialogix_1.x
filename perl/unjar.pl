#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 
# Perl script to automate the following:
#	(1) unjar all files in a directory
#	(2) update any old datafiles
#	(3) run dat2sas on the resulting .dat files
#	(4) optionally remove the .dat files
#
# TODO
#  (1) better documentation
#  (2) consider passing $Prefs to all associated files, rather than passing command line args

use strict;

use Dialogix::Utils;

#
# study specific variables - passed to dat2sas
#
my $Prefs;
$Prefs = {
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

};  
    
#filesystem specific variables
#   
my ($DAT2SAS, $EVT2SAS, $UPDATE_DAT, $SCHED2SAS, $INSTRUMENT_FILE);

if ($#ARGV != 0) {
	print "Usage:\nperl unjar.pl <config-file>\n";
	print "see sample.conf for an example of the config parameters\n";
	exit(0);
}
    
&main(@ARGV);

sub main {
	my $conf_file = shift;
	$Prefs = &Dialogix::Utils::readPrefs($Prefs,$conf_file);
	&initVars;
	return 0 unless &prepare;
	&doall;
}

sub initVars {
	$DAT2SAS = "$Prefs->{PERL_SCRIPTS_PATH}/dat2sas.pl";
	$EVT2SAS = "$Prefs->{PERL_SCRIPTS_PATH}/evt2sas.pl";
	$UPDATE_DAT = "$Prefs->{PERL_SCRIPTS_PATH}/update_dat.pl";
	$SCHED2SAS = "$Prefs->{PERL_SCRIPTS_PATH}/sched2sas.pl";
	$INSTRUMENT_FILE = "$Prefs->{INSTRUMENT_DIR}/$Prefs->{INSTRUMENT}.txt";	
}

sub doall {
	&removeOldAnalysisFiles if ($Prefs->{removeOldAnalysisFiles}==1);	# removes any lingering .log files (since dat2sas appends to them)
	&sched2sas if ($Prefs->{sched2sas}==1); # post-process instrument file
	&unjarall if ($Prefs->{unjarall}==1);	# uncompresses all of the .jar files in the directory
	&moveWorkingFiles if ($Prefs->{moveWorkingFiles}==1);	# move incomplete (unjarred) data files to appropriate sub directories
	&update_dat if ($Prefs->{update_dat}==1);	# converts old Triceps data format (from before version 2.5) to the new format
	&dat2sas if ($Prefs->{dat2sas}==1);		# runs dat2sas on the .dat files in the directory
	&evt2sas if ($Prefs->{evt2sas}==1);		# runs evt2sas.pl
# cleanup
	&removeEvtFiles if ($Prefs->{removeEvtFiles}==1);	# remove .evt files
	&removeErrFiles if ($Prefs->{removeErrFiles}==1);	# remove .err files
	&removeDatFiles if ($Prefs->{removeDatFiles}==1);	# removes the temporary files (.dat and .dat.evt);
}

sub prepare {
	return 0 unless checkDir($Prefs->{PERL_SCRIPTS_PATH},1);
	return 0 unless checkDir($Prefs->{INSTRUMENT_DIR},1);
	checkDir($Prefs->{RESULTS_DIR},0);
	checkDir($Prefs->{UNJAR_DIR},0);
	checkDir($Prefs->{UNFINISHED_DIR},-1);
	return 1;
}

sub checkDir {
	my $dir = shift;
	my $required = shift;
	
	unless (-d $dir) {
		if ($required > 0) {
			print "ERROR -- dir '$dir' must exist\n";
			return 0;
		}
		if ($required != -1) {
			print "creating dir '$dir'\n";
			mkdir($dir, 0777);
		}
	}
}

sub unjarall {
	my @files = glob($Prefs->{JAR_FILES});
	
	chdir($Prefs->{UNJAR_DIR});
	
	my $tmpdir = "$Prefs->{UNJAR_DIR}/../_temp_";
	checkDir($tmpdir,0);
	chdir($tmpdir);
	
	foreach (@files) {
		# unjar to temp directory; then determine which instrument belong to; then move to that new directory
		&doit("$Prefs->{JAR}  xvf \"$_\"");
		&doit("del *.err");	
		
		my @files = glob("*");
		&moveDataFiles(@files);
		foreach (@files) {
			&doit("del $_");
		}
	}
}

sub moveWorkingFiles {
	chdir($Prefs->{UNFINISHED_DIR});
	my @files = glob("*.dat *.");
	
	foreach (@files) {
		&moveDataFiles($_);
	}
}

sub moveDataFiles {
	my @files = @_;
	my $inst = &which_inst($files[0]);	# assume that they are all from the same same data prefix
	
	my $locdir;
	if ($inst =~ /^\s+$/) {
		$locdir = '_unknown_';
	}
	else {
		$locdir = $inst;
	}
	my $dstdir = "$Prefs->{UNJAR_DIR}/$locdir";
	unless (-d $dstdir) {
		mkdir($dstdir, 0777);
	}
	# convert to dos format
	$dstdir =~ s/\//\\/g;
	
	foreach (@files) {
		&doit("copy \"$_\" \"$dstdir\"");
	}
}

sub doit {
	my $cmd = shift;
	print "$cmd\n";
	system($cmd);
}

sub which_inst {
	my $datfile = shift;
	unless (open (IN, "<$datfile")) {
		print "unable to open $datfile\n";
		return '';
	}
	my @lines = (<IN>);
	close (IN);
	print "read data from $datfile\n";
	my $count = 0;
	foreach my $line (@lines) {
		++$count;
		if ($count > 40) { return ''; }	;	# don't go beyond reasonable header section length
		my @vals = split(/\t/,$line);
		if ($vals[0] eq 'RESERVED') {
			if ($vals[1] eq '__SCHEDULE_SOURCE__') {
				my $src = $vals[2];
				print $src;
				if ($src =~ /^.+[\\\/](.+)(\.(jar|txt))$/) {
					my $filename = $1;
					print " -- $filename\n";
					return $filename;
				}
				else {
					print " -- ???\n";
					return '';
				}
			}
		}
	}
}


sub removeOldAnalysisFiles {
	my @files = glob("$Prefs->{RESULTS_DIR}/*.log");
	push @files, glob("$Prefs->{RESULTS_DIR}/*.s*");

	foreach (@files) {
		unlink $_ unless (-d $_);
	}
}

sub update_dat {
	chdir($Prefs->{UNJAR_DIR});
	my $command = "perl $UPDATE_DAT $Prefs->{VARMAP_INFO_FILE} $Prefs->{DAT_FILES}";
	print "$command\n";
	&doit($command);
}

sub dat2sas {
	chdir($Prefs->{RESULTS_DIR});
	my $command = "perl $DAT2SAS $Prefs->{INSTRUMENT_DIR}/$Prefs->{INSTRUMENT} $Prefs->{UNIQUE_ID} $Prefs->{modularizeByPrefix} $Prefs->{discardVarsMatchingPattern} $Prefs->{NA} $Prefs->{REFUSED} $Prefs->{UNKNOWN} $Prefs->{HUH} $Prefs->{INVALID} $Prefs->{UNASKED} $Prefs->{DAT_FILES}";
	print "$command\n";
	&doit($command);
}

sub evt2sas {
	chdir($Prefs->{RESULTS_DIR});
	my $command = "perl $EVT2SAS $Prefs->{INSTRUMENT_DIR}/$Prefs->{INSTRUMENT} $Prefs->{UNIQUE_ID} $Prefs->{discardVarsMatchingPattern} $Prefs->{EVT_FILES}";
	print "$command\n";
	&doit($command);
}

sub removeDatFiles {
	my @files = glob("$Prefs->{RESULTS_DIR}/*.dat");
	foreach (@files) {
		unlink $_ unless (-d $_);
	}
}

sub removeEvtFiles {
	my @files = glob("$Prefs->{RESULTS_DIR}/*.evt");
	foreach (@files) {
		unlink $_ unless (-d $_);
	}
}

sub removeErrFiles {
	my @files = glob("$Prefs->{UNJAR_DIR}/*.err");
	foreach (@files) {
		unlink $_ unless (-d $_);
	}
}

sub sched2sas {
	chdir($Prefs->{INSTRUMENT_DIR});
	my $command = "perl $SCHED2SAS $Prefs->{modularizeByPrefix} $Prefs->{discardVarsMatchingPattern} $Prefs->{RESULTS_DIR} $Prefs->{NA} $Prefs->{REFUSED} $Prefs->{UNKNOWN} $Prefs->{HUH} $Prefs->{INVALID} $Prefs->{UNASKED} $INSTRUMENT_FILE";
	print "$command\n";
	&doit($command);
}
