# process Triceps log files
# (1) report => webalize.log.err.ips
#		(a) list of unique IPs (optional name), and number of hits from each
#		(b) list of unique browsers, and hits from each
#		(c) list of unique sessions, associated IP, resolved_name, start_time/date, stop_time/date, browser, page, steps, and raw_step-path
#		(d) for each session
#				IP
#				name
#				start time
#				stop time
#				duration
#				browser
#				instrument
#				num_Steps
#				path
# (2) report => convert to modified Common Log Format for processing by webalizer and others
#
# Triceps format is
#	command time session ip useragent accept_lang ??? instrument(step)
#   #@#(next) [Thu Jan 03 16:13:26 EST 2002] grfp3uw0c1 205.185.3.25 "Mozilla/4.7 [en] (Win95; U)" "en" "iso-8859-1,*,utf-8" CET/AutoMEQ-SA.jar(16)
#
# Common Log Format is
#
#	%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"
#	ip client userid time request status_code bytes_returned referrer useragent
#	127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
#
#	Transformation for Dialogix will be:
#		ip => ip
#		client => -
#		userid => session
#		time => time
#		request => instrument
#		status code => 200
#		bytes_returned => step
#		referrer = command
#		useragend => useragent
#
# TODO -- read a config file for $src, $dst, $JAR, list of IP addressed to exclude, list of instrument files to include
# 

use strict;
#use Net::hostent;
use Socket;
use HTTP::Date;
use Archive::Tar;

# things to do:
# (1) was session closed?  copyFile => success
# (2) false starts

my (%ips, %browsers, %sessions, %ip2host, @dates);

my $src_dir = "/data/cet-irb/logs";
my $dst_dir = "/data/cet-irb/webalizer";
my $JAR =  "/jdk1.3/bin/jar";	# path to jar program (will be different on Unix)

&main;

sub main {
	&rename_log_file;
	&delete_old_files;
	
	open (LOG,">$dst_dir/webalize.log") or die "unable to open $dst_dir/webalize.log";
	open (CLF,">$dst_dir/webalize.clf") or die "unable to open $dst_dir/webalize.clf";
	&readLogs;
#	&resolveHosts;
	&writeTimes;
	&writeReport;
	close (LOG);
	close (CLF);
	
	&jar_results;
}

sub delete_old_files {
	my @files = (glob("$dst_dir/*.html"), glob("$dst_dir/*.png"), glob("$dst_dir/*.tgz"), glob("$dst_dir/webalize.*"));
	foreach (@files) {
		unlink $_ unless (-d $_);
	}
}

sub readLogs {
	# triceps files
	my @files = glob("$src_dir/triceps.*");
	my @sorted_files = sort { lc($a) cmp lc($b) } @files;
	
	# dialogix files (which are newer)
	@files = glob("$src_dir/dialogix.*");
	push(@sorted_files, sort { lc($a) cmp lc($b) } @files);
	
	foreach (@sorted_files) {
		readLog($_);
	}
}


sub jar_results {
	my $command = "$JAR cvf $dst_dir/webalize.jar $dst_dir/webalize.clf";
	system($command);
}

sub readLog {
	my $file = shift;
	open (SRC,"<$file")	or die "unable to open $file";
	
	while (<SRC>) {
		chomp;
		my %info = %{ &readLine($_) };
		
		my ($sessionID, $start, $steps, $cstart);
				
		if ($info{'valid'} != 0) {
			print LOG "OK($info{'valid'}) => $info{'line'}\n";
		}
		else {
			print LOG "bad => $info{'line'}\n";
		}
		
		if ($info{'valid'}) {
			next if (&skipThis($info{'ip'},$info{'schedule'}));
			
			# write Common Log format file
			print CLF "$info{'ip'} - $info{'sessionID'} [" . 
				&clf_time($info{'date'}) . 
				"] \"GET dialogix.cgi?instrument=/$info{'schedule'}?step=$info{'step'}&command=$info{'command'} HTTP/1.0\" 200 1024 \"$info{'command'}\" \"$info{'browser'}\"\n";

			my $ctime = $info{'date'};
			$ctime =~ s/E[DS]T //;
			$ctime = str2time($ctime);
			
			push @dates, { date=>$info{'date'}, ctime=>$ctime };
			
			++$ips{$info{'ip'}};
			++$browsers{$info{'browser'}};
			
			if ($info{'sessionID'}) {
				$sessionID = $info{'sessionID'};
				
				if (exists $sessions{$sessionID}) {
					my %session = %{ $sessions{$sessionID} };
					$start = $session{'start'};
					$cstart = $session{'cstart'};
					$steps = $session{'steps'};
				}
				
				$sessions{$sessionID} = {
					id => $sessionID,
					start => ($start ? $start : $info{'date'}),
					cstart => ($cstart ? $cstart : $ctime),
					stop => $info{'date'},
					cstop => $ctime,
					ip => $info{'ip'},
					browser => $info{'browser'},
					schedule => $info{'schedule'},
					steps => ($steps . " $info{'step'}"),
				};
			}
		}
	}
	close (SRC);
}

sub skipThis {
	my $ip = shift;
	my $schedule = shift;
	return 1 if ($ip eq '156.111.139.159');	# mine
	return 1 if ($ip eq '156.111.139.242');	# Terman's
	return 1 if ($ip eq '156.111.178.193');	# piwhite
	return 1 if ($ip eq '156.111.80.79');	# new piwhite
	return 1 if ($ip eq '156.111.80.78');	# new mine
	return 1 if ($ip eq '198.190.230.66');	# OMH
	return 1 if ($schedule ne 'CET/AutoMEQ-SA.jar');	# only look at MU for now
	return 0;
}


sub readLine {
	my $arg = shift;
	my $ctime;
	
	if ($arg =~ /\((.+?)\)\s\[(.+?)\]\s(.+?)\s(.+?)\s"(.+?)\"\s\".+?\"\s\".+?\"\s(.+?)(\((\d+?)\))?\s((OK)|(FINISHED)|(UNSUPPORTED BROWSER)|(EXPIRED SESSION))$/o) {
		# syntax from Feb 18, 2002 -> present
		##@#(next) [Fri Aug 03 18:50:14 EDT 2001] xqa985ado1 156.111.139.159 "Mozilla/4.77 [en] (Win98; U)" "en" "iso-8859-1,*,utf-8" CET/AutoMEQ-SA.jar(10) OK
		#@#(START) [Thu Jan 03 16:07:36 EST 2002] grfp3uw0c1 205.185.3.25 "Mozilla/4.7 [en] (Win95; U)" "en" "iso-8859-1,*,utf-8" null

		return {
			valid => 5,
			line => $arg,
			command => $1,
			date => $2,
			sessionID => $3,
			ip => $4,
			browser => $5,
			schedule => $6,
			step => (defined($8) ? $8 : -1),
		};
	}	
	elsif ($arg =~ /\((.+?)\)\s\[(.+?)\]\s(.+?)\s(.+?)\s"(.+?)\"\s\".+?\"\s\".+?\"\s(.+?)(\((\d+?)\))?$/o) {
		# syntax from August 6, 2001 -> Feb 18, 2002
		##@#(next) [Fri Aug 03 18:50:14 EDT 2001] xqa985ado1 156.111.139.159 "Mozilla/4.77 [en] (Win98; U)" "en" "iso-8859-1,*,utf-8" CET/AutoMEQ-SA.jar(10)
		#@#(START) [Thu Jan 03 16:07:36 EST 2002] grfp3uw0c1 205.185.3.25 "Mozilla/4.7 [en] (Win95; U)" "en" "iso-8859-1,*,utf-8" null

		return {
			valid => 4,
			line => $arg,
			command => $1,
			date => $2,
			sessionID => $3,
			ip => $4,
			browser => $5,
			schedule => $6,
			step => (defined($8) ? $8 : -1),
		};
	}	
	elsif ($arg =~ /\((.+?)\)\s\[(.+?)\]\s(.+?)\s(.+?)\s\".+?\"\s\"(.+?)\"\s\".+?\"\s\".+?\"\s.+?(\/([a-zA-Z0-9._-]+)\/WEB-INF\/schedules\/([a-zA-Z0-9._-]+))?(\((\d+?)\))?$/o) {
		# syntax from June 14-August 6, 2001
		##@#(next) [Fri Aug 03 17:59:43EDT 2001] mjyddd8nw1 198.104.102.100 "POST /CET/servlet/Triceps" "Mozilla/4.7 (Macintosh; I; PPC)" "en" "iso-8859-1,*,utf-8" /usr/local/triceps/webapps/CET/WEB-INF/schedules/AutoMEQ-SA.jar(50)
		#@#(START) [Thu Jun 14 01:03:17 EDT 2001] 4z5vosb0d1 172.137.106.211 "POST /CIC/servlet/Triceps" "Mozilla/4.77 [en] (Win98; U)" "en" "iso-8859-1,*,utf-8"

		return {
			valid => 3,
			line => $arg,
			command => $1,
			date => $2,
			sessionID => $3,
			ip => $4,
			browser => $5,
			schedule => (defined($7) ? "$7/$8" : "null"),	# "$6/$7",
			step => (defined($10) ? $10 : -1),	# $8,
		};
	}
	elsif ($arg =~ /\((.+?)\)\sTricepsEngine\.(.+?)\s(.+?)\s-\s\[(.+?)\]\s\".+?\"\s\"(.+?)\"\s\".+?\"\s\".+?\"\s.+?(\/([a-zA-Z0-9._-]+)\/WEB-INF\/schedules\/([a-zA-Z0-9._-]+))?(\((\d+?)\))?$/o) {
		# syntax for June 6th - June 13th, 2001
		##@#(next) TricepsEngine.ymjvg7erf1 156.111.139.159 - [Wed Jun 06 14:18:33 EDT 2001] "POST /CET/servlet/Triceps" "Mozilla/4.77 [en] (Win98; U)" "en" "iso-8859-1,*,utf-8" /usr/local/triceps/webapps/CET/WEB-INF/schedules/AutoMEQ-SA.jar(0)
		#@#(START) TricepsEngine.8k8elz6op1 158.96.77.6 - [Mon Jun 11 18:05:51 EDT 2001] "POST /Demos/servlet/Triceps" "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0)" "en-us" "null"
		return {
			valid => 2,
			line => $arg,
			command => $1,
			sessionID => $2,
			ip => $3,
			date => $4,
			browser => $5,
			schedule => (defined($7) ? "$7/$8" : "null"),	# "$6/$7",
			step => (defined($10) ? $10 : -1),	#$8,
		};		
	}
	elsif ($arg =~ /\((.+?)\)\s(\d+\.\d+\.\d+\.\d+)\s-\s\[(.+?)\]\s\".*?\"\s\"(.*)\"/o) {
		# syntax before June 6th, 2001
		##@#(next) 156.111.139.159 - [Wed Feb 14 10:31:26 EST 2001] "POST /Tutorials/servlet/Triceps" "Mozilla/4.76 [en] (Win98; U)" "en" "iso-8859-1,*,utf-8"
		#@#(START) 156.111.139.159 - [Wed Feb 14 10:37:28 EST 2001] "POST /Tutorials/servlet/Triceps" "Mozilla/4.76 [en] (Win98; U)" "en" "iso-8859-1,*,utf-8"
		return {
			valid => 1,
			line => $arg,
			command => $1,
			ip => $2,
			date => $3,
			browser => $4,
			step => 'unknown',
			sessionID => 'unknown',
			schedule => 'unknown',
		};
	}

	
	else {
		return { 
			valid => 0, 
			line => $arg,
		};
	}
}

sub convertTime {
	my $arg = shift;
	chomp;
	if ($arg =~ /(\w+?)\s+(\w+?)\s+(\d+?)\s+(\d+?):(\d+?):(\d+?)\s+(\w+?)\s+(\d\d\d\d)/) {
		#Wed Jun 06 14:18:33 EDT 2001
		return &month($2) . "/$3/$8 $4:$5:$6";
	}
	
}


sub month {
	$_ = shift;
	return '01' if (/Jan/i);
	return '02' if (/Feb/i);
	return '03' if (/Mar/i);
	return '04' if (/Apr/i);
	return '05' if (/May/i);
	return '06' if (/Jun/i);
	return '07' if (/Jul/i);
	return '08' if (/Aug/i);
	return '09' if (/Sep/i);
	return '10' if (/Oct/i);
	return '11' if (/Nov/i);
	return '12' if (/Dec/i);
	return '00';
}

sub writeTimes {
	open (OUT, ">$dst_dir/webalize.log.err.times") or die "unable to open $dst_dir/webalize.log.err.times";
	
	foreach my $date (@dates) {
		my %s = %{ $date };
		print OUT "$s{'date'}\t$s{'ctime'}\t". &convertTime($s{'date'}) . "\n";
	}
	close (OUT);
}

sub resolveHosts {
	foreach my $ip (sort keys(%ips)) {
		my $host = gethostbyaddr(inet_aton($ip),AF_INET);
		$ip2host{$ip} = $host;
	}	
}

sub writeReport {
	open (OUT,">$dst_dir/webalize.log.err.ips")	or die "unable to open $dst_dir/webalize.log.err.ips";
	
	foreach my $ip (sort keys(%ips)) {
		print OUT "$ip\t" . $ip2host{$ip} . "\t$ips{$ip}\n";
	}
	print OUT "\n";
		
	foreach my $type (sort keys(%browsers)) {
		print OUT "$type\t$browsers{$type}\n";
	}
	print OUT "\n";
	
	foreach my $sess (sort keys(%sessions)) {
		my %s = %{ $sessions{$sess} };
		my $duration = $s{'cstop'} - $s{'cstart'};
		my @a_steps = split(/ /,$s{'steps'});
		my $steps = $#a_steps;
		print OUT "$sess\t$s{'ip'}\t" . $ip2host{$s{'ip'}} . "\t" . &convertTime($s{'start'}) . "\t" . &convertTime($s{'stop'}) . "\t$duration\t$s{'browser'}\t$s{'schedule'}\t$steps\t$s{'steps'}\n";
	}
	print OUT "\n";
	
	foreach my $sess (sort keys(%sessions)) {
		my %s = %{ $sessions{$sess} };
		my $duration = $s{'cstop'} - $s{'cstart'};
		my @a_steps = split(/ /,$s{'steps'});
		my $steps = $#a_steps;		
		print OUT "$sess\n\t$s{'ip'}\n\t" . $ip2host{$s{'ip'}} . "\n\t$s{'start'}\n\t$s{'stop'}\n\t$s{'cstart'}\n\t$s{'cstop'}\n\t$duration\n\t$s{'browser'}\n\t$s{'schedule'}\n\t\t$steps\n\t\t$s{'steps'}\n";
	}
	print OUT "\n";
		
	close OUT;
}

sub clf_time {
	my $arg = shift;
	chomp;
	if ($arg =~ /(\w+?)\s+(\w+?)\s+(\d+?)\s+(\d+?):(\d+?):(\d+?)\s+(\w+?)\s+(\d\d\d\d)/) {
		#input => Wed Jun 06 14:18:33 EDT 2001
		#output => 10/Oct/2000:13:55:36 -0700
		return "$3/$2/$8:$4:$5:$6 -0000";
	}
}

sub rename_log_file {
	my $prefix = "..";
	my $logs = "$prefix/logs";
	my $logname = "Triceps.log.err";
	my $datefmt = "%04d.%02d.%02d";

	open(LOG,"<$logs/$logname");
	my $startDate = <LOG>;
	close (LOG);
	
	#default date is yesterday if can't read file
	my @tm= localtime(time() - (60*60*24));
	my $date = sprintf($datefmt,(1900+$tm[5]),(1+$tm[4]),$tm[3]);
	
	# otherwise, have re-name date be the day when the log file was started
	if ($startDate =~ /started on \w{3} (\w{3}) (\d+) \d+:\d+:\d+ \w+ (\d{4})/) {
	#	**DEV version of Dialogix Interviewing System version 2.9.4 Log file started on Thu Jan 17 16:36:06 EST 2002
		$date = sprintf($datefmt,$3,&month($1),$2);
	}
	
	rename("$logs/$logname","$logs/$logname.$date") if (-e "$logs/$logname");
}
