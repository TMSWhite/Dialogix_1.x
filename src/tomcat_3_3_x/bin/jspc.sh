#!/bin/sh
#
# $Id$

# Shell script to runt JspC


BASEDIR=`dirname $0`

$BASEDIR/tomcat.sh jspc "$@"


