# perl script to extract Runtime memory info from Dialogix.log.err file

my ($count, $diff, $sum) = (0, 0, 0);
my ($tot_mem, $free_mem, $last_tot_mem, $last_free_mem);

open (IN, "</usr/local/dialogix/logs/Dialogix.log.err") or die "unable to open file";
print "Index\tTot_mem\tFree_mem\tDiff\n";
while (<IN>) {
	chomp;
	if (/HTTPS? \[(.+), (.+)\]$/) {
		$tot_mem = $1;
		$free_mem = $2;
		if ($count > 0) {
			$diff = (($last_free_mem - $free_mem) + ($tot_mem - $last_tot_mem));
		}
		$sum += $diff;
		print ++$count . "\t$tot_mem\t$free_mem\t$diff\n";
		$last_tot_mem = $tot_mem;
		$last_free_mem = $free_mem;
	}
}
close (IN);
print "Sum\t$sum\tAverage\t" . int($sum / $count);
	
