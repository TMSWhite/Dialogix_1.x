# perl code to convert actual Event data into inserts


my $lastdisp = -1;

while (<>) {
	chomp;
	next if (/^\s*$/);
	s/'/_/g;
	my @vals = split(/\t/);
	
	if ($vals[0] != $lastdisp) {
		if ($lastdisp >= 0) {
			print "	;\n";
		}
		$lastdisp = $vals[0];
		print "INSERT INTO pageHitEvents VALUES\n";
	}
	else {
		print ",\n";
	}
	
	for (my $i = $#vals; $i < 7; ++$i) {
		push @vals, '';
	}
	
	print "	( NULL, LAST_INSERT_ID(), '" . join("', '", @vals) . "')";
}
print ";\n";

