==== README.TXT ====
Dialogix version @@DIALOGIX.VERSION_MAJOR@@.@@DIALOGIX.VERSION_MINOR@@
Copyright © 2000-2002 Thomas M. White, MD
Licensed to @@LICENSE.STUDY_NAME@@ for @@LICENSE.STUDY_ALIAS@@ Study
(@@LICENSE.GRANT_NAME@@: 
@@LICENSE.GRANT_TITLE@@)
Installed to @@DIALOGIX.HOME@@

==== REQUIREMENTS ====
Dialogix requires Java, and runs on Windows 98, NT, ME, 2000 and XP systems.
A server version runs under Unix.

Dialogix has been designed to take as little space as possible.  It will
run well on a Pentium II 250MHz system with 64 MB of RAM, a 2 GB hard drive,
and a 640x480 or better screen.  We recommend an 800x600 or better screen.

==== INSTALLATION ====
In order to run Dialogix, you need two things:
(1) Java Development Kit
(2) Your personalized DIALOGIX SETUP FILE.

JAVA DEVELOPMENT KIT
This can be downloaded from http://java.sun.com/j2se/1.4/download.html, and
installed by following the directions found there.

DIALOGIX SETUP FILE
Dialogix uses the Inno Setup System (http://www.innosetup.com), a lovely
freeware system developed by Jordan Russell.

A personalized installer file has been created for you.  It is named
@@ZIP.NAME@@.exe.  
Simply double-click on this file and follow the instructions.

==== RUNNING DIALOGIX ====
Click on the Dialogix icon.  This will open a DOS window that displays a 
message that Dialogix is starting.  Two new windows will be opened, after 
which the initial window will be closed.

The most obvious window is the browser (either Netscape or Internet Explorer,
depending upon your system).  The starting page will be the home page for
your project.

A second, DOS, window will be visible on the task bar.  It has a title like
"C:\WINNT\system32\cmd.exe - startup.bat" and will contain a message like:

Using CLASSPATH=;..\lib\JAXP.JAR;..\lib\SERVLET.JAR;..\lib\PARSER.JAR;..\lib\WEB
SERVER.JAR;c:\jdk1.3\lib\tools.jar;..\lib\JASPER.JAR;..\lib\dialogix.jar;..\lib\
jakarta-oro.jar
Starting tomcat. Check logs/tomcat.log for error messages

This second window is the Java web server that Dialogix uses to communicate with 
the browser.  This server must be running for Dialogix to work propery.
Otherwise, nothing will happen when you press a button in the browser.

==== STOPPING DIALOGIX ====
Simply close both the browser window and the server window.  If the server 
window does not want to close, you can press CTRL-C, and click that you want
to stop the script.  Then you can type "exit" to close the DOS window.

==== UNINSTALLING DIALOGIX ====
Run the Uninstall program (named something like unins000.exe) in @@DIALOGIX.HOME@@.
Alternatively, you can delete the directory @@DIALOGIX.HOME@@.

==== BACKING UP DATA FILES ====
You can copy files needed for analysis from the following locations:

The incomplete data files are stored in
@@DIALOGIX.HOME@@\webapps\@@LICENSE.PACKAGE_DIR@@\WEB-INF\working\*.dat*

The completed files are also stored in
@@DIALOGIX.HOME@@\webapps\@@LICENSE.PACKAGE_DIR@@\WEB-INF\completed\*.jar

A copy of the completed files is also stored in
@@ARCHIVE.DIR@@\*.jar

If you choose to "suspend" files, they are placed in the following 
locations:
(1) @@DIALOGIX.HOME@@\webapps\@@LICENSE.PACKAGE_DIR@@\WEB-INF\completed\suspended*.jar
(2) @@ARCHIVE.DIR@@\suspended\*.jar



-------------------------------------------------------------------------------------
Thomas M. White, MD, MS, MA
tw176@columbia.edu
