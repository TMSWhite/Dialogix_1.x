# perl script for reading tab delimited instrument files and converting them to XML

use strict;
use IO::File;

my $dataTypes = {
	check => 'string',
	combo => 'string',
	combo2 => 'string',
	date => 'date',
	day => 'day',
	day_num => 'day_num',		# since start of year.
	double => 'number',
	hour => 'hour',
	list => 'string',
	list2 => 'string',
	memo => 'string',
	minute => 'minute',
	month => 'month',		# since name of the month
	month_num => 'month_num',
	nothing => 'string',
	password => 'string',
	radio => 'string',
	radio2 => 'string',
	radio3 => 'string',
	second => 'second',
	text => 'string',
	time => 'time',
	weekday => 'weekday',	# since name of weekday
	year => 'year',
	
	number => 'number',
	string => 'string',
};	

&main(@ARGV);

sub main {
	my @args = @_;
	
	foreach (@args) {
		foreach (glob($_)) {
			&inst2xml($_);
		}
	}
}

sub inst2xml {
	my $filename = shift;
	
	# read data	
	open(IN,$filename) or die "unable to read from $filename\n";
	
	my @src = (<IN>);
	chomp(@src);
	close (IN);
	
	# parse the lines
	my @lines;
	
	foreach (@src) {
		next if (/^\s*$/);
		if (/^RESERVED/) {
			push @lines, &parse_reserved($_);	# this pre-supposes that all reserveds must be parsed first -- isnt' this true in headers vs. body?
		}
		elsif (/^\s*COMMENT/) {
			push @lines, &parse_comment($_);	# XXX this removes the order dependencies
		}
		else {
			push @lines, &parse_node($_);
		}
	}
	
	# write them as XML (initially not taking advantage of Perl's XML / DOM features
	&write_xml($filename,\@lines);
}

sub write_xml {
	my ($filename,$rlines) = @_;
	my $base = &basename($filename);
	my @lines = @$rlines;
	
	open (OUT,">$filename.xml") or die "unable to write XML to $filename.xml\n";
	
	#write XML header
	print OUT qq|<?xml version="1.0" encoding="ISO-8859-1"?>|, "\n";
	print OUT qq|<dialogix_instrument src="$base">|, "\n";
	
	my $linenum = 0;
	foreach my $line (@lines) {
		# try to cheat by working recursively?
		my $type = lc($line->{'line_type'});
		++$linenum;
		
		print OUT "<$type linenum=\"$linenum\">\n";
		if ($type eq 'reserved') {
			print OUT "	<resname>$line->{'resname'}</resname>\n";
			print OUT "	<resval>$line->{'resval'}</resval>\n";
		}
		elsif ($type eq 'comment') {
			print OUT "	<commentval>$line->{'comment'}</commentval>\n";
		}
		else {
			print OUT "	<concept>$line->{'concept'}</concept>\n";
			print OUT "	<uniqueName>$line->{'uniqueName'}</uniqueName>\n";
			print OUT "	<displayName>$line->{'displayName'}</displayName>\n";
			print OUT "	<relevance>$line->{'relevance'}->{'rel_new'}</relevance>\n";
			print OUT "	<actionType>$line->{'qoreval'}->{'qoreval'}</actionType>\n";
			print OUT "	<dataType>$line->{'dataType'}</dataType>\n";
			print OUT "	<displayType>$line->{'displayType'}</displayType>\n";
			print OUT "	<validation>\n";
			print OUT "		<castto>$line->{'qoreval'}->{'returntype'}</castto>\n";
			print OUT "		<min>$line->{'qoreval'}->{'min'}</min>\n";
			print OUT "		<max>$line->{'qoreval'}->{'max'}</max>\n";
			print OUT "		<mask>$line->{'qoreval'}->{'mask'}</mask>\n";
			print OUT "		<regex>$line->{'qoreval'}->{'regex'}</regex>\n";
			print OUT "		<extras num=\"$line->{'qoreval'}->{'num_extras'}\">\n";
			my $rextras = $line->{'qoreval'}->{'extras'};
			my @extras = @$rextras;
			foreach my $extra (@extras) {
				print OUT "			<value>$extra</value>\n";
			}
			print OUT "	</extras>\n";
			print OUT "	</validation>\n";
			print OUT "	<num_hows>$line->{'num_hows'}</num_hows>\n";
			print OUT "	<hows>\n";
			my $rhows = $line->{'hows'};
			my @hows = @$rhows;
			foreach my $how (@hows) {
				print OUT "		<readback>$how->{'readback'}</readback>\n";
				print OUT "		<helpURL>$how->{'helpURL'}</helpURL>\n";
#				print OUT "		<actionType>$how->{'action'}->{'action_type'}</actionType>\n";
				print OUT "		<actionExp>$how->{'action'}->{'action_exp'}</actionExp>\n";
#				print OUT "		<actionOrig>$how->{'action'}->{'action_orig'}</actionOrig>\n";
				my $num_options = $how->{'answerChoices'}->{'num_options'};
				print OUT "		<numOptions>$num_options</numOptions>\n";
				if ($num_options > 0) {
					my $roptions = $how->{'answerChoices'}->{'options'};
					my @options = @$roptions;
					
					print OUT "		<options>\n";
					foreach my $option (@options) {
						print OUT "			<option count=\"$option->{'option_counter'}\">\n";
						print OUT "				<msg>$option->{'option_msg'}</msg>\n";
						print OUT "				<val>$option->{'option_val'}</val>\n";
					}
					print OUT "		</options>\n";
				}
			}
			print OUT "	</hows>\n";
		}
		print OUT "</$type>\n";
	}
	
	print OUT "</dialogix_instrument>\n";
	close (OUT);
	print "wrote XML to $filename.xml\n";
}

sub basename {
	my $arg = shift;
	
	if ($arg =~ /^(.*[\\\/])*(.*?)\.txt$/) {
		return $2;
	}
	else {
		return $arg;
	}
}

sub parse_reserved {
	my $line = shift;
	my @args = &deExcelize(split(/\t/,$line));
	return {
		line_type => 'RESERVED',
		resname => $args[1],
		resval => $args[2]
	};
}

sub parse_comments {
	my $line = shift;
	$line =~ s/\s*COMMENT\s*//;
	return {
		line_type => 'COMMENT',
		comment => $line,
	};
}

#COMMENT concept	internalName	externalName	dependencies	questionOrEvalType	readback[0]	questionOrEval[0]	answerChoices[0]	helpURL[0]	readback[1]	questionOrEval[0]	answerChoices[1]	helpURL[1]	languageNum	questionAsAsked	answerGiven	comment	timeStamp

sub parse_node {
	my $line = shift;
	my @args = &deExcelize(split(/\t/,$line));
	
	my $concept = shift(@args);
	my $uniqueName = shift(@args);
	my $displayName = shift(@args);
	my $relevance = &parse_relevance(shift(@args));
	my $qoreval = &parse_qoreval(shift(@args));
	
	# now a variable number of parameters, depending upon the number of languages encoded.
	
	my @hows;
	
	while (@args) {
		my $readback = shift(@args);
		my $action = &parse_action($qoreval->{'qoreval'},shift(@args));
		my $answerChoices = &parse_answerChoices(shift(@args));
		my $helpURL = &parse_helpURL(shift(@args));
		
		push @hows, {
			readback => $readback,
			action => $action,
			answerChoices => $answerChoices,
			helpURL => $helpURL,
		}
	}
	
	my $displayType = $hows[0]->{'answerChoices'}->{'displayType'};
	my $dataType = &calc_dataType($qoreval->{'returnType'},$displayType);
	
	return {
		line_type => 'NODE',
		node_src => $line,
		concept => $concept,
		uniqueName => $uniqueName,
		displayName => $displayName,
		relevance => $relevance,
		qoreval => $qoreval,
		dataType => $dataType,
		displayType => $displayType,
		num_hows => ($#hows + 1),
		hows => \@hows,
	};
}

sub calc_dataType {
	my ($returnType,$displayType) = @_;
	
	if (defined($returnType) && exists($dataTypes->{$returnType})) {
		return $dataTypes->{$returnType};
	}
	elsif (defined($displayType) && exists($dataTypes->{$displayType})) {
		return $dataTypes->{$displayType};
	}
	else {
		return "*badtype ($returnType, $displayType)*";
	}
}

sub parse_helpURL {
	my $arg = shift;
	
	# option to check integrity of URL
	
	return $arg;
}


sub parse_answerChoices {
	my $arg = shift;
	my @args = split(/\|/,$arg);
	
	my $type = lc(shift(@args));
	
	my @options;
	my $counter = 0;
	while (@args) {
		my $val = &parse_eqn(shift(@args));
		my $msg = &parse_html(shift(@args));
		
		++$counter;
		push @options, {
			option_counter => $counter,
			option_msg => $msg,
			option_val => $val,
		}
	}
	
	return {
		displayType => $type,
		num_options => $counter,
		options => \@options,
	};
}


sub parse_action {
	my ($type,$line) = @_;
	
	if ($type eq 'e') {
		return {
			action_type => 'eval',
			action_orig => $line,
			action_exp => &parse_eqn($line),
		};
	}
	else {
		return {
			action_type => 'question',
			action_orig => $line,
			action_exp => &parse_html($line),
		}
	}
}


#		];number;0;(tAGE-10);;77;88;99
sub parse_qoreval {
	my $arg = shift;
	my @args = split(/;/,$arg);
	
	my $qoreval = lc(shift(@args));
	my $returnType = lc(shift(@args));
	my $min = shift(@args);
	my $max = shift(@args);
	my $mask = shift(@args);
	my $regex = '';
	my $extras = \@args;
	my $num_extras = ($#args + 1);
	
	return {
		qoreval_full => $arg,
		qoreval => $qoreval,
		returntype => $returnType,
		min => $min,
		max => $max,
		mask => $mask,
		regex => $regex,
		num_extras => $num_extras,
		extras => $extras,
	};
}


sub parse_relevance {
	my $arg = shift;
	my $eqn = &parse_eqn($arg);
	
	return {
		rel_orig => $arg,
		rel_new => $eqn,
	};
}

sub parse_eqn {
	my $arg = shift;
	
	# this gives the opportunity to convert a string to MathML, or to replace >= / ==, etc with less dangerous characters
	
	$arg =~ s/==/ eq /g;
	$arg =~ s/>=/ ge /g;
	$arg =~ s/>/ gt /g;
	$arg =~ s/<=/ le /g;
	$arg =~ s/</ lt /g;	
	$arg =~ s/!=/ ne /g;
	$arg =~ s/\&\&/ and /g;
	$arg =~ s/\&/ _and_ /g;
	$arg =~ s/\|\|/ or /g;
	$arg =~ s/\|/ _or_ /g;
	$arg =~ s/=/ _eq_ /g;
	
	$arg =~ s/  / /g;
	
	return $arg;
}

sub parse_html {
	my $arg = shift;
	
	# could do JTidy equivalent here, if really daring!  This will be needed for badly formed HTML!
	
	my $exp = $arg;
	
	$exp =~ s/(.*?)`(.*?)`/$1<eval>$2<\/eval>/g;
	
	
	
	return $exp;
}

sub deExcelize {
	my @args = @_;
	my @fixed;
	
	foreach my $arg (@args) {
		if ($arg =~ /^\s*"(.*)"\s*$/) {
			$arg = $1;
			$arg =~ s/""/"/g;
		}
		push @fixed, $arg;
	}
	return @fixed;
}
