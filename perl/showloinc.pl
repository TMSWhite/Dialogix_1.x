#perl script to facilitate translation of Dialogix files
#goal - create editable HTML files
#Expects the following format:
#0 LOINC_NUM	
#1 COMPONENT	
#2 PROPERTY	
#3 TIME_ASPCT	
#4 SYSTEM	
#5 SCALE_TYP	
#6 METHOD_TYP	
#7 CLASS	
#8 Instrument	
#9 Sequence	
#10 Section	
#11 Concept	
#12 LocalName	
#13 Context	
#14 Relevance	
#15 ActionType	
#16 D130_Form_Desc	
#17 ActionPhrase	
#18 AnswerOptions	

use strict;

&main(@ARGV);

sub main {
	if ($#ARGV != 2) {
		die "usage:  showlogic.pl source-file ouput-html-file title";
	}
	
	open (SRC, "<$ARGV[0]") or die "unable to open $ARGV[0]";
	my @lines = (<SRC>);
	close (SRC);
	
	open (OUT, ">$ARGV[1]") or die "unable to write to $ARGV[1]";
	

	print OUT  qq|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">|, "\n";
	print OUT  qq|<HTML>|, "\n";
	print OUT  qq|	<HEAD>|, "\n";
	print OUT  qq|		<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=iso-8859-1">|, "\n";
	print OUT  qq|	</HEAD>|, "\n";
	print OUT  qq|	<TITLE>LOINC View of $ARGV[2]</TITLE>|, "\n";
	print OUT  qq|<BODY>|, "\n";
	print OUT  qq|	<P ALIGN='center'><b>LOINC View of $ARGV[2]</b></P>|, "\n";
	print OUT  qq|	<TABLE border='1'>|, "\n";
#	print OUT  qq|		<tr><td width="2%"><b>#</b></td><td width="%15"><b>Context(1)</b></td><td width="15%"><b>Context(2)</b></td><td width='15%'><b>Prop/ time/ system/ scale</b></td><td width='20%'><b>Survey Question Text</b></td><td width='20%'><b>Answer List</b></td></tr>|, "\n";
	print OUT  qq|		<tr><td><b>#</b></td><td><b>Context(1)</b></td><td><b>Context(2)</b></td><td><b>Prop/ time/ system/ scale/ method</b></td><td><b>Var Name</b></td><td><b>Survey Question Text</b></td><td><b>Answer List</b></td></tr>|, "\n";
	
	my $count = 0;
	
	foreach (@lines) {
		chomp;
		next if (/^(RESERVED)|(COMMENT)/);
		next if (/^\s*$/);
		my @args = split(/\t/);
		
		++$count;
		
		print OUT  qq|		<tr><td>$count</td><td>| . &indent_context($args[13]) . qq|</td><td>$args[16]</td><td>| . &highlight($args[2],$args[3],$args[4],$args[5],$args[6]) . qq|</td><td>$args[12]</td><td>$args[17]</td><td>| . &answers($args[18]) . qq|</td></tr>|, "\n";
	}

	print OUT  qq|	</TABLE>|, "\n";
	print OUT  qq|</BODY>|, "\n";
	print OUT  qq|</HTML>|, "\n";
	
	close (OUT);
}

sub answers {
	my $arg = shift;
	
	my @args = split(/\|/,$arg);
	
	my $type = shift(@args);
	
	my $str;
	
	unless (@args) {
		# not a list
		$type = 'instructions'	if ($type eq 'nothing');
		$type = 'number' if ($type eq 'double');
		$str = "<font color='blue'><b>[Data type = </b>$type]</font>";
		return $str;
	}
	
	while (@args) {
		$str .= "[" . $args[0] . "] " . $args[1] . "<br />";
		shift(@args);
		shift(@args);
	}
	$str .= '&nbsp;';
	return $str;
}

sub indent_context {
	my $arg = shift;
	my @args = split(/\|/,$arg);
	my $count = 0;
	
	my $str = $args[0];
	shift(@args);
	
	while (@args) {
		$str .= "<ul><li>$args[0]";
		shift(@args);
		++$count;
	}
	for my $i (1 .. $count) {
		$str .= "</li></ul>";
	}
	return $str;	
}

sub highlight {
	my ($prop,$timetype,$syst,$scale,$method) = @_;
	my $str;
	
	if ($prop ne 'FIND') {
		$str .= "<font color='red'><b>$prop</b></font></br>";
	}
	else {
		$str .= "$prop</br>";
	}
	
	if ($timetype ne 'PT') {
		$str .= "<font color='red'><b>$timetype</b></font></br>";
	}
	else {
		$str .= "$timetype</br>";
	}
	
	if ($syst ne '^PATIENT') {
		$str .= "<font color='red'><b>$syst</b></font></br>";
	}
	else {
		$str .= "$syst</br>";
	}
	
	$str .= "$scale</br>$method";
	return $str;
}		
