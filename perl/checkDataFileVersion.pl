# perl script to look at versions of dialogix data files

use strict;

my $triceps_version = '';

&main(@ARGV);

sub main {
	my $dir = shift(@ARGV);
	my $out = shift(@ARGV);
	open (OUT,">$out") or die "unable to open $out";
	
	&look($dir);
	
	close (OUT);
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
		&processFile($file);
	}
}

sub processFile {
	my $file = shift;
	
	if (!open (IN, "<$file")) {
		warn "unable to open $file";
		return;
	}
	my @lines = (<IN>);
	close (IN);
	
	my $triceps_major = 0;
	my $triceps_minor = 0;
	my $schedule = '';
	my ($sched_major, $sched_minor, $title, $sched_version);
	$triceps_version='';
	my $startTime = '';
	
	foreach (@lines) {
		chomp;
		my @vals = split(/\t/);
		next if (/^\s*$/);
		next if (/^\s*COMMENT/);
		if ($vals[0] eq 'RESERVED') {
			if ($vals[1] eq '__SCHEDULE_SOURCE__') {
				if ($vals[2] =~ /^.+[\\\/](.+?)\.((txt)|(jar))$/) {
					$schedule = $1;
				}
				else {
					$schedule = $vals[2];
				}
				$startTime = $vals[3];
			}
			elsif ($vals[1] eq '__TRICEPS_VERSION_MAJOR__') {
				$triceps_major = $vals[2];
			}
			elsif ($vals[1] eq '__TRICEPS_VERSION_MINOR__') {
				$triceps_minor = $vals[2];
			}
			elsif ($vals[1] eq '__SCHED_VERSION_MAJOR__') {
				$sched_major = $vals[2];
			}
			elsif ($vals[1] eq '__SCHED_VERSION_MINOR__') {
				$sched_minor = $vals[2];
			}
			elsif ($vals[1] eq '__TITLE__') {
				$title = $vals[2];
			}
		}
		else {
			last;	# break out of look if past header section
		}
	}
	$triceps_version = "$triceps_major.$triceps_minor";
	$triceps_version =~ s/\.\././g;	# remove adjacent periods
	$sched_version = "$sched_major.$sched_minor";
	$sched_version =~ s/\.\././g; #remove adjacent periods
	
	my $when = &convertTime(&fixTime($startTime));
	
	return if ($schedule eq '');	# means that not a Triceps file
	
	my @path = split(/[\/\\]/,$file);
	my $filebase = $path[$#path];
	print OUT "$title\tv$sched_version\t$schedule\t$when\t$filebase\tTriceps v$triceps_version\n";	
}
	
sub fixTime {
	my $arg = shift;
	if ($triceps_version >= 2.5) {
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

sub convertTime {
	my $arg = shift;
	$arg = localtime(int($arg/1000));
	if ($arg =~ /(\w+?)\s+(\w+?)\s+(\d+?)\s+(\d+?):(\d+?):(\d+?)\s+(\d\d\d\d)/) {
		#Wed Jun 06 14:18:33 2001
		return &month($2) . "/$3/$7 $4:$5:$6";
	}
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

