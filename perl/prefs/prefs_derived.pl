# perl script to derive difference variables between control and reliability assessments for Preferences data
# this assumes that the variable naming structure is [acr][00-nn][dbpnsi]??[00-nn] -- for 8 characters total

use strict;

my $dir = "/data/prefs3/analysis/";
my $NA = 99999;
my $UNASKED = 44444;
my (@varnames, @vartype);
my $spss_files;
my @categories;
my %cat_counts;
my ($data_orig,$varnameline);

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
	$varnameline = shift(@lines);
	
	# sort source file's lines
#	my $sorted_data;
#	foreach my $line (@lines) {
#		my @vars = split(/\t/,$line);
#		my $fullid = $vars[0];	# is it always the first position?
#		$sorted_data->{$fullid} = $line;
#	}
#	open (OUT, ">$srcfile") or die "unable to open $srcfile";
#	print OUT "$varnameline\n";
#	foreach my $key (sort(keys(%$sorted_data))) {
#		print OUT "$sorted_data->{$key}\n";
#	}
#	close (OUT);
#	
#	exit;
	
	my %var2idx;
	my %idx2var;
	@varnames = split(/\t/,$varnameline);
	for (my $i=0;$i<=$#varnames;++$i) {
		my $varname = $varnames[$i];
		$var2idx{$varname} = $i;
		$idx2var{$i} = $varname;
		if ($varname =~ /A01/) {
			if ($varname =~ /A01[PD]/) {
				push @vartype, 'nominal';
			}
			elsif ($varname =~ /A01[SBIO]/) {
				push @vartype, 'likert';
			}
			else {
				push @vartype, 'demographic';
			}
		}
		else {
			push @vartype, 'demographic';
		}
	}
	
	foreach my $var (@varnames) {
		if ($var =~ /^A01I([A-Z][A-Z])$/) {
			push @categories, $1;
		}
	}
	
	foreach my $cat (@categories) {
		$cat_counts{$cat} = 0;
	}
	foreach my $var (@varnames) {
		if ($var =~ /^A01P([A-Z][A-Z])([0-9][0-9])$/) {
			$cat_counts{$1} = $2 if ($2 > $cat_counts{$1});
		}
	}
#	foreach my $cat (@categories) {
#		print "$cat =>";
#		for my $idx ('01' .. $cat_counts{$cat}) {
#			print " $idx";
#		}
#		print "\n";
#	}
	
	my @types = ('-','A','R','C','E');	# letter corresponding to "type" index
	
	# delete old files
	foreach my $type (@types) {
		foreach (glob("${dir}$type*.*")) {
			next unless (/^${dir}$type[0-9][0-9].*\.((tsv)|(sps)|(sav))$/);
			unlink $_ unless (-d $_);
		}
	}			
	
	# print out file that contains new variable names for appropriate components
	foreach my $line (@lines) {
		my @vals = split(/\t/,$line);
		my $fullid = $vals[$var2idx{'UniqueID'}];
		my ($id,$rep,$type) = split(/\./,$fullid);
		my $prefix = $types[$type] . sprintf "%02d", $rep;
		$spss_files->{$prefix} = $prefix;
		
		my $file = "${dir}$prefix.tsv";
		open(OUT,">>$file") or die "unable to open $file";
		
		if (-z $file) {
			# print first line (of variable names)
			my $newvarnameline = $varnameline;
			$newvarnameline =~ s/A01/$prefix/g;
			print OUT $newvarnameline, "\n";
		}
		print OUT $line, "\n";
		close (OUT);
		
		$data_orig->{$fullid} = \@vals;	
	}
	
	# Generate new dataset containing only endorsed values
	# E0xNNNN = - only retain true (non zero, non-null) values if the category was endorsed
		
	my $file = "${dir}E01.tsv";
	open (OUT, ">$file") or die "unable to open $file";
	my $newvarnameline = $varnameline;
	$newvarnameline =~ s/A01/E01/g;
	print OUT $newvarnameline, "\n";	
	$spss_files->{'E01'} = 'E01';
	my $oldid = 0;
	
	open (DISCUSS, ">${dir}discuss.tsv") or die "unable to open ${dir}discuss.tsv";
	print DISCUSS "ID\tVarName\tModule\tIndex\tValue\tClass\tDiscusVal\tNewVal\n";
	
	my $style = { 'D' => "DISCUSS", 'I' => "IMPORTANCE", 'O' => "OVERALL", 'S' => "SEVERITY", 'B' => "BOTHER", 'P' => "PRESENCE" };

	foreach my $key (sort(keys(%$data_orig))) {
		my @vals = @{ $data_orig->{$key} };
		my @newvals;
		my $newval;
		
		my $discuss_vals;	# stores whether subject wants to discuss the item for each category
		
		foreach my $cat (@categories) {
			my $idx = $var2idx{"A01D$cat"};
			$discuss_vals->{$cat} = $vals[$idx];
			print DISCUSS "$key\tA01D$cat\t$cat\t$idx\t$vals[$idx]\tDISCUSS-VAL\t$vals[$idx]\t$vals[$idx]\n";
		}
		
		# adjust vals to reflect whether subject wants to discuss symptom with provider
		for (my $i=0;$i<=$#varnames;++$i) {
			my $name = $idx2var{$i};
			if ($name =~ /^A01([DI])([A-Z][A-Z])/) {
				push @newvals, $vals[$i];	# keep values of discuss and importance
				
				print DISCUSS "$key\t$name\t$2\t$i\t$vals[$i]\t$style->{$1}\t$discuss_vals->{$2}\t$vals[$i]\n";
			}
			elsif ($name =~ /^A01([SBP])([A-Z][A-Z])/) {
#				my $discuss_idx = $var2idx{"A01D$1"};
#				if ($vals[$discuss_idx] == 1) {
				if ($discuss_vals->{$2} == 1) {
					$newval = $vals[$i];
				}
				else {
					if ($vals[$i] == $NA || $vals[$i] == $UNASKED || $vals[$i] eq '.') {
						$newval = $vals[$i];	# retain missing values
					}
					else {
						$newval = 0;	# all real values set to 0 if not endorsed -- won't 'missing' make this easier?
					}
				}
				push @newvals, $newval;
				print DISCUSS "$key\t$name\t$2\t$i\t$vals[$i]\t$style->{$1}\t$discuss_vals->{$2}\t$newval\n";
			}
			else {
				push @newvals, $vals[$i];
				print DISCUSS "$key\t$name\t.\t$i\t$vals[$i]\tOTHER\t.\t$vals[$i]\n";
			}
		}
		
		print OUT join("\t",@newvals), "\n";
	}
	close (DISCUSS);
	
	close (OUT);	
	
	# Derived variables -- various subtractions  -- do as subroutine!
	
	&create_diff_file('A01','C01','D01');
	&create_diff_file('A01','C02','F01');
	&create_diff_file('A01','A02','G01');
	&create_diff_file('E01','C01','H01');
	&create_diff_file('E01','C02','I01');
	&create_diff_file('E01','A01','J01');
	&create_diff_file('E01','A02','K01');
	
}

sub create_diff_file {
	my ($arg1, $arg2, $dst_prefix) = @_;
	my ($src1,$src2,@common_keys);
	
	# easiest way may be to read from appropriate files, by name!
	
	my $srcfile1 = "${dir}${arg1}.tsv";
	my $srcfile2 = "${dir}${arg2}.tsv";
	my $filebase = "${arg1}-${arg2}-as-$dst_prefix";
	my $dstfile = "${dir}$filebase.tsv";
	
	$spss_files->{$dst_prefix} = $filebase;	# add to list of generated files
	
	# do sorted comparison
	
	open (IN1, "<$srcfile1") or die "unable to open $srcfile1";
	my @lines1 = (<IN1>);
	close (IN1);

	# load data from 1st file
	shift(@lines1);	# remove header
	foreach my $line (@lines1) {
		chomp($line);
		my @vars = split(/\t/,$line);
		my $fullid = $vars[0];	# is it always the first position?
		my ($id,$rep,$type) = split(/\./,$fullid);
		$src1->{$id} = \@vars;
	}
	
	open (IN2, "<$srcfile2") or die "unable to open $srcfile2";
	my @lines2 = (<IN2>);
	close (IN2);
	
	# load data from 2nd file
	shift(@lines2);	# remove header
	foreach my $line (@lines2) {
		chomp($line);
		my @vars = split(/\t/,$line);
		my $fullid = $vars[0];	# is it always the first position?
		my ($id,$rep,$type) = split(/\./,$fullid);
		$src2->{$id} = \@vars;
	}
	
	foreach my $key (sort(keys(%$src1))) {
		if (defined($src2->{$key})) {
			push @common_keys, $key;
		}
	}
	
	open (OUT, ">$dstfile") or die "unable to open $dstfile";

	my $newvarnameline = $varnameline;
	$newvarnameline =~ s/A01/$dst_prefix/g;
	print OUT $newvarnameline, "\n";	
	
	foreach my $key (@common_keys) {
		&print_diffs($src1->{$key},$src2->{$key});
	}
	
	close (OUT);	
}


sub create_spss {
	my $file = "${dir}__MAIN__-summary.sps";
	open (SRC, "<$file") or die "unable to open $file";
	my @main_lines = (<SRC>);
	close (SRC);
	
	my $file = "${dir}__DERIVED__-summary.sps";
	open (SRC, "<$file") or die "unable to open $file";
	my @derived_lines = (<SRC>);
	close (SRC);	
	
	foreach my $key (sort(keys(%$spss_files))) {
		$file = "${dir}$spss_files->{$key}.sps";
		open (OUT, ">$file") or die "unable to open $file";
		my $lines;
		if ($spss_files->{$key} =~ /-as-/) {
			$lines = \@derived_lines;
		}
		else {
			$lines = \@main_lines;
		}
		foreach (@$lines) {
			my $temp = $_;
			$temp =~ s/A01/$key/g;
			$temp =~ s/__MAIN__-summary/$spss_files->{$key}/g;	# must do this second
			print OUT $temp;
		}
		close (OUT);
	}
}

sub new_print_diffs {
	my ($aval, $cval) = @_;
	return unless (defined($aval) && defined($cval));
	my @avals = @$aval;
	my @cvals = @$cval;
	my @dvals;
	
	# Revised Schema for derived variables (as of 5/30/02)
	# 1 = consistency; everything else = 0
	# if (A == 1 && C == 1) then D == 1; else D == 0
	
	if ($#avals > 0 && $#cvals > 0) {
		# have contents, so compute differences
		for (my $i=0;$i<=$#varnames;++$i) {
			if ($vartype[$i] eq 'nominal') {
				my $dval = 0;
				$dval = 1 if ($avals[$i] == 1 && $cvals[$i] == 1);
				push @dvals, $dval;
			}
			elsif ($vartype[$i] eq 'likert') {
				push @dvals, $NA;
			}
			else {
				push @dvals, $cvals[$i];
			}
		}
	}
	print OUT join("\t",@dvals), "\n";
}

sub print_diffs {
	my ($aval, $cval) = @_;
	my @avals = @$aval;
	my @cvals = @$cval;
	my @dvals;			
	# Schema for derived variables
	# A-C
	# if (A==0 && C==0) then D=. -- don't assess if not endorsed.
	# if  (A == NA && C == NA) then D=.
	# if (A== NA && C != NA) then D=NA
	# if (A!= NA && C == NA) then D=UNASKED
	
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
				push @dvals, $cvals[$i];
			}
	}
	print OUT join("\t",@dvals), "\n";
}
