#! /bin/sh
#
# $Id$

# Shell script to shutdown the server

BASEDIR=`dirname $0`

$BASEDIR/tomcat.sh stop $@


