# perl program to generate equations and summary reports from Clincare data

use strict;

open(IN,"<clincare-eqns.txt") or die "unable to open clincare-eqns.txt";
my @lines = (<IN>);
chomp(@lines);
close (IN);

shift(@lines);	# remove column labels

my (%topics, @order);

# parse source lines
foreach my $line (@lines) {
	my @cols = split(/,/,$line);
	
	my $topic = $cols[0];
	$topics{$topic} = {
		topic => $topic,
		Saturation => $cols[1],
		Global_100 => $cols[2],
		Max_Score => $cols[3],
		Question_Equals => $cols[4],
		Equation => $cols[5],
	};
	push @order, $topic;
}

open (OUT, ">test.txt");

print OUT "TOTAL\tTOTAL\t\t1\te\t\t10\tnothing\n";	# fake version of total scores

# generate score lines
foreach my $item (@order) {
	my $topic = $topics{$item};
	
	my @vars = split(/\+/,$topic->{Equation});
	my @vars2;
	my $qval = $topic->{Question_Equals};
	
	next if ($topic->{Saturation} == -1);

	foreach (@vars) {
		push @vars2, "(($_)?$_:$qval)";
	}
	
	print OUT "$topic->{Saturation}\t$topic->{Saturation}\t\t1\te\t\t(" . join(" + ",@vars2) . ")\tdouble\n";
}

# generate list of positive symptoms, and table elements
my @report_rows = "<tr><td>Domain</td><td>Global_100</td><td>Saturation Score</td><td>Saturation</td><td>Positive Items</td></tr>";

foreach my $item (@order) {
	my $topic = $topics{$item};
	
	my @vars = split(/\+/,$topic->{Equation});
	my @vars2;
	my $qval = $topic->{Question_Equals};
	
	foreach my $var (@vars) {
#		push @vars2, "(($var)?getAnsOption($var):'')";	# must adjust to deal with $qval = 1
		push @vars2, "_ans_$var";
		# make variables that capture the answer option
		if ($var ne '0') {
			print OUT "_ans_$var\t_ans_$var\t\t($var)";
			if ($topic->{Question_Equals} == 1) {
				print OUT " || ($var == '?')";
			}
			print OUT "\te\t\tgetAnsOption($var)\tnothing\n";
		}
	}
	
	my $percent;
	my $list;
	
	if ($topic->{Saturation} ne '-1') {
		print OUT "_pct_$topic->{Saturation}\t_pct_$topic->{Saturation}\t\t1\te\t\t$topic->{Saturation} / $topic->{Max_Score}\tdouble\n";
		$percent = "`formatNumber(_pct_$topic->{Saturation},'##.#%')`";
	}
	else {
		$percent = "??%";
	}
	
	if ($topic->{Saturation} eq '-1') {
		$list = '&nbsp;';
	}
	else {
		$list = "_list_$topic->{Saturation}";
		print OUT "$list\t$list\t\t1\te\t\tlist(" . join(", ",@vars2) . ")\tnothing\n";
		$list = "`$list`";
	}
	
	push @report_rows, 
		"<tr><td>$topic->{topic}</td><td>`$topic->{Global_100}`%</td><td>`$topic->{Saturation}`</td><td>$percent</td><td>$list</td></tr>";
}

# print report table
print OUT "_report0\treport0\t\t1\t[\t\tSummary Report\tnothing\n";
print OUT "_report1\treport1\t\t1\t]\t\t<table width='100%' border='1'>" . join("",@report_rows) . "</table>\tnothing";

close (OUT);
