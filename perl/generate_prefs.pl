# perl script to help out Pallav

use strict;

my (%data, @lines, @sts, @topics, %mapping, @newlines, @keep, %varnames, @summary);

&main;

sub main {
	# store source info
	open (IN, "<Preferences-template.txt");
	@lines = (<IN>);
	close (IN);
	&preprocess_file;
	&prepare_topics;
	&prepare_followup;
	&prepare_summary;
	
	#create new file
	open (OUT, ">Preferences-new.txt");
	&print_output;
	close(OUT);
}

sub preprocess_file {
	foreach my $line (@lines) {
		chomp;
		my @vals = split(/\t/,$line);
		
		# initialize mapping of unique name to line contents.
		$data{$vals[1]} = $line;
		
		# initialize @topics and %mapping
		if ($vals[1] =~ /^(.+)_(.+)_severity/) {
			if ($2 eq 'intro') {
				push @topics, $1;
			}
			else {
				my $key = "${1}_$2";
				if ($vals[6] =~ /<font.+?>(.+?):?<\/font>/) {
					# mapping of key to description
					push @sts, "$key\t$1";
				}
				if ($vals[0] =~ /^[sb](.+)$/) {
					# there is a variable name -- use it
					$varnames{$key} = $1;
				}						
			}
		}
		elsif ($vals[1] =~ /^screen_(.+)/) {
			# initialize mapping
			$mapping{ucfirst($1)} = $vals[6];
		}
	}
}

sub qtype {
	my ($num,$max,$endable,$nested) = @_;
	return "[" if ($num == 1 && $nested==0);
	return "]" if ($num >= $max && $endable==1);
	return "q";
}


sub prepare_topics {
	my $counter = 0;
	my $max = ($#topics+1);
	
	foreach my $topic (@topics) {
		++$counter;
		# use old variable names if possible -- else use composite name
		my $prefix = $varnames{$topic};
		if (!defined($prefix)) {
			$prefix = substr($topic,0,2) . (($counter < 10) ? "0$counter" : $counter);
		}
		
		push @newlines, "\t${topic}_intro\t$counter\tscreen_" . lc($topic) . "==1\t" . &qtype($counter,$max,0,0) . "\t\t" . 
			qq|<center>Your <b>$mapping{$topic}</b></center> Since the last time I saw my doctor,nurse or other health care provider I had..	nothing|;
		
		&prepare_subtopics($topic,$counter,$prefix,($counter==$max));
		push @newlines, "";
	}
}

sub prepare_followup {
	my $counter = 0;
	my $max = ($#topics+1);
	
	foreach my $topic (@topics) {
		++$counter;
		
		# use old variable names if possible -- else use composite name
		my $prefix = $varnames{$topic};
		if (!defined($prefix)) {
			$prefix = substr($topic,0,2) . (($counter < 10) ? "0$counter" : $counter);
		}		
		push @newlines, "\t${topic}_followup\t$counter\tscreen_" . lc($topic) . "==1\t" . &qtype($counter,$max,0,0) . "\t\t" . 
			qq|<center>Your <b>$mapping{$topic}- </b></center> You selected $mapping{$topic} as being a problem for you during the past week. Please rate the severity and bother of your $mapping{$topic} during the past week below.	nothing|;
		
		&prepare_subtopic_followup($topic,$counter,$prefix,($counter==$max));
		push @newlines, "";
	}
}

sub get_id {
	my ($topic,$counter,$subtopic,$subc) = @_;
}

sub prepare_subtopics {
	my ($topic,$counter,$prefix,$endable) = @_;
	my $subc = 0;
	my @list;
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$topic/);
		push @list, $st;
	}
	
	my $max = ($#list+1);
	
	foreach my $st (@list) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$topic/);
		
		++$subc;
		
		# use old variable names if possible -- else use composite name
		my $subprefix = $varnames{$vals[0]};
		if (!defined($subprefix)) {
			$subprefix = "$prefix" . substr($vals[1],0,2) . $subc;
		}		
		
		push @newlines, "p$subprefix\t$vals[0]" . "_present\t$counter.$subc\tscreen_" . lc($topic) . "==1\t" . &qtype($subc,$max,$endable,1) . "\t\t$vals[1]\tcheck|1|Yes";
	}
}

sub prepare_subtopic_followup {
	my ($topic,$counter,$prefix,$endable) = @_;
	my $subc = 0;
	my @list;
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$topic/);
		push @list, $st;
	}
	
	my $max = ($#list+1);

	foreach my $st (@list) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$topic/);
		
		++$subc;

		# use old variable names if possible -- else use composite name
		my $subprefix = $varnames{$vals[0]};
		if (!defined($subprefix)) {
			$subprefix = "$prefix" . substr($vals[1],0,2) . $subc;
		}		
				
		push @newlines, "s$subprefix\t$vals[0]" . "_severity\t$counter.$subc" . "s\tscreen_" . lc($topic) . "==1 && $vals[0]" . "_present==1\t" . &qtype($subc,$max,0,1) . "\t\t$vals[1]" .
			qq| (<font color="#0000ff">Symptom Severity</font>)	| .
			"combo|0|Not Present|1|Mild|2|Moderate|3|Severe				0";
		push @newlines, "b$subprefix\t$vals[0]" . "_bother\t$counter.$subc" . "b\tscreen_" . lc($topic) . "==1 && $vals[0]" . "_present==1\t" . &qtype($subc,$max,$endable,1) . "\t\t$vals[1]" .
			qq| (<font color="#ff0000">Symptom Bother or Burden</font>)	| .
			"combo|0|0 Not at all|1|1|2|2|3|3|4|4|5|5|6|6|7|7|8|8|9|9|10|10 Extremely				0";

	}
}

sub prepare_summary {
	my $counter = 0;
	foreach my $topic (@topics) {
		++$counter;
		my $lctopic = lc($topic);
		push @summary, "t$counter$lctopic\tsummary_$lctopic\t\tscreen_$lctopic==1\tq\t\t" . &build_summary_table($topic) . "\tnothing";
	}
}

sub build_summary_table {
	my $topic = shift;
	my $lctopic = lc($topic);
	my @list;
	my $table = '';
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$topic/);
		push @list, $vals[0];
	}
	
	$table .= qq|<table width="100%" border="1"><tr>|;
	$table .= qq|<td width="30%"><b>| . uc($mapping{$topic}) . qq|</b></td>|;
	$table .= qq|<td width="15%"><b>Severity</b></td><td width="15%"><b>Bother</b></td><td width="15%"><b>Importance</b></td><td width="25%" align='center'><b>Comments</b></td>|;
	$table .= qq|</tr><tr><td style="background:silver"><b>`getActionText(screen_$lctopic)`</b></td><td style="background:silver">&nbsp;</td><td style="background:silver">&nbsp;</td><td style="background:silver"><b>`${topic}_imp`</b></td><td style="background:silver">&nbsp;</td></tr>|;
	
	foreach my $st (@list) {
		$table .= qq|<tr><td>`getActionText(${st}_severity))`</td><td>`getAnsOption(${st}_severity)`</td><td>`${st}_bother`</td><td>&nbsp;</td><td>&nbsp;</td></tr>|;
	}

	$table .= qq|</table>|;
	return $table;
}



sub print_output {
	foreach my $line (@lines) {
		my @vals = split(/\t/,$line);
		if ($vals[0] eq 'RESERVED') {
			push @keep, $line;
			next;
		}
		if ($vals[1] =~ /^(.+)_((severity)|(bother))$/) {
			next;
		}
		if ($vals[1] =~ /^summary/) {
			next unless ($vals[1] =~ /^summary_((title)|(end))$/);
			if ($vals[1] =~ /title/) {
				unshift @summary, $line;
			}
			else {
				push @summary, $line;	# end
			}
			next;
		}
		# add the final line 
		if ($vals[1] eq 'end') {
			push @summary, $line;
			next;
		}
		
		push @keep, $line;
	}
	
	# now generate file
	foreach my $line (@keep) {
		next if ($line =~ /^\s*$/);		#empty line
		
		if ($line =~ /problem_list/) {
			print OUT $line;
			foreach (@newlines) {
				next if (/^\s*$/);		#empty line
				
				print OUT "$_\n";
			}
		}
		else {
			print OUT $line;
		}
	}
	foreach (@summary) {
		next if (/^\s*$/);		#empty line
		
		print OUT "$_\n";
	}	
}
