# Module to load a list of variables from ASCII file in format VAR=VAL

package Dialogix::Utils;

use strict;

BEGIN {
    use Exporter   ();
    use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    
    @ISA = qw(Exporter);

    # set the version for version checking
    $VERSION     = 1.00;

    @EXPORT      = qw(readPrefs);
    %EXPORT_TAGS = ( FIELDS => [ @EXPORT_OK, @EXPORT ] );

    # your exported package globals go here,
    # as well as any optionally exported functions
    @EXPORT_OK   = qw();
}
use vars @EXPORT_OK;

sub readPrefs(\%$) {
	my $Vars = shift;
	my $filename = shift;
	
	open (IN, "<$filename") or die "unable to open $filename to read runtime parameters";
	my @lines = (<IN>);
	close (IN);
	
	my $linenum=0;
	my @errs=();
	foreach my $line (@lines) {
		chomp($line);
		++$linenum;
		#expects format name=value
		if ($line =~ /^(.*?)\s*\#/) {
			$line = $1;	# allow comments
		}		
		next if ($line =~ /^\s*$/);	# allow blank lines

		if ($line =~ /^\s*(.+?)\s*=\s*(.+?)\s*$/) {
			my $var = $1;
			my $val = $2;
			if (defined($Vars->{$var})) {
				$Vars->{$var} = $val;
#				print "\tsetting $var=\"$Vars->{$var}\"\n";			
			}
			else {
				push @errs, "undefined var \"$var\" in [$filename:$linenum].";
			}
		}
		else {
			push @errs, "expected syntax VARNAME=VALUE [$filename:$linenum].  Got\n\t$line";
		}
	}
	if ($#errs > 0) {
		foreach (@errs) {
			print "ERR: $_\n";
		}
		die;
	}
	return $Vars;
}

1;	# module must return a true value
