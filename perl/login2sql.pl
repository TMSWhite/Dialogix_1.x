# convert tab delimited to MySql

use strict;

my ($db, $table, $user, $passwd) = ('dialogix_users', 'wave6users', 'javauser', 'javadude');

   
print "GRANT ALL PRIVILEGES ON *.* TO $user\@localhost IDENTIFIED BY '$passwd' WITH GRANT OPTION;\n";
print "create database $db;\n";
print "use $db;\n";
print "CREATE TABLE $table (\n";
print "	username varchar(25) NOT NULL default '',\n";
print "	password varchar(25) NOT NULL default '',\n";
print "	filename varchar(100) NOT NULL default '.',\n";
print "	instrument varchar(100) NOT NULL default '',\n";
print "	status varchar(20) NOT NULL default 'unstarted',\n";
print "	startingStep varchar(5) NOT NULL default '0',\n";
print "	_clinpass varchar(20) NOT NULL default '',\n";
print "	Dem1 varchar(20) NOT NULL default '',\n";
print "	lastAccess varchar(30) NOT NULL default '',\n";
print "	currentStep varchar(40) NOT NULL default '',\n";
print "	currentIP varchar(40) NOT NULL default '',\n";
print "	lastAction varchar(15) NOT NULL default '',\n";
print "	sessionID varchar(40) NOT NULL default '',\n";
print "	browser varchar(200) NOT NULL default '',\n";
print "	statusMsg varchar(35) NOT NULL default ''\n";
print "	);\n";

while (<>) {
	chomp;
	next if (/^\s*$/);
	s/\\/\//g;
	my @args = split(/\t/);
	
	push @args, ('','','','','','','');
	
	print "INSERT INTO wave6users VALUES ('" . join("', '",@args) . "');\n";
}
