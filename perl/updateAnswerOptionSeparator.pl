#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 

# Perl script to convert the AnswerOptionsSeparator from ';' to '|'
# usage:
#		perl updateAnswerOptionSeparator.pl < originalSchedule > convertedSchedule
# Does very simple substitition - all semicolons converted into bars.  No check for entity names

use strict;

foreach(@ARGV) {
	my @files = glob($_);

	foreach (@files) {
		open (SRC,$_)		or die("unable to open $_");
		my @lines = (<SRC>);	# read entire file
		close (SRC);
		open (OUT,">$_")	or die("unable to open $_ for writing");

		# Replace the old names with the new names throughout the file.
		foreach(@lines) {
			chomp;

			if (/^COMMENT|RESERVED/) {
				#if line begins with COMMENT or RESERVED, print it out unchanged
				print OUT qq|$_\n|;
			}
			elsif (/^(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*)$/) {
				my $concept = $1;
				my $internalName = $2;
				my $externalName = $3;
				my $dependencies = $4;
				my $questionOrEvalType = $5;
				my @rest = split(/\t/, $6);

				print OUT qq|$concept\t$internalName\t$externalName\t$dependencies\t$questionOrEvalType|;

				my $count = 0;

				# $readback
				# $questionOrEval
				# $answerOptions
				# $helpURL

				for my $src (@rest) {
					++$count;
					if ($count == 3) {
						$src =~ s/;/|/g;	# replace ';' with '|'
					}
					elsif ($count == 4) {
						$count = 0;	# reset after 4th option (helpURL)
					}
					print OUT qq|\t$src|;
				}
				print OUT qq|\n|;
			}
			else {
				print OUT qq|$_\n|;
			}
		}
	}
}
