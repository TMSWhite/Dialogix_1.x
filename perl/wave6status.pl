#! /usr/local/bin/perl
#
# Perl program to determine the current status of the Wave6 interviews
#  (1) extract the sorted list of subjects and status (unstarted, working, completed)
#  (2) generate diffs between two most recent files
#  (3) email results to me and the person in charge of Wave6
#  (4) ?? assess the last day on which there was activity on a file?
#  - this was added to crontab to run at 3 am each day
#  01 3 * * * /home/tmw/Wave6/wave6status.pl 

use strict;

my $allstats;	# holds mapping of subject name to status
my $subject_done_step = 976;
my $infofile = "/usr/local/dialogix/webapps/Wave6/WEB-INF/loginInfoFile.txt";
#default date is yesterday
my $date0 = &getdate(time() - 2*(60*60*24));
my $date1 = &getdate(time() - (60*60*24));
my $outprefix = "/home/tmw/Wave6/status/wave6usage";
my $outfile0 = "$outprefix-$date0.txt";
my $outfile1 = "$outprefix-$date1.txt"; 
my $diffprog = "/essentials/diff.exe";
#my $diffprog = "diff";

&main;

sub main {
	&get_current_status;
	&compare_to_yesterday;
	&email_results;
}

sub get_current_status {
	# read current status info                             
	open(IN,"$infofile") or die "unable to open $infofile";
	my @lines = sort(<IN>);
	close(IN) or die "unable to close $infofile";
	
	# write needed info to proper file
	open(OUT,">$outfile1") or die "unable to open $outfile1";
	print OUT "Username\tPassword\tStatus\tReadyForClinician\tArchiveFile\tLastUsed\tLastStep\tNumScreens\tNumLogins\tNumDates\tNumIPs\tTempFilename\n";
	foreach my $line (@lines) {
		chomp($line);
		my @vars = split(/\t/,$line);
		next unless ($vars[9] eq "J728J945");
		my ($username, $password, $filename, $status, $lastused, $laststep, $lastdisp, $readyforclinician, $archived, $numlogins, $numlocs, $numdays, $fileshort) = 
			($vars[0], $vars[1], $vars[2], $vars[4], '.', '.', '.', '.', '.', 0, 0, 0, '.');
			
		if ($filename ne '.') {
			my $lastmod = (stat($filename))[9];
			$lastused = &getdatetime($lastmod);
			
			if (open (TEMP,"$filename")) {
				my @data = (<TEMP>);
				close(TEMP);
				my (%ips, %logindates);
				foreach (@data) {
					if (/^RESERVED\t__STARTING_STEP__\t(\d+)\t/) {
						$laststep = $1;
					}
					if (/^RESERVED\t__DISPLAY_COUNT__\t(\d+)\t/) {
						$lastdisp = $1;
					}
					if (/^RESERVED\t__CONNECTION_TYPE__\t.+?\t(\d+)\t/) {
						++$numlogins;
						my $logindate = &getdate($1);
						$logindates{$logindate} = $logindate;
	
					}
					if (/^RESERVED\t__IP_ADDRESS__\t(.+?)\t/) {
						$ips{$1} = $1;
					}
				}
				$numlocs = scalar(keys(%ips));
				$numdays = scalar(keys(%logindates));
				
				if ($filename =~ /\/([^\/]+\.dat)$/) {
					$fileshort = $1;
				}
			}
			my $suspenddir = "/usr/local/dialogix/webapps/Wave6/WEB-INF/archive/suspended/";
			if (-e "$suspenddir/$password.jar") {
				$archived = "$password.jar";
			}
			if ($laststep >= $subject_done_step) {
				$readyforclinician = 'yes';
			}
			
		}
		
		my $stats = { 
			username => $username,
			password => $password,
			filename => $filename,
			status => $status,
			lastused => $lastused,
			laststep => $laststep,
			lastdisp => $lastdisp,
			archived => $archived,
			readyforclinician => $readyforclinician
		};
		$allstats->{$vars[0]} = $stats;
			
	#print OUT "Username\tPassword\tStatus\tReadyForClinician\tArchiveFile\tLastUsed\tLastStep\tNumScreens\tNumLogins\tNumDates\tNumIPs\tTempFilename\n";
		print OUT "$username\t$password\t$status\t$readyforclinician\t$archived\t$lastused\t$laststep\t$lastdisp\t$numlogins\t$numdays\t$numlocs\t$fileshort\n";
	}
	close(OUT) or die "unable to close $outfile1";
}

sub compare_to_yesterday {
	return unless (-e $outfile0);
	my $command = "$diffprog -ay --width=300 --suppress-common-lines --left-column $outfile1 $outfile0 > $outfile1.diff";
	system($command);
}

sub email_results {
}

sub getdate {
	my @tm = localtime(shift);
	my $datefmt = "%04d-%02d-%02d";
	return sprintf($datefmt,(1900+$tm[5]),(1+$tm[4]),$tm[3]);
}

sub getdatetime {
	my @tm = localtime(shift);
	my $datetimefmt = "%04d/%02d/%02d %02d:%02d:%02d";
	return sprintf($datetimefmt,(1900+$tm[5]),(1+$tm[4]),$tm[3], $tm[2], $tm[1], $tm[0]);	
}
