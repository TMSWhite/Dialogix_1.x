@echo Starting Dialogix version @@DIALOGIX.VERSION_MAJOR@@.@@DIALOGIX.VERSION_MINOR@@
@echo Copyright (c) 2000-2002 Thomas M. White, MD
@echo Licensed to @@LICENSE.STUDY_NAME@@ for @@LICENSE.STUDY_ALIAS@@ Study
@echo (@@LICENSE.GRANT_NAME@@: @@LICENSE.GRANT_TITLE@@)

@echo off

rem File for starting Dialogix server and browser

rem ----- Verify and Set Required Environment Variables ---------------------

set _PATH=%PATH%
PATH=%PATH%;@@DIALOGIX.HOME@@\bin

if not "%JAVA_HOME%" == "" goto gotJavaHome

rem -- try to find JAVA_HOME using standard install directories --
if exist "c:\jdk1.3\bin\java.exe" set JAVA_HOME=c:\jdk1.3
if exist "c:\jdk1.3.1\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1
if exist "c:\jdk1.3.1_01\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1_01
if exist "c:\jdk1.3.1_02\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1_02
if exist "c:\jdk1.3.1_03\bin\java.exe" set JAVA_HOME=c:\jdk1.3.1_03
if exist "c:\jdk1.4\bin\java.exe" set JAVA_HOME=c:\jdk1.4
if exist "c:\jdk1.4.0\bin\java.exe" set JAVA_HOME=c:\jdk1.4.0

if not "%JAVA_HOME%" == "" goto gotJavaHome
echo You must set JAVA_HOME to point at your Java Development Kit installation
echo for example:
echo    set JAVA_HOME=c:\jdk1.3.1
goto cleanup

:gotJavaHome
echo Launching Dialogix using Java at %JAVA_HOME%
rem -- try to launch browser, using default locations and names --

set _NETSCAPE_="C:\Program Files\Netscape\Communicator\Program\netscape.exe"
set _IE_="C:\Program Files\Internet Explorer\IEXPLORE.EXE"

rem -- set Tomcat  variables --
set TOMCAT_HOME=@@DIALOGIX.HOME@@
set TOMCAT_INSTALL=@@DIALOGIX.HOME@@
set CATALINA_BASE=@@DIALOGIX.HOME@@
set CATALINA_HOME=@@DIALOGIX.HOME@@
set CATALINA_TMPDIR=@@DIALOGIX.HOME@@\temp

@rem -- start server --
cd @@DIALOGIX.HOME@@\bin
start /MIN startup.bat %1 %2
cd @@DIALOGIX.HOME@@
sleep 10

rem -- start browser, giving preference to IE (unfortunately) --

if exist %_IE_% goto launch_IE
if exist %_NETSCAPE_% goto launch_netscape

:launch_netscape
%_NETSCAPE_% -browser "http://127.0.0.1:@@HTTP.PORT@@/@@DIALOGIX.START_DIR@@/"
@REM %_NETSCAPE_% -browser "https://127.0.0.1:@@HTTPS.PORT@@/@@DIALOGIX.START_DIR@@/"
goto cleanup

:launch_IE
%_IE_% "http://127.0.0.1:@@HTTP.PORT@@/@@DIALOGIX.START_DIR@@/"
@REM %_IE_% "https://127.0.0.1:@@HTTPS.PORT@@/@@DIALOGIX.START_DIR@@/"
goto cleanup

:cleanup
set _NETSCAPE_=
set _IE_=
set JAVA_HOME=
set PATH=%_PATH%
set _PATH=
