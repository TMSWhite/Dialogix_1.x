# perl program to insert values into wave6users
# reads the first line to get the list of variable names

use strict;

my $varsline = <>;
chomp($varsline);
my @vars = split(/\t/,$varsline);
my $insertcmd = "INSERT INTO wave6users (" . join(", ",@vars) . ") VALUES ";

while (<>) {
	chomp;
	next if (/^\s*$/);
	s/\\/\//g;		# convert to UNIX notation for file paths
	my @args = split(/\t/);
	
	print $insertcmd . "('" . join("', '",@args) . "');\n";
}
