@echo off
rem A batch file to start\stop tomcat server.within JDK1.3

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
rem -- set classpath and launch Tomcat

REM == assuming jdk1.3
set JL=%JAVA_HOME%\lib
set TH=C:\usr\local\dialogix
set TH=..
set TL=..\lib

set CLASSPATH=
REM == CLASSPATH FOR COCOON ==
REM set CLASSPATH=%CLASSPATH%;%TL%\XERCES_1_2.JAR;%TL%\XALAN_1_2_D02.JAR;%TL%\FOP_0_15_0.JAR;%TL%\COCOON.JAR;%TL%\BSF.JAR;%TL%\BSFENGINES.JAR;%TL%\TURBINE-POOL.JAR;%TL%\W3C.JAR
REM == CLASSPATH FOR TOMCAT ==
set CLASSPATH=%CLASSPATH%;%TL%\JAXP.JAR;%TL%\SERVLET.JAR;%TL%\PARSER.JAR;%TL%\WEBSERVER.JAR;%JL%\tools.jar;%TL%\JASPER.JAR
REM == CLASSPATH FOR SSL ==
REM set CLASSPATH=%CLASSPATH%;%TL%\JSSE.JAR;%TL%\JNET.JAR;%TL%\JCERT.JAR
REM == CLASSPATH FOR dialogix ==
set CLASSPATH=%CLASSPATH%;%TL%\dialogix.jar;%TL%\jakarta-oro.jar
REM == CLASSPATH FOR JAVAMAIL (send only) ==
REM set CLASSPATH=%CLASSPATH%;%TL%\activation.jar;%TL%\mailapi.jar;%TL%\smtp.jar
REM == CLASSPATH FOR CLOUDSCAPE ==
REM set CLASSPATH=%CLASSPATH%;%TL%\cloudscape.jar

echo Using CLASSPATH=%CLASSPATH%

java -Dtomcat.home="%TH%" org.apache.tomcat.startup.Tomcat %1 %2

:cleanup
set _NETSCAPE_=
set _IE_=
set JAVA_HOME=
