# perl script to help out Pallav

use strict;

my (@sts, @classes, %mapping, %varnames, %disc_mapping, %disc_varnames);
my (@class_lines, @sx_lines, @discuss_lines, @template_lines, %hsts);
my (@new_screen, @new_present, @new_followup, @new_importance, @new_summary);

my $twidth= "width='100%'";
my @width = ( "width='30%'", "width='8%'", "width='8%'", "width='54%'" );
my @style = ( "style='background:silver'", "style='background-color:#E9E9E9'");
my $htmlprefix = "/cvs2/Dialogix/web/Prefs/";

&main;

sub main {
	&load_template;
	&load_classes;
	&load_sx;
	&load_discuss;
	
	&prepare_screening;	# makes @new_screen
	&prepare_classes;	# makes @new_present
	&prepare_followup;	# makes @new_followup
	&prepare_importance;	#makes @new_importance
	&prepare_summary;	# makes @new_summary
	
	#create new file
	open (OUT, ">$htmlprefix/WEB-INF/schedules/Preferences-2_9.txt");
	&print_output;
	close(OUT);	
	
	&make_htmls;
	
}

sub load_template {
	open (IN,"<prefs_template.tab");
	@template_lines = (<IN>);
	close (IN);
}

sub load_classes {
	open (IN,"<prefs_classes.tab");
	@class_lines = (<IN>);
	close(IN);
	
	foreach (@class_lines) {
		chomp;
		my @vars = split(/\t/);
		if ($vars[1] =~ /^screen_(.+)$/) {
			push @classes, ucfirst($1);
			$mapping{ucfirst($1)} = $vars[2];
			$varnames{$vars[1]} = $vars[0];
		}
	}
}

sub load_sx {
	open (IN, "<prefs_sx.tab");
	@sx_lines = (<IN>);
	close(IN);
	foreach (@sx_lines) {
		chomp;
		my @vars = split(/\t/);
		if ($vars[1] =~ /^(.+)_present$/) {
			$varnames{$1} = $vars[0];
			push @sts, "$1\t$vars[2]";
			$hsts{$1} = $vars[2];
		}
	}
}

sub load_discuss {
	open (IN,"<prefs_discuss.tab");
	@discuss_lines = (<IN>);
	close(IN);
	
	foreach (@discuss_lines) {
		chomp;
		my @vars = split(/\t/);
		if ($vars[1] =~ /^(.+)_discuss$/) {
			$disc_mapping{ucfirst($1)} = $vars[2];
			$disc_varnames{ucfirst($1)} = $vars[0];
		}
	}
}

sub prepare_screening {
	my $counter = 0;
	my $max = ($#classes+1);
	
	foreach my $class (@classes) {
		++$counter;
		my $lcclass = lc($class);
		my $varname = $varnames{"screen_" . lc($class)};
		
		push @new_screen, "$varname\tscreen_$lcclass\t\t1\t" . &qtype($counter,$max,1,1) . "\t\t$mapping{$class}\t" . 
			"check|1|Yes\t../" . lc($class) . ".htm";
	}
	
}


sub prepare_classes {
	my $counter = 0;
	my $max = ($#classes+1);
	
	foreach my $class (@classes) {
		++$counter;
		my $prefix = $varnames{$class};
		my $title2 = "I had...";
		$title2 = "I felt..."	if (($class =~ /energy/i) || ($class =~ /mood/i));
		$title2 = "I ..." if (($class =~ /sleep/i) || ($class =~ /memory/i));
		$title2 = "it has been difficult for me ..." if (($class =~ /relation/i) || ($class =~ /control/i) || ($class =~ /spiritual/i));
		$title2 = "I needed help with ..." if ($class =~ /activities/i);
		$title2 = "I have been worried / had concerns about ..." if ($class =~ /worries/i);
		
		push @new_present, "\t${class}_intro\t$counter\tscreen_" . lc($class) . "==1\t" . &qtype($counter,$max,1,1) . "\t\t" . 	# all nested
			qq|<center><b>$mapping{$class}</b><br/><b>$title2</b></center>	nothing|;
		
		&prepare_subclasses($class,$counter,$prefix,($counter==$max));
		push @new_present, "";
	}
}

sub prepare_subclasses {
	my ($class,$counter,$prefix,$endable) = @_;
	my $subc = 0;
	my @list;
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		push @list, $st;
	}
	
	my $max = ($#list+1);
	
	foreach my $st (@list) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		
		++$subc;
		
		my $subprefix = $varnames{$vals[0]};
		
		if ($class =~ /other/i) {
			push @new_present, "p$subprefix\t$vals[0]" . "_present\t$counter.$subc\tscreen_" . lc($class) . "==1\t" . &qtype($subc,$max,$endable,1) . "\t\t$vals[1]\tmemo				 "; 
		}
		else {
			push @new_present, "p$subprefix\t$vals[0]" . "_present\t$counter.$subc\tscreen_" . lc($class) . "==1\t" . &qtype($subc,$max,$endable,1) . "\t\t$vals[1]\tcheck|1|Yes"; 
		}
	}
}


sub prepare_followup {
	my $counter = 0;
	my $max = ($#classes+1);
	
	foreach my $class (@classes) {
		++$counter;
		my $lcclass = lc($class);
		
		my $prefix = $varnames{$class};
		
 		push @new_followup, "\t${class}_followup\t$counter\tscreen_$lcclass==1\t" . &qtype($counter,$max,0,1) . "\t\t" .
			qq|<center><b>$mapping{$class}</b></center>	nothing|;
		
		my $subcount = &prepare_subclass_followup($class,$counter,$prefix,($counter==$max));
		
		push @new_followup, "$disc_varnames{$class}\t${class}_discuss\t${counter}.$subcount\tscreen_$lcclass==1\t" . &qtype($counter,$max,1,1) . "\t\t<b>".
			$disc_mapping{$class}	. "</b>\tcombo|0|No|1|Yes";

		push @new_followup, "";
	}
}

sub prepare_importance {
	my $counter = 0;
	my $max = ($#classes+1);
	
	foreach my $class (@classes) {
		++$counter;
		my $lcclass = lc($class);
		
		my $prefix = $varnames{$class};
 		push @new_importance, "i$counter$lcclass\t${class}_imp\t\tscreen_$lcclass==1\t" . &qtype($counter,$max,1,1) . "\t$mapping{$class}\t$mapping{$class}\t" .
 			"radio2|0|0 Not important|1|1|2|2|3|3|4|4|5|5|6|6|7|7|8|8|9|9|10|10 Very important";
	}
}


sub prepare_subclass_followup {
	my ($class,$counter,$prefix,$endable) = @_;
	my $subc = 0;
	my @list;
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		push @list, $st;
	}
	
	my $max = ($#list+1);

	foreach my $st (@list) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		
		++$subc;

		my $subprefix = $varnames{$vals[0]};
				
		push @new_followup, "s$subprefix\t$vals[0]" . "_severity\t$counter.$subc" . "s\tscreen_" . lc($class) . "==1 && $vals[0]" . "_present==1\t" . &qtype($subc,$max,0,1) . "\t\t$vals[1]" .
			qq|<center>(<font color="#0000ff">severity</font>)</center>	| .
			"combo|1|Mild|2|Moderate|3|Severe";
		push @new_followup, "b$subprefix\t$vals[0]" . "_bother\t$counter.$subc" . "b\tscreen_" . lc($class) . "==1 && $vals[0]" . "_present==1\t" . &qtype($subc,$max,$endable,1) . "\t\t"	. 	# used to list name: $vals[1]" .
			qq|<center>(<font color="#ff0000">bother</font>)</center>	| .
			"combo|1|1|2|2|3|3|4|4|5|5|6|6|7|7|8|8|9|9|10|10 Extremely";

	}
	return ++$subc;
}

sub prepare_summary {
	my $counter = 0;
	foreach my $class (@classes) {
		++$counter;
		my $lcclass = lc($class);
		&build_summary_table($class);
	}
}

sub build_summary_table {
	my $class = shift;
	my $lcclass = lc($class);
	my @list;
	
	# list of items in this category
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		push @list, $vals[0];
	}
	
	push @new_summary, "\tsummary_${lcclass}_header1\t\tscreen_$lcclass==1\tq\t\t" . &build_summary_table2($class,'_header1_') . "\tnothing";
	push @new_summary, "\tsummary_${lcclass}_header2\t\tscreen_$lcclass==1\tq\t\t" . &build_summary_table2($class,'_header2_') . "\tnothing";
	
	foreach my $st (@list) {
		push @new_summary, "\tsummary_" . lc($st) . "\t\tscreen_$lcclass==1 && !isNA(${st}_severity)\tq\t\t" . &build_summary_table2($class,$st) . "\tnothing";
	}
}

sub build_summary_table2 {
	my ($class,$st) = @_;
	my $table = '';
	my $lcclass = lc($class);

	$table .= qq|<table $twidth border="0"><tr>|;
	
	if ($st eq '_header1_') {
		#header row
		$table .= qq|<td $style[0] $width[0]><b>| . uc($mapping{$class}) . qq|</b></td>|;
		$table .= qq|<td $style[0] $width[1]><b>Severity</b></td><td $style[0] $width[2]><b>Bother</b></td><td $style[0] $width[3] align='center'><b>Comments</b></td>|;
	}
	elsif ($st eq '_header2_') {
		$table .= qq|<td $width[0] $style[1]><b>Importance</b></td><td $width[1] $style[1]><b>`${class}_imp`</b></td><td $width[2] $style[1]>&nbsp;</td><td $width[3] $style[1]><b>`(${class}_discuss)?'Need to discuss with health care provider':'&nbsp;'`</b></td>|;
	}
	else {
		$table .= qq|<td $width[0]>$hsts{$st}</td><td $width[1]>`getAnsOption(${st}_severity)`</td><td $width[2]>`${st}_bother`</td><td $width[3]>&nbsp;</td>|;
	}
	
	$table .= qq|</tr></table>|;
	return $table;	
}



sub print_output {
	foreach(@template_lines) {
		chomp;
		next if (/^\s*$/);
		
		if (/^##INSERT_SCREEN##/) { 
			&print_lines(\@new_screen); 
		}
		elsif (/^##INSERT_PRESENT##/) {
			&print_lines(\@new_present);
		}
		elsif(/^##INSERT_FOLLOWUP##/) {
			&print_lines(\@new_followup);
		}
		elsif(/^##INSERT_IMPORTANCE##/) {
			&print_lines(\@new_importance);
		}
		elsif(/^##INSERT_SUMMARY##/) {
			&print_lines(\@new_summary);
		}
		else {
			print OUT "$_\n";
		}
	}
}

sub print_lines {
	my $args = shift;
	my @lines = @$args;
	
	foreach (@lines) {
		next if (/^\s*$/);
		print OUT "$_\n";
	}
}

sub qtype {
	my ($num,$max,$endable,$nested) = @_;
	return "[" if ($num == 1 && $nested==0);
	return "]" if ($num >= $max && $endable==1);
	return "q";
}

sub make_htmls {
	foreach (@classes) {
		&make_html($_);
	}
}


sub make_html {
	my $class = shift;
	my @list;
	my @lines;
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		push @list, $st;
	}
	
	my $max = ($#list+1);
	
	foreach my $st (@list) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		
		push @lines, "<tr><td width='100%'>$vals[1]</td></tr>";
	}	
	
	#print html file
	my $file = "$htmlprefix" . lc($class) . ".htm";
	open (OUT, ">$file")	or die "unable to write to $file";
	
	print OUT "<html>\n<head>\n<title>$mapping{$class}</title>\n</head>\n<body>\n";
	print OUT "<table width='100%' border='1'>\n";
	print OUT "<tr><td width='100%' style='background-color:silver'><b>$mapping{$class}</b></td></tr>\n";
	foreach (@lines) {
		print OUT "$_\n";
	}
	print OUT "</table>\n</body>\n</html>\n";
	close (OUT);
}
