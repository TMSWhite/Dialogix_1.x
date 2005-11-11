#! /usr/bin/perl
#
# perl script to cycle Dialogix logs when they are full
#   (1) greps file for OutOfMemory errors
# 	(1) stops Tomcat
# 	(2) changes name of $logname file with suffix of starting date of logs
# 	(3) re-starts Tomcat

use strict;

open(LOG,"</usr/local/tomcat554/webapps/logs/Dialogix.log.err") or die "unable to open Dialogix.log.err";
my @lines = (<LOG>);
close (LOG) or die "unable to close Dialogix.log.err";

my $errorflag = 0;

foreach my $line (@lines) {
	if ($line =~ /OutOfMemoryError/) {
		$errorflag = 1;
		last;
	}
}
	
if ($errorflag == 0) {
	exit;
}

# else rotate the Dialogix logs

my $prefix = "/usr/local/tomcat554";
my $java_home = `which java`;
chomp($java_home);
$java_home =~ s|^(.*)/bin/java|$1|;
my $java_home = "/opt/j2sdk1.4.2_04";
my $logs = "$prefix/webapps/logs";
my $logname = "Dialogix.log.err";
my $bin = "$prefix/bin";
my $datefmt = "%04d.%02d.%02d";

&main;

sub main {
# stop server
$ENV{'JAVA_HOME'} = $java_home;
my $val = system("$bin/shutdown.sh 1>/tmp/tomcat554_shutdown.stdout 2>/tmp/tomcat554_shutdown.stderr");	
if ($val != 0) {
	print "failed to shutdown tomcat -- err code " . ($val/256) . "\n";
	&show_err_logs;
#	return;	# could be that already stopped, so try to start it.
}
else {
	print "tomcat stopped\n";
}

open(LOG,"<$logs/$logname");
my @loglines = (<LOG>);
my $startDate = $loglines[0];
close (LOG);

#default date is yesterday if can't read file
my @tm= localtime(time() - (60*60*24));
my $date = sprintf($datefmt,(1900+$tm[5]),(1+$tm[4]),$tm[3]);

# otherwise, have re-name date be the day when the log file was started
#if ($startDate =~ /started on \w{3} (\w{3}) (\d+) \d+:\d+:\d+ \w+ (\d{4})/) {
#	**CET version of Dialogix Interviewing System version 2.9.4 Log file started on Thu Jan 17 16:36:06 EST 2002
#	$date = sprintf($datefmt,$3,&month($1),$2);
#}

# safely copy contents to new file, appending as needed.
if (-e "$logs/$logname") {
	if (-e "$logs/$logname.$date") {
		open (OUT,">>$logs/$logname.$date");
		foreach (@loglines) {
			print OUT $_;
		}
		close (OUT);
		unlink("$logs/$logname");
	}
	else {
		rename("$logs/$logname","$logs/$logname.$date");
	}
}

#wait a few seconds to ensure that Tomcat completely stopped
sleep(30);

#now check that all of the java processes are terminated
my @java_ps = qx/ps ax | grep java | grep tomcat554 | cut -d ' ' -f 1/;
foreach (@java_ps) {
	system("kill -9 $_");
}

#restart server
$val = system("$bin/startup.sh 1>/tmp/tomcat554_startup.stdout 2>/tmp/tomcat554_startup.stderr");	
if ($val != 0) {
	print "failed to restart tomcat -- err code " . ($val/256) . "\n";
	&show_err_logs;
}
else {
	print "tomcat restarted\n";
}
}

sub show_err_logs {
	open (ERR, "</tmp/rotate_tomcat554.stdout");
	while (<ERR>) { chomp; print "$_\n"; }
	close (ERR);
	open (ERR, "</tmp/rotate_tomcat554.stderr");
	while (<ERR>) { chomp; print "$_\n"; }
	close (ERR);
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

