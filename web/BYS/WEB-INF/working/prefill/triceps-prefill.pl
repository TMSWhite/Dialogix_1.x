#Perl script to prefill Triceps interviews
#/* ******************************************************** 
#** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
#** $Header$
#******************************************************** */ 
# 
#Usage:  perl triceps-prefill.pl
#
#Function:
#This script will create one set of .dat and .dat.evt files per subject per study
#These can then be put in the \usr\local\triceps\webapps\<study>\WEB-INF\working directory.
#At that point, they will be accessible in the RESTORE pull-down list, and should be listed by the desired display name.
#
#Expectations:  
#  triceps-prefill-info.txt:  a tab delimited file of studies with following format:
#    STUDY_TEMPLATE_FILE	STUDY_SUBJECT_FILE	STUDY_VAR_FOR_FILENAME	STUDY_VAR_FOR_DISPLAY_NAME
#  e.g.
#    BYS-Adult-template.txt	BYS-Adult-subjects.txt	Filename	FullHUID
#
#  STUDY_TEMPLATE_FILE:  contains initial .dat file created when opening a new Triceps schedule
#  STUDY_SUBJECT_FILE:  a tab delimited file with following format:
#     Line 1:  list of variable names.  e.g.
#       Cluster	LineID	PBY02	PBY03	FullHUID	G_NAME	G_AGE
#     Lines 2-n:  data for those variables.  e.g.
#       01	0002	0	0	01000200	Tom	7
#       01	0003	0	2	01000302	Sally	9
#       05	0004	0	2	05000402	Mike	14
#


#declare variables
use strict;
my (@studies, $study, @studyVars, @subjects, @varNames, $varName, @vars, $var);
my (@templateLines, $line, $studyTemplateFile, $studySubjectFile, $studyVarForFilename, $studyVarForDisplayName);
my ($varForFilenameIdx, $varForDisplayNameIdx);
my ($idx, $filename, $displayname);

# read in list of studies.
open(STUDIES,"triceps-prefill-info.txt") or die "Unable to open 'triceps-prefill-info.txt'";
@studies = (<STUDIES>);
close(STUDIES);

foreach $study (@studies) {
	
	# get the parameters
	chomp($study);
	@studyVars = split(/\t/,$study);
	$studyTemplateFile = shift(@studyVars);
	$studySubjectFile = shift(@studyVars);
	$studyVarForFilename = shift(@studyVars);
	$studyVarForDisplayName = shift(@studyVars);
	
	#read in default data from STUDY_TEMPLATE_FILE
	open(TEMPLATE,"$studyTemplateFile") or die "Unable to open '$studyTemplateFile'";
	@templateLines = (<TEMPLATE>);
	close(TEMPLATE);
	
	#create an array of subjects
	open(SUBJECTS,"$studySubjectFile") or die "Unable to open '$studySubjectFile'";
	@subjects = (<SUBJECTS>);
	close(SUBJECTS);
	
	#read list of variables from first line in STUDY_SUBJECT_FILE file
	$line = shift(@subjects);
	chomp($line);
	@varNames = split(/\t/,$line);
	
	#find position of $studyVarForFilename in array of varNames
	$idx = 0;	# counter
	$varForFilenameIdx = -1;
	foreach $varName (@varNames) {
		 if ($varName eq $studyVarForFilename) {
		 	$varForFilenameIdx = $idx;
		}
		++$idx;
	}
	($varForFilenameIdx != -1) or die "STUDY_VAR_FOR_FILENAME $studyVarForFilename not found in first line of STUDY_SUBJECT_FILE $studySubjectFile";
	
	#find position of $studyVarForDisplayName in array of varNames
	$idx = 0;	# counter
	$varForDisplayNameIdx = -1;
	foreach $varName (@varNames) {
		 if ($varName eq $studyVarForDisplayName) {
		 	$varForDisplayNameIdx = $idx;
		}
		++$idx;
	}	
	($varForDisplayNameIdx != -1) or die "STUDY_VAR_FOR_DISPLAY_NAME $studyVarForDisplayName not found in first line of STUDY_SUBJECT_FILE $studySubjectFile";
	
	#Now create .dat and .evt files for each subject in this study
	foreach $line  (@subjects)  {
		#strip return character off of end of line
		chomp($line);
		
		#make array of variable values from current line
	    @vars = split(/\t/,$line);
	    
	    #get STUDY_FILENAME and STUDY_DISPLAY_NAME from array of variables
	    $filename = $vars[$varForFilenameIdx];
	    $displayname = $vars[$varForDisplayNameIdx];
	    
	    #create new files, using binary UNIX mode
	    open(DAT,">$filename.dat");
	    binmode(DAT);
	    open(EVT,">$filename.dat.evt");
	    binmode(EVT);
	
	    # write all lines from STUDY_TEMPLATE_FILE
	    foreach $line  (@templateLines) {
	        print DAT $line;
	    }

	    # set the variable that controls the name that appears for working/suspended interviews
	    print DAT "RESERVED\t__TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS__\t$displayname\n";
	    	    
	    # add values for each variable
	    $idx = 0;
	    foreach $varName (@varNames) {
	        print DAT "\t$varName\t0\t0\t\t$vars[$idx]\t\n";
	        ++$idx;
	    }
	
	    close (DAT);
	    close (EVT);
	}
}

