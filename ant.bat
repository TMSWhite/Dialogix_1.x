REM makefile for building Dialogix using Ant

REM set JAVA_HOME=c:\j2sdk1.4.0
set JAVA_HOME=c:\jdk1.3
set ANT_HOME=c:\apache\ant

call %ANT_HOME%\bin\ant.bat %1 %2 %3 %4 %5
