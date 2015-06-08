#!/bin/sh
#
# Document  $WgDD: fglrx_man/autogen.sh,v 1.9 2007-06-02 12:51:31 dleidert Exp $
# Summary   Auto-generate the fglrx_man package source.
#
# Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

set -e

## find aclocal, autoconf, autoheader and automake
ACLOCAL=${ACLOCAL:-aclocal}
if [ -z `which $ACLOCAL` ] ; then echo "Error. ACLOCAL=$ACLOCAL not found." >&2 && exit 1 ; fi 
AUTOCONF=${AUTOCONF:-autoconf}
if [ -z `which $AUTOCONF` ] ; then echo "Error. AUTOCONF=$AUTOCONF not found." >&2 && exit 1 ; fi 
AUTOMAKE=${AUTOMAKE:-automake}
if [ -z `which $AUTOMAKE` ] ; then echo "Error. AUTOMAKE=$AUTOMAKE not found." >&2 && exit 1 ; fi 

## find where automake is installed and get the version
AUTOMAKE_PATH=${AUTOMAKE_PATH:-`which $AUTOMAKE | sed 's|\/bin\/automake.*||'`}
AUTOMAKE_VERSION=`$AUTOMAKE --version | grep automake | awk '{print $4}' | awk -F. '{print $1"."$2}'`

## automake files we need to have inside our source
if [ $AUTOMAKE_VERSION = "1.7" ] ; then
	AUTOMAKE_FILES="missing mkinstalldirs install-sh"
else
	AUTOMAKE_FILES="missing install-sh"
fi

## our help output, shown using the -h|--help option
autogen_help() {
	echo "Usage: ./autogen.sh [ -h | --help ] [ -c | --copy ]"
	echo
	echo "-c, --copy     Copy files instead to link them."
	echo "-h, --help     Print this message."
	echo
	echo "Produces all files necessary to build the fglrx_man project files."
	echo "The files are linked by default, if you run it without an option."
	echo 
}

## check if $AUTOMAKE_FILES were copied/linked to our source
autogen_if_missing() {
	case "$1" in
		copy)
			command="cp"
		;;
		link)
			command="ln -s"
		;;
		*)
			echo "Error. autogen_if_missing() was called with unknown parameter $1." >&2
		;;
	esac
	
	for file in $AUTOMAKE_FILES ; do
		if [ ! -e "$file" ] ; then
			$command -f $AUTOMAKE_PATH/share/automake-$AUTOMAKE_VERSION/$file .
		fi
	done
}

## link/copy the necessary files to our source to prepare for a build
autogen() {
	case "$1" in
		copy)
			copyoption="-c"
		;;
		link)
		;;
		*)
			echo "Error. autogen() was called with unknown parameter $1." >&2
		;;
	esac
	$ACLOCAL
	$AUTOMAKE --gnu -a $copyoption
	$AUTOCONF
}

## the main function
case "$1" in
	-h | --help)
		autogen_help
		exit 0
	;;
	-c | --copy)
		autogen copy
	;;
	*)
		autogen link
	;;
esac

## ready to rumble
echo "Run ./configure with the appropriate options, then make and enjoy."

exit 0

