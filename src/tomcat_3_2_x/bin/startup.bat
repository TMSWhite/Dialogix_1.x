@echo off
rem A batch file to start\stop tomcat server.within JDK1.3

set JAVA_HOME=c:\jdk1.3

REM == assuming jdk1.3
set JL=c:\jdk1.3\lib
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
set CLASSPATH=%CLASSPATH%;%TL%\dialogix.jar;%TL%\jakarta-oro.jar;%TL%\bprsgaf.jar
REM == CLASSPATH FOR JAVAMAIL (send only) ==
REM set CLASSPATH=%CLASSPATH%;%TL%\activation.jar;%TL%\mailapi.jar;%TL%\smtp.jar

echo Using CLASSPATH=%CLASSPATH%

java -Dtomcat.home="%TH%" org.apache.tomcat.startup.Tomcat 
