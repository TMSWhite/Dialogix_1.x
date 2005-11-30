# Perl function to extract results from CET analysis files
# perl extract_results.pl < SLTBR-2005-analysis-sunrise-20051118-withoutAlaska.log > test.txt


use strict;

my $results;
my ($regtype, $dependent, $comparator, $source);
my ($independent, $pval, $odds, $hosmer);
my ($locphrase, $oldlocphrase);

sub main {
	print "regtype	dependent	comparator	source	resulttype	independent	value\n";
	
	while (<>) {
		chomp;
		
		if (/REGRESSION\((.*)\) of (.*) vs\. (.*) using (.*) ===.*/) {
			$regtype = $1;
			$dependent = $2;
			$comparator = $3;
			$source =$4;
			
			$locphrase = "$regtype\t$dependent\t$comparator\t$source";
			
			if ($locphrase ne $oldlocphrase) {
				# output results
				$oldlocphrase = $locphrase;
			}
		}
		
		if (/Summary of Stepwise Selection.*$/) {
			if ($regtype eq 'reg') {
				for (0 .. 3) { 
					$_ = <>;
				}	# skip 4 lines	
				do {
					$_ = <>;
					if (/^\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*$/) {
						$independent = &fixIndependent($2);
						$pval = $8;
						$pval =~ s/<//;
						$pval = ($pval <= .05) ? $pval : ' ';
						unless ($pval eq ' ') {
							print "$regtype\t$dependent\t$comparator\t$source\tP-values\t$independent\t$pval\n";
						}
					}
				} while ($_ !~ /^\s*$/);			
			}	
		}
		elsif (/Type III Analysis of Effects.*/) {
			for (0 .. 3) { 
				$_ = <>;
			}	# skip 4 lines
			do {
				$_ = <>;
				if (/^\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*$/) {
					$independent = &fixIndependent($1);
					$pval = $4;
					$pval =~ s/<//;
					$pval = ($pval <= .05) ? $pval : ' ';
					unless ($pval eq ' ') {
						print "$regtype\t$dependent\t$comparator\t$source\tP-values\t$independent\t$pval\n";
					}
				}
			} while ($_ !~ /^\s*$/);
		}
		elsif (/Odds Ratio Estimates/) {
			for (0 .. 3) { 
				$_ = <>;
			}	# skip 4 lines		
			do {
				$_ = <>;
				if (/^\s*(\S+?)\s*(female vs male)?\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*$/) {
					$independent = &fixIndependent($1);
					if (($4 > 1 && $5 > 1) || ($4 < 1 && $5 < 1)) {
						$odds = $3;
					}
					else {
						$odds = ' ';
					}
					unless ($odds eq ' ') {
						print "$regtype\t$dependent\t$comparator\t$source\tOdds Ratio\t$independent\t$odds\n";
					}
				}
			} while ($_ !~ /^\s*$/);				
		}
		elsif (/Hosmer and Lemeshow Goodness-of-Fit Test/) {
			for (0 .. 2) { 
				$_ = <>;
			}	# skip 4 lines	
			$_ = <>;
			if (/^\s*(\S+?)\s*(\S+?)\s*(\S+?)\s*$/) {
				$hosmer = $3;
				unless ($hosmer eq ' ') {
					print "$regtype\t$dependent\t$comparator\t$source\tHosmer\tHosmer\t$hosmer\n";
				}
			}
		}
	}
}

sub fixIndependent {
	my $arg = shift;
	
	if ($arg =~ /avg_daily_sunlight_e/) { return 'avg_daily_sunlight_exp'; }
	if ($arg =~ /dist_from_timezone_b/) { return 'dist_from_tzb'; }
	if ($arg =~ /sunrise_local_win_so/) { return 'sunrise_local_win_solst'; }
	return $arg;
}

&main;