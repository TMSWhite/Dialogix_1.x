@echo Starting Dialogix version @@DIALOGIX.VERSION_MAJOR@@.@@DIALOGIX.VERSION_MINOR@@
@echo Copyright (c) 2000-2002 Thomas M. White, MD
@echo Licensed to @@LICENSE.STUDY_NAME@@ for @@LICENSE.STUDY_ALIAS@@ Study
@echo (@@LICENSE.GRANT_NAME@@: @@LICENSE.GRANT_TITLE@@)

@echo off

rem File for starting Dialogix server and browser

rem ----- Verify and Set Required Environment Variables ---------------------

if not "%JAVA_HOME%" == "" goto gotJavaHome

rem -- try to find JAVA_HOME using standard install directories --
if exist "c:\jdk1.3\bin\java.exe" set JAVA_HOME=c:\jdk1.3
if exist "c:\jdk1.3.1\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1
if exist "c:\jdk1.3.1_01\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1_01
if exist "c:\jdk1.3.1_02\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1_02
if exist "c:\jdk1.3.1_03\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1_03
if exist "c:\jdk1.4.0\bin\java.exe" set JAVA_HOME=c:\jdk1.4.0

if not "%JAVA_HOME%" == "" goto gotJavaHome
echo You must set JAVA_HOME to point at your Java Development Kit installation
echo for example:
echo    set JAVA_HOME=c:\jdk1.3.1
goto cleanup

:gotJavaHome
rem -- try to launch browser, using default locations and names --

set _NETSCAPE_="C:\Program Files\Netscape\Communicator\Program\netscape.exe"
set _IE_="C:\Program Files\Internet Explorer\IEXPLORE.EXE"

rem -- start server --
cd bin
start /MIN startup.bat %1 %2
cd ..
sleep 10

rem -- start browser, giving preference to Netscape --

if exist %_NETSCAPE_% goto launch_netscape
if exist %_IE_% goto launch_IE

:launch_netscape
%_NETSCAPE_% -browser "http://127.0.0.1:8080/@@DIALOGIX.START_DIR@@/"
goto cleanup

:launch_IE
%_IE_% "http://127.0.0.1:8080/@@DIALOGIX.START_DIR@@/"
goto cleanup

:cleanup
set _NETSCAPE_=
set _IE_=
set JAVA_HOME=

exit
