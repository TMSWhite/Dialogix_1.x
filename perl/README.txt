README FILE for DIALOGIX

To process the Dialogix files from /usr/local/dialogix/webapps/@@LICENSE.STUDY_ALIAS@@/WEB-INF/*,
run these two commands command from a DOS prompt:

cd \Dialogix\@@LICENSE.STUDY_ALIAS@@\perl
process_files.bat > dialogix.log 2> dialogix.err

The Dialogix.log file will list all of the processing which occurred. 
The Dialogix.err file will list any warnings or errors.

Many new files will be created in the /Dialogix/@@LICENSE.STUDY_ALIAS@@/data/ directories
  /analysis -- the SPSS and SAS import files
  /instruments -- post-processing of instruments, including tables which can be loaded to mySql


If this does not work, the most likely cause is the the file could not find Jar.exe.  Make sure you have installed
Sun's Java JDK.  You may also need to edit \Dialogix\@@LICENSE.STUDY_ALIAS@@\perl\_study.conf to change the line 
starting with:
  JAR =
so that the value to the right of the equals sign is the path to the location of Jar.exe on the hard drive.