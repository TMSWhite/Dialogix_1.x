#perl script to facilitate translation of Dialogix files
#goal - create editable HTML files

use strict;

&main(@ARGV);

sub main {
	if ($#ARGV != 4) {
		die "usage:  showlogic.pl source-file ouput-html-file title src_lang target_lang";
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
	print OUT  qq|	<TITLE>Logic File for $ARGV[2]</TITLE>|, "\n";
	print OUT  qq|<BODY>|, "\n";
	print OUT  qq|	<P ALIGN='center'><b>Translation File for $ARGV[2]</b></P>|, "\n";
	print OUT  qq|	<TABLE border='1'>|, "\n";
#	print OUT  qq|		<tr><td width="5%"><b>#</b></td><td width="5%"><b>Lang</b></td><td width="%15"><b>Variable Name</b></td><td width='40%'><b>Question</b></td><td width='20%'><b>Answers</b></td></tr>|, "\n";
	print OUT  qq|		<tr><td><b>#</b></td><td>Lang</td><td><b>Variable Name</b></td><td><b>Question</b></td><td><b>Answers</b></td></tr>|, "\n";	
	
	my $count = 0;
	my $rows = 0;
	
	# should I calculate the # of items on a screen first -- best way is via inst2xml.pl, but overly complex syntax
	
	foreach (@lines) {
		chomp;
		next if (/^(RESERVED)|(COMMENT)/);
		next if (/^\s*$/);
		my @args = split(/\t/);
		
		++$count;
		
		if ($args[4] eq 'e') {
#			print OUT  qq|		<tr><td>$count</td><td>$ARGV[3]</td><td>$args[1]</td><td><font color='blue'>[CALCULATED VALUE:]</font></br>$args[6]</td><td>&nbsp;</td></tr>|, "\n";
#			print OUT  qq|		<tr><td>$count</td><td>$ARGV[4]</td><td>$args[1]</td><td><font color='blue'>[CALCULATED VALUE:]</font></br>$args[6]</td><td>&nbsp;</td></tr>|, "\n";
		}
		else {
			++$rows;
			print OUT  qq|		<tr><td>$count</td><td>$ARGV[3]</td><td>$args[1]</td><td>$args[6]</td><td>| . &answers($args[7],1) . qq|</td></tr>|, "\n";
			print OUT  qq|		<tr><td>$count</td><td>$ARGV[4]</td><td>$args[1]</td><td>&nbsp;</td><td>| . &answers($args[7],0) . qq|</td></tr>|, "\n";
		}
	}

	print OUT  qq|	</TABLE>|, "\n";
	print OUT  qq|</BODY>|, "\n";
	print OUT  qq|</HTML>|, "\n";
	
	close (OUT);
	
	print "generated " . ($rows * 2) . " rows\n";
}

sub answers {
	my ($arg, $showmsg) = @_;
	
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
		if ($showmsg == 1) {
			$str .= "[" . $args[0] . "] " . $args[1] . "<br />";
		}
		else {
			$str .= "[" . $args[0] . "]<br />";
		}
		shift(@args);
		shift(@args);
	}
	$str .= '&nbsp;';
	return $str;
}
