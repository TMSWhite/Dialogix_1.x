#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# Perl script to ensure that all nodes have an internalName - otherwise reload fails
# usage:
#		perl fix_in.pl *.txt

use strict;

foreach(@ARGV) {
	my @files = glob($_);

	foreach (@files) {
		open (SRC,$_)		or die("unable to open $_");
		my @lines = (<SRC>);	# read entire file
		close (SRC);
		open (OUT,">$_")	or die("unable to open $_ for writing");

		my @vals=();
		my $tmpCount = "0000";
		
		# Extract the data values from the lines, keeping the most recent value
		foreach my $line (@lines) {
			chomp($line);
			
			@vals = split(/\t/,$line);
			
			if ($vals[0] =~ /COMMENT|RESERVED/) {
				print OUT $line, "\n";
				next;
			}
			
			my $internalName = $vals[1];
			if (defined($internalName) && $internalName !~ /^\s*$/) {
				print OUT $line, "\n";
			}
			else {
				print OUT "$vals[0]	_tmp$tmpCount";
				shift(@vals);
				shift(@vals);
				++$tmpCount;
				
				foreach(@vals) {
					print OUT "	$_";
				}
				print OUT "\n";
			}
		}
		
		close(OUT);
	}
}
