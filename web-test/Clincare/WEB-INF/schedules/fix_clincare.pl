#

while (<>) {
	unless (/SCORE\t/i) {
		print $_;
		next;
	}
	chomp;
	my @vars = split(/\t/);
	my $eqn = $vars[6];
	if ($eqn =~ /^\s*\((.*)\)\s*$/) {
		my $eqn2 = $1;
		$eqn2 =~ s/ //g;
		my @toks = split(/\+/,$eqn2);
		my @newtoks = ();
		foreach (@toks) {
			push @newtoks, "(($_)?$_:0)";
		}
		$vars[6] = "(" . join(' + ',@newtoks) . ")";
		print join("\t",@vars), "\n";
	}
}
