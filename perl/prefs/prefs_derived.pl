# perl script to derive difference variables between control and reliability assessments for Preferences data
# this assumes that the variable naming structure is [acr][00-nn][dbpnsi]??[00-nn] -- for 8 characters total

use strict;

my $dir = "/data/prefs2/analysis/";
my $NA = 99999;
my $UNASKED = 44444;
my (@varnames, @vartype);
my $prefixes = { D01 => 'A-C_derived' };

&main;
&create_spss;

sub main {
	my $srcfile = "${dir}__MAIN__-summary.tsv";
	open (SRC, $srcfile) or die "unable to open $srcfile";
	my @lines;
	while (<SRC>) {
		chomp;
		push @lines, $_;
	}
	close (SRC);
	
	my %var2idx;
	my %idx2var;
	my $varnameline = shift(@lines);
	@varnames = split(/\t/,$varnameline);
	for (my $i=0;$i<=$#varnames;++$i) {
		my $varname = $varnames[$i];
		$var2idx{$varname} = $i;
		$idx2var{$i} = $varname;
		if ($varname =~ /A01/) {
			if ($varname =~ /A01[PD]/) {
				push @vartype, 'nominal';
			}
			else {
				push @vartype, 'likert';
			}
		}
		else {
			push @vartype, 'demographic';
		}
	}
	
	my $subjects;	# contains data for each subject
	my @types = ('-','A','R','C');	# letter corresponding to "type" index
	
	# print out file that contains new variable names for appropriate components
	
	foreach my $line (@lines) {
		my @vals = split(/\t/,$line);
		my $fullid = $vals[$var2idx{'UniqueID'}];
		my ($id,$rep,$type) = split(/\./,$fullid);
		my $prefix = $types[$type] . sprintf "%02d", $rep;
		$prefixes->{$prefix} = $prefix;
		
		# print to appropriate file
		my $file = "${dir}$prefix.tsv";
		open (OUT, ">>$file") or die "unable to open $file";
		if (-z $file) {
			# print first line (of variable names)
			my $newvarnameline = $varnameline;
			$newvarnameline =~ s/A01/$prefix/g;
			print OUT $newvarnameline, "\n";
		}
		print OUT $line, "\n";
		close (OUT);
		
		$subjects->{"$id.$type"} = \@vals;	
	}
	
	# derived variables:
	# D0xNNNN = abs(C0x - A0x).  If < 0
	
	my $file = "${dir}A-C_derived.tsv";
	open (OUT, ">$file") or die "unable to open $file";
	my $newvarnameline = $varnameline;
	$newvarnameline =~ s/A01/D01/g;
	print OUT $newvarnameline, "\n";	
	my ($avals, $cvals);
	my $oldid = 0;
	
	foreach my $key (sort(keys(%$subjects))) {
		my @vals = @{ $subjects->{$key} };
		my $fullid = $vals[$var2idx{'UniqueID'}];
		my ($id,$rep,$type) = split(/\./,$fullid);
		print "$fullid=>$id.$type\t";
		if ($id != $oldid) {
			# this is a new block of comparisons
			&print_diffs($avals, $cvals);
			
			undef($avals,$cvals);
			$oldid = $id;
		}
		$avals = \@vals if ($type == 1);
		$cvals = \@vals if ($type == 3);
	}
	&print_diffs($avals, $cvals);
	
	close (OUT);
}

sub create_spss {
	my $file = "${dir}__MAIN__-summary.sps";
	open (SRC, "<$file") or die "unable to open $file";
	my @lines = (<SRC>);
	close (SRC);
	
	foreach my $key (sort(keys(%$prefixes))) {
		$file = "${dir}$prefixes->{$key}.sps";
		open (OUT, ">$file") or die "unable to open $file";
		foreach (@lines) {
			my $temp = $_;
			$temp =~ s/__MAIN__-summary/$prefixes->{$key}/g;
			$temp =~ s/A01/$key/g;
			print OUT $temp;
		}
		close (OUT);
	}
}

sub print_diffs {
	my ($aval, $cval) = @_;
	return unless (defined($aval) && defined($cval));
	my @avals = @$aval;
	my @cvals = @$cval;
	my @dvals;
	
	if ($#avals > 0 && $#cvals > 0) {
		# have contents, so compute differences
		for (my $i=0;$i<=$#varnames;++$i) {
			if ($vartype[$i] eq 'nominal') {
				my $dval = $avals[$i] - $cvals[$i];
				$dval = '.' if ($avals[$i] == 0 && $cvals[$i] == 0);	# missing value, since don't want 
				$dval = '.' if ($avals[$i] == $NA && $cvals[$i] == $NA);
				$dval = $NA if ($avals[$i] == $NA && $cvals[$i] != $NA);
				$dval = $UNASKED if ($avals[$i] != $NA && $cvals[$i] == $NA);
				push @dvals, $dval;
			}
			elsif ($vartype[$i] eq 'likert') {
				my $dval = $avals[$i] - $cvals[$i]; # distance measurement
				$dval = (-$dval) if ($dval < 0);
				$dval = '.' if ($avals[$i] == $NA && $cvals[$i] == $NA);
				$dval = $NA if ($avals[$i] == $NA && $cvals[$i] != $NA);
				$dval = $UNASKED if ($avals[$i] != $NA && $cvals[$i] == $NA);
				push @dvals, $dval;
			}
			else {
				push @dvals, $avals[$i];
			}
		}
	}
	print OUT join("\t",@dvals), "\n";
}
