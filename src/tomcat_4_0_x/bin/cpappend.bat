rem ---------------------------------------------------------------------------
rem Append a path onto the CLASSPATH
rem
rem $Id$
rem ---------------------------------------------------------------------------

rem Get remaining unshifted command line arguments and save them in the
set CMD_LINE_ARGS=%1
shift
:setArgs
if ""%1""=="""" goto doneSetArgs
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setArgs
:doneSetArgs

