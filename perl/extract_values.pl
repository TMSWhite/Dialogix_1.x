# perl to get all instances of a given value out of the summary files

use strict;

my $file = "C:/data/cet-irb3/analysis/AutoMEQ-SA-v3.0-(AutoMEQ-SA-irb)/__MAIN__-summary.tsv";
my $findme = "FEEDB012";

open (IN, "<$file") or die "unable to open $file";

my $header = <IN>;
#chomp ($header);
#my @varnames = split(/\t/,$header);
my $idx = 12;

#foreach my $val (@varnames) {
#	++$idx;
#	last if ($val eq $findme);
#}

my @timedvals;
my $lineno = 0;
while (<IN>) {
	chomp;
	++$lineno;
	my @vars = split(/\t/);
	my $timestamp = $vars[0];
	if ($timestamp =~ /^(.*?\))/) {
		$timestamp = $1;
	}
	$idx = ($lineno < 36) ? 12 : 11;
	$idx = 11;
	my $comment = $vars[$idx];
	push @timedvals, "$timestamp\t$comment";
}

close (IN);

open (OUT, ">out.txt");
print OUT "Timestamp	Feedback\n";
foreach my $val (sort(@timedvals)) {
	print OUT "$val\n";
}
close (OUT);

open (OUT2, ">out.htm");
print OUT2 "<html><body><table border='1'>\n";
foreach my $val (sort(@timedvals)) {
	my @vals = split(/\t/,$val);
	next if ($vals[1] eq 'Type comments here.');
	print OUT2 "<tr><td>$vals[0]</td><td>$vals[1]</td></tr>\n";
}
print OUT2 "</table></body></html>\n";
close (OUT2);
