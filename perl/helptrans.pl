#perl script to facilitate translation of Dialogix files
#goal - create editable HTML files

use strict;

&main(@ARGV);

sub main {
	if ($#ARGV != 2) {
		die "usage:  helptrans.pl source-file ouput-html-file title";
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
	print OUT  qq|	<P ALIGN='center'><b>Translation File for $ARGV[2]</b></P>|, "\n";
	print OUT  qq|	<TABLE border='1'>|, "\n";
	print OUT  qq|		<tr><td width="10%">#</td><td width='65%'>Question</td><td width='25%'>Answers</td></tr>|, "\n";
	
	my $count = 0;
	
	foreach (@lines) {
		chomp;
		next if (/^(RESERVED)|(COMMENT)/);
		my @args = split(/\t/);
		
		++$count;
		
		next if ($args[4] eq 'e');	# skip eval nodes
		
		print OUT  qq|		<tr><td>$count</td><td>$args[6]</td><td>| . &answers($args[7]) . qq|</td></tr>|, "\n";
	}

	print OUT  qq|	</TABLE>|, "\n";
	print OUT  qq|</BODY>|, "\n";
	print OUT  qq|</HTML>|, "\n";
	
	close (OUT);
}

sub answers {
	my $arg = shift;
	
	my @args = split(/\|/,$arg);
	
	shift(@args);
	
	my $str;
	
	while (@args) {
		$str .= "[" . $args[0] . "] " . $args[1] . "<br />";
		shift(@args);
		shift(@args);
	}
	$str .= '&nbsp;';
	return $str;
}
