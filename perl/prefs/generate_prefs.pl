# perl script to help out Pallav

use strict;

my (@sts, @classes, %mapping, %varnames, %disc_mapping, %disc_varnames);
my (@class_lines, @sx_lines, @discuss_lines, @template_lines, %hsts);
my (@new_screen, @new_present, @new_other, @new_followup, @new_importance, @new_summary);

my $twidth= "width='100%'";
my @width = ( "width='30%'", "width='12%'", "width='12%'", "width='48%'" );
my @style = ( "style='background:silver'", "style='background-color:#E9E9E9'");
#my $htmlprefix = "/usr/local/dialogix/webapps/Prefs/";
my $htmlprefix = "/cvs2/Dialogix/web/Prefs/";


&main;

sub main {
	&load_template;
	&load_classes;
	&load_sx;
	&load_discuss;
	
	&prepare_screening;	# makes @new_screen
	&prepare_classes;	# makes @new_present
	&prepare_other;		# makes @new_other
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
			push @classes, ucfirst($1);		# N.B. that class name has first letter upper-cased
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
		$title2 = "I have had difficulty ..." if (($class =~ /relation/i) || ($class =~ /control/i) || ($class =~ /spiritual/i));
		$title2 = "I needed help with ..." if ($class =~ /activities/i);
		$title2 = "I have been worried / had concerns about ..." if ($class =~ /worries/i);
		
		push @new_present, "\t${class}_intro\t$counter\tscreen_" . lc($class) . "==1\t" . &qtype($counter,$max,0,1) . "\t\t" . 	# all nested
			qq|<center><b>$mapping{$class}:  $title2</b></center>	nothing|;
		
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
		
		my $msg = $vals[1];
		$msg = "$vals[1] (please specify on next page)"	if ($vals[0] =~ /Other/i);
		
		push @new_present, "p$subprefix\t$vals[0]" . "_present\t$counter.$subc\tscreen_" . lc($class) . "==1\t" . &qtype($subc,$max,$endable,1) . "\t\t$msg\tcheck|1|Yes"; 
	}
}

sub prepare_other {
	my $class = 'Other';
	my $subc = 0;
	my @list;
	
	foreach my $st (@sts) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		push @list, $st;
	}
	
	my $max = ($#list+1);
	my $others_present = '(screen_other==1)&&(0';
	
	foreach my $st (@list) {
		chomp($st);
		my @vals = split(/\t/, $st);
		next unless ($vals[0] =~ /$class/);
		
		++$subc;
		
		my $subprefix = $varnames{$vals[0]};
		
		$others_present .= "||($vals[0]_present==1)";
		
		push @new_other, "n$subprefix\t$vals[0]" . "_name\tOther.$subc\tscreen_" . lc($class) . "==1&&$vals[0]_present==1\t" . &qtype($subc,$max,1,1) . "\t\t$vals[1] (please specify)\ttext"; 
	}
	$others_present .= ")";
	
	unshift @new_other, "	other_details		$others_present	[		Please indicate which other symptom(s) you have had	nothing";

}



sub prepare_followup {
	my $counter = 0;
	my $max = ($#classes+1);
	
	foreach my $class (@classes) {
		++$counter;
		my $lcclass = lc($class);
		
		my $prefix = $varnames{$class};
		
 		push @new_followup, "\t${class}_followup\t$counter\tcolltype!=3&&screen_$lcclass==1\t" . &qtype($counter,$max,0,1) . "\t\t" .
			qq|<center><b>$mapping{$class}</b></center>	nothing|;
		
		my $subcount = &prepare_subclass_followup($class,$counter,$prefix,0);	# not endable
		
		push @new_followup, "$disc_varnames{$class}\t${class}_discuss\t${counter}.$subcount\tcolltype!=3&&screen_$lcclass==1\t" . &qtype($counter,$max,1,1) . "\t\t".
			"<i>$disc_mapping{$class}</i>"	. "\tradio|1|Yes|0|No";

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
 		push @new_importance, "i$counter$lcclass\t${class}_imp\t\tcolltype!=3&&screen_$lcclass==1\t" . &qtype($counter,$max,1,1) . "\t$mapping{$class}\t$mapping{$class}\t" .
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
		
		my $msg = $vals[1];
		$msg = "`$vals[0]_name`"	if ($vals[0] =~ /Other/i);
		
		my $severity_scale =  "radio3|0|<font color='#0000ff'>Not Present</font>|1|<font color='#0000ff'>Mildly</font>|2|<font color='#0000ff'>Moderately</font>|3|<font color='#0000ff'>Very</font>|4|<font color='#0000ff'>Extremely</font>";
		my $severity_msg = "How <b>severe</b>?";
		my $bother_msg = "How <b>bothersome</b>?";
		if ($class =~ /Activities/i) {
			$severity_scale = "radio3|0|<font color='#0000ff'>Manage Without Help</font>|1|<font color='#0000ff'>Need a Little Help</font>|2|<font color='#0000ff'>Need Some Help</font>|3|<font color='#0000ff'>Need a Lot of Help</font>|4|<font color='#0000ff'>Completely Dependent Upon Help</font>";
			$severity_msg = "How much help do you need?";
		}

				
		push @new_followup, "s$subprefix\t$vals[0]" . "_severity\t$counter.$subc" . "s\tcolltype!=3&&screen_" . lc($class) . "==1 && $vals[0]" . "_present==1\t" . 
			&qtype($subc,$max,0,1) . "\t\t<b>$msg</b>" .
			qq|<center><font color='#0000ff'>$severity_msg</font></center>	| .
			$severity_scale;
		push @new_followup, "b$subprefix\t$vals[0]" . "_bother\t$counter.$subc" . "b\tcolltype!=3&&screen_" . lc($class) . "==1 && $vals[0]" . "_present==1\t" . 
			&qtype($subc,$max,$endable,1) . "\t\t"	. 	# used to list name: $vals[1]" .
			qq|<center><font color='#006600'>$bother_msg</font></center>	| .
			"radio3|0|<font color='#006600'>None</font>|1|<font color='#006600'>A little</font>|2|<font color='#006600'>Moderately</font>|3|<font color='#006600'>Quite a bit</font>|4|<font color='#006600'>Extremely</font>";

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
		push @new_summary, "\tsummary_" . lc($st) . "\t\tscreen_$lcclass==1 && ${st}_present==1\tq\t\t" . &build_summary_table2($class,$st) . "\tnothing";
	}
}

sub build_summary_table2 {
	my ($class,$st) = @_;
	my $table = '';
	my $lcclass = lc($class);

	$table .= qq|<table $twidth border="0"><tr>|;
	
	if ($st eq '_header1_') {
		#header row
		$table .= qq|<td $style[0] $width[0]><font size='-1'><b>| . uc($mapping{$class}) . qq|</b></font></td>|;
		$table .= qq|<td $style[0] $width[1]><font size='-1'><b>Severity</b></font></td><td $style[0] $width[2]><font size='-1'><b>Bother</b></font></td><td $style[0] $width[3] align='center'><font size='-1'><b>Comments</b></font></td>|;
	}
	elsif ($st eq '_header2_') {
		$table .= qq|<td $width[0] $style[1]><font size='-1'><b>Importance</b></font></td><td $width[1] $style[1] align='center'><font size='-1'><b>`${class}_imp`</b></font></td><td $width[2] $style[1]>&nbsp;</td><td $width[3] $style[1]><font size='-1'><b>`(${class}_discuss)?'Discuss with health care provider':'&nbsp;'`</b></font></td>|;
	}
	else {
		my $msg = $hsts{$st};
		$msg = "`${st}_name`"	if ($st =~ /other/i);
		$table .= qq|<td $width[0]><font size='-1'>$msg</font></td><td $width[1]><font size='-1'>`getAnsOption(${st}_severity)`</font></td><td $width[2]><font size='-1'>`getAnsOption(${st}_bother)`</font></td><td $width[3]>&nbsp;<br/>&nbsp;</td>|;
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
			&print_lines(\@new_other);
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
