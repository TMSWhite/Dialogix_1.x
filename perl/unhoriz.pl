# perl script to re-convert dialogix data files from horizontal back to vertical
# Tries to determine which instrument was used (since this is not a normal part of the data files) 
# by comparing list of variable names in data file to the instruments in $inst_dir

use strict;

&main;

my ($src_dir, $dst_dir, $logfile, $inst_dir, @newfiles);

my (%scheds);

sub main {
	($src_dir, $dst_dir, $inst_dir, $logfile) = @ARGV;
	
	open (LOG, ">$logfile") or die "unable to write to $logfile";
	
	&load_scheds;

	chdir($src_dir);
	my @files = glob("main*");
	
	foreach (@files) {
		print LOG "processing $_\n";
		&process($_);
	}
	
	print LOG "***\n";
	
	foreach (sort(@newfiles)) {
		print LOG "$_\n";
	}
	
	close (LOG);
}

# load variable names from schedules
sub load_scheds {
	chdir($inst_dir) or die "unable to chdir to $inst_dir";
	my @insts = glob("*.var");
	
	foreach my $name (@insts) {
		my %vars;
		print LOG "reading from $name\n";
		open (INST,"<$name") or die "unable to read from $name";
		my @lines = (sort(<INST>));
		foreach (@lines) {
			chomp;
			next if (/^((\s*)|(__START_TIME__)|(__STOP_TIME__)|(ND.*)|(_.*))$/);
			$vars{$_} = $_;
		}
		$scheds{$name} = \%vars;
		print LOG "\tfound " . scalar(keys(%vars)) . " values\n";
	}
}

sub calc_match {
	my $file = shift;
	my $var_ref = shift;
	my @vars = split(/\t/,$var_ref);
	my %ratios;
	
	foreach my $key (sort(keys(%scheds))) {
		my %names = %{ $scheds{$key} };
		my $match = 0;
		my $miss = 0;
		my $total = 0;
		
		foreach my $var (@vars) {
			if (defined($names{$var})) {
				++$match;
			}
			else {
				++$miss;
			}
		}
		$total = scalar(keys(%names));
		my $ratio = $match / $total unless ($total==0);
		$ratios{(1-$ratio)} = {
			sched => $key,
			info => "*$file\t$key\t$match\t$miss\t$total\t$ratio\n",
		};
	}
	my $count = 0;
	my $sched;
	foreach my $key (sort(keys(%ratios))) {
		++$count;
		my %hash = %{$ratios{$key}};
		if ($count == 1) {
			$sched = $hash{'sched'};
		}
		print LOG $hash{'info'};
	}
	$sched =~ s/\.vars//;	# strip suffix
	print LOG "== so selecting $sched\n";
	return $sched;
}

sub process {
	my $file = shift;
	
	open (IN,"<$file") or die "unable to read from $file";
	my @lines = (<IN>);
	close (IN);
	
	my $varline = shift(@lines);
	chomp($varline);
	
	my $sched = &calc_match($file, $varline);
	
	foreach (@lines) {
		chomp;
		next if (/^\s*$/);
		&unhoriz($sched,$varline,$_);
	}
}

sub unhoriz {
	my $sched = shift;
	my @names = split(/\t/,shift);
	my @vals = split(/\t/,shift);
	my %hash;
	
	for (my $i=0;$i<=$#names;++$i) {
		$hash{$names[$i]} = $vals[$i];
	}
	
	# first val is unique id -- create a file with that name
	my $file = "$dst_dir/$vals[0]";
	
	push @newfiles, $vals[0];
	
	if (-e $file) {
		print LOG "\tWARN -- $file already exists!\n";
	}

	open (OUT, ">$file.dat") or die "unable to write to $file.dat";
	
	print LOG "\t$file.dat\n";
	
	print OUT "RESERVED\t__SCHEDULE_SOURCE__\t/usr/local/dialogix/webapps/CIC/schedules/$sched.jar\n";
	
	foreach (sort(@names)) {
		print OUT "\t$_\t0\t-1\t\t$hash{$_}\t\n";
	}
	close (OUT);
}
