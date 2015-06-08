dnl Document  $WgDD: fglrx_man/configure.ac,v 1.25 2007-06-26 11:58:23 dleidert Exp $
dnl Summary   Configure script for the fglrx_man project.
dnl
dnl Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.
dnl All rights reserved.
dnl
dnl This file is free software. The copyright owner gives unlimited
dnl permission to copy, distribute and modify it.

dnl Inititlize the package and the source.
AC_INIT([fglrx-driver],[8.32.5],[http://bugs.debian.org/fglrx-driver])
AM_INIT_AUTOMAKE([fglrx-driver-man], AC_PACKAGE_VERSION)
AC_REVISION($Revision: 1.25 $)

AC_C_BIGENDIAN

dnl Initialize any configure options.
AC_ARG_ENABLE(
	[build-checks],
	AC_HELP_STRING(
		[--enable-build-checks],
		[enable the checks in the check-target (rewuires more applications) @<:@default=no (yes for distcheck)@:>@]
	),
	[],
	[enable_build_checks=no]
)
AM_CONDITIONAL([ENABLE_BUILD_CHECKS], [test "x$enable_build_checks" != "xno"])

dnl Initialize the package and product strings.
dnl Allow to override the ATI driver version.
ATI_DRIVER_NAME="ATI Linux driver"
ATI_DRIVER_VERSION="$VERSION"
dnl Shall be set to "ATI Linux driver documentation" when used for official
dnl ATI packages.
AC_ARG_VAR(
	[DRIVER_PACKAGE],
	[The package string you want to have at the top of the manpage instead
	 of the default string @<:@default="Debian GNU/Linux fglrx-driver package"@:>@.]
)
if test "x$DRIVER_PACKAGE" = "x"; then
	ATI_DRIVER_PACKAGE="Debian GNU/Linux fglrx-driver package"
else
	ATI_DRIVER_PACKAGE=$DRIVER_PACKAGE
	AC_MSG_NOTICE([DRIVER_PACKAGE has been overwritten with: '$DRIVER_PACKAGE'])
fi
AC_SUBST([ATI_DRIVER_NAME])
AC_SUBST([ATI_DRIVER_VERSION])
AC_SUBST([ATI_DRIVER_PACKAGE])

dnl Initialize paths.
if test "$prefix" = "NONE" ; then prefix=/usr/local ; fi
AC_MSG_CHECKING([for prefix.])
AC_MSG_RESULT([$prefix])
AC_MSG_CHECKING([for datadir])
AC_MSG_RESULT([$datadir])
AC_MSG_CHECKING([for mandir])
AC_MSG_RESULT([$mandir])

dnl Change the location if necessary, e.g. for Debian.
AC_ARG_VAR(
	[LICENSE_FILE],
	[
	 Change the place, where the license can be found.
	 @<:@default="$datadir/doc/fglrx_man/COPYING"@:>@
	]
)
if test -z "$LICENSE_FILE"; then
	eval eval dt=`echo $datadir`
	PACKAGE_LICENSE_FILE="$dt/doc/fglrx_man/COPYING"
else
	PACKAGE_LICENSE_FILE=$LICENSE_FILE
	AC_MSG_NOTICE([LICENSE shall be found at... $LICENSE_FILE])
fi
AC_SUBST([PACKAGE_LICENSE_FILE])

dnl Initialize packages and program search.
AC_PROG_INSTALL
MP_PROG_XSLTPROC
if test "x$enable_build_checks" != "xno" ; then
MP_PROG_XMLLINT
MP_PROG_MAN
fi
MP_PATH_DOCBOOK_XSL

dnl Determine X stuff.
MP_PROG_XSERVER
MP_PATH_XSERVER_MAN

dnl Parse and output files.
AC_CONFIG_FILES([Makefile fglrx_man_entities.dtd fglrx_html_stylesheet.xsl fglrx_man_stylesheet.xsl])
AC_OUTPUT
