#perl script to facilitate translation of Dialogix files
#goal - create editable HTML files

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
	print OUT  qq|	<TITLE>Translation File for $ARGV[2]</TITLE>|, "\n";
	print OUT  qq|<BODY>|, "\n";
	print OUT  qq|	<P ALIGN='center'><b>Logic File for $ARGV[2]</b></P>|, "\n";
	print OUT  qq|	<TABLE border='1'>|, "\n";
	print OUT  qq|		<tr><td width="5%"><b>#</b></td><td width="%15"><b>Variable Name</b></td><td width="15%"><b>Relevance</b></td><td width='40%'><b>Question</b></td><td width='20%'><b>Answers</b></td></tr>|, "\n";
	
	my $count = 0;
	
	foreach (@lines) {
		chomp;
		next if (/^(RESERVED)|(COMMENT)/);
		my @args = split(/\t/);
		
		++$count;
		
#		next if ($args[4] eq 'e');	# skip eval nodes
		
		if ($args[4] eq 'e') {
			print OUT  qq|		<tr><td>$count</td><td>$args[1]</td><td>$args[3]</td><td><font color='blue'>[calculated value]</font></td><td>$args[6]</td></tr>|, "\n";
		}
		else {
			print OUT  qq|		<tr><td>$count</td><td>$args[1]</td><td>$args[3]</td><td>$args[6]</td><td>| . &answers($args[7]) . qq|</td></tr>|, "\n";
		}
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
