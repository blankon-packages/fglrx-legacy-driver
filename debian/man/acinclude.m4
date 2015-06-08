dnl Document  $WgDD: fglrx_man/acinclude.m4,v 1.20 2006-12-15 22:28:29 dleidert Exp $
dnl Summary   Custom macros for the configure script.
dnl
dnl Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.
dnl
dnl Copying and distribution of this file, with or without modification,
dnl are permitted in any medium without royalty provided the copyright
dnl notice and this notice are preserved.


dnl @synopsis MP_PATH_DOCBOOK_XSL [--with-docbook-xsl-dir=DIR]
dnl
dnl @summary Search for the path to Norman Walsh's XSL stylesheet for manpages.
dnl
dnl Allow to specify the path to Norman Walsh's XSL stylesheets. If no path is
dnl specified, common directories are searched for this file. For Debian
dnl (where it is automatically detected), you could use:
dnl
dnl    --with-docbook-xsl-dir=/usr/share/xml/docbook/stylesheet/nwalsh
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-11-25
dnl @license AllPermissive
AC_DEFUN([MP_PATH_DOCBOOK_XSL], [
	
	dnl Let the user specify the path to Norman Walsh's XSL stylesheets ...
	AC_ARG_WITH(
		[docbook-xsl-dir],
		AC_HELP_STRING(
			[--with-docbook-xsl-dir@<:@=DIR@:>@],
			[Specify the path to Norman Walsh's XSL stylesheets. @<:@DIR=autodetect@:>@]
		),
		[PATH_DOCBOOK_XSL=$withval],
	)

	dnl .. or begin checking ...
	AC_ARG_VAR(
		[XMLCATALOG],
		[The 'xmlcatalog' binary with path. Use it to define or override the location of 'xmlcatalog'.]
	)
	AC_PATH_PROG([XMLCATALOG], [xmlcatalog])

	AC_ARG_VAR(
		[XML_CATALOG_FILE],
		[The default system catalog. Use it to define or override the systems catalog '/etc/xml/catalog'.]
	)
	if test -z $XML_CATALOG_FILE ; then
		XML_CATALOG_FILE="/etc/xml/catalog"
	fi

	dnl ... let's try to determine automatically ...
	dnl ... first check catalog and if successful, let's use the canonical URI ...
	if test -z $PATH_DOCBOOK_XSL -a $XMLCATALOG ; then
		if AC_RUN_LOG([$XMLCATALOG --noout "$XML_CATALOG_FILE" "http://docbook.sourceforge.net/release/xsl/current/" >&2]) ; then
			PATH_DOCBOOK_XSL="http://docbook.sourceforge.net/release/xsl/current"
		fi
	fi

	dnl ... second check a defined list of paths ...
	if test -z $PATH_DOCBOOK_XSL ; then
		db_xsl_dir_list="
			/usr/share/sgml/docbook/xsl-stylesheets
			/usr/share/sgml/docbook/stylesheet/xsl/nwalsh
			/usr/share/xml/docbook/stylesheet/nwalsh
			/usr/local/share/sgml/docbook/xsl-stylesheets
			/usr/local/share/sgml/docbook/stylesheet/xsl/nwalsh
			/usr/local/share/xml/docbook/stylesheet/nwalsh
			/opt/share/sgml/docbook/xsl-stylesheets
			$datadir/sgml/docbook/xsl-stylesheets
			$datadir/sgml/docbook/stylesheet/xsl/nwalsh
			$datadir/xml/docbook/stylesheet/nwalsh
		"
		for dir in $db_xsl_dir_list ; do
			if test -f $dir/catalog.xml ; then
				PATH_DOCBOOK_XSL=$dir
				break
			fi
		done
	fi
	
	dnl ... and if it still cannot be found, use an URL.
	if test -z $PATH_DOCBOOK_XSL ; then
		PATH_DOCBOOK_XSL="http://docbook.sourceforge.net/release/xsl/current"
	fi

	AC_MSG_CHECKING([for XSL stylesheet dir])
	AC_MSG_RESULT([$PATH_DOCBOOK_XSL])

	AC_SUBST([PATH_DOCBOOK_XSL])
]) # MP_PATH_DOCBOOK_XSL


dnl @synopsis MP_PROG_XSERVER [--with-xserver=STRING]
dnl
dnl @summary Try to determine the X-server, which is running.
dnl
dnl The manpages will only refer to X.org or XFree86 X-Server
dnl version. So let's try to determine, which server is running. Therefor we
dnl check for /usr(/X11R6)/bin/Xorg or /usr(/X11R6)/bin/XFree86 and depending
dnl on what we find, the server string is determined.
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-11-25
dnl @license AllPermissive
AC_DEFUN([MP_PROG_XSERVER],[

	dnl Specify, for which X-server we build the manpages.
	AC_ARG_WITH(
		[xserver],
		AC_HELP_STRING(
			[--with-xserver@<:@=@<:@Xorg|XFree86@:>@@:>@],
			[Specify, which X-server is used @<:@default=autodetect@:>@.]
		),
		[
		 if test -z $withval ; then
			 AC_CHECK_PROGS([PROG_XSERVER_STRING], [Xorg XFree86])
		 else
			 PROG_XSERVER_STRING=$withval
		 fi
		],
		[AC_CHECK_PROGS([PROG_XSERVER_STRING], [Xorg XFree86])]
	)

	if test "x$PROG_XSERVER_STRING" = "xXorg" ; then
		PROG_XSERVER_NAME="X.org"
		PROG_XSERVER_CONF="xorg.conf"
		PROG_XSERVER_CONFIG="xorgconfig"
	elif test "x$PROG_XSERVER_STRING" = "xXFree86" ; then
		PROG_XSERVER_NAME="XFree86"
		PROG_XSERVER_CONF="XF86Config-4"
		PROG_XSERVER_CONFIG="xf86config"
	else
		AC_MSG_ERROR([Unknown X-server.])
	fi

	AC_MSG_CHECKING([for X-server])
	AC_MSG_RESULT([$PROG_XSERVER_NAME])

	AC_SUBST([PROG_XSERVER_STRING])
	AC_SUBST([PROG_XSERVER_NAME])
	AC_SUBST([PROG_XSERVER_CONF])
	AC_SUBST([PROG_XSERVER_CONFIG])
]) # MP_PROG_XSERVER


dnl @synopsis MP_PATH_XSERVER_MAN \
dnl 	[--with-xserver-app-man-dir=DIR] \
dnl 	[--with-xserver-driver-man-dir=DIR] \
dnl 	[--with-xserver-file-man-dir=DIR]
dnl
dnl @summary Determine where the X-server manpages should be installed
dnl
dnl This is a simple macro to define the location, where the manpages for
dnl X-server applications and drivers shall be installed. A larger macro
dnl to get these paths is defined in XORG_MANPAGE_SECTIONS() in
dnl xorg-macros.m4. But because we only need to specify the path for Linux,
dnl we do not need it.
dnl
dnl An automatic detection should be added too.
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-11-25
dnl @license AllPermissive
AC_DEFUN([MP_PATH_XSERVER_MAN],[
	AC_REQUIRE([MP_PROG_XSERVER])

	AC_ARG_WITH(
		[xserver-app-man-dir],
		AC_HELP_STRING(
			[--with-xserver-app-man-dir@<:@=DIR@:>@],
			[Specify the path, where X application-manpages should be installed. @<:@DIR=$mandir/man1@:>@]
		),
		[
		 if test -z $withval ; then
			 PATH_XSERVER_MAN_APP="$mandir/man1"
		 else
			 PATH_XSERVER_MAN_APP=$withval
		 fi
		],
		[PATH_XSERVER_MAN_APP="$mandir/man1"]
	)

	AC_ARG_WITH(
		[xserver-driver-man-dir],
		AC_HELP_STRING(
			[--with-xserver-driver-man-dir@<:@=DIR@:>@],
			[Specify the path, where X driver-manpages should be installed. @<:@DIR=$mandir/man4@:>@]
		),
		[
		 if test -z $withval ; then
			 PATH_XSERVER_MAN_DRIVER="$mandir/man4"
		 else
			 PATH_XSERVER_MAN_DRIVER=$withval
		 fi
		],
		[PATH_XSERVER_MAN_DRIVER="$mandir/man4"]
	)

	AC_ARG_WITH(
		[xserver-file-man-dir],
		AC_HELP_STRING(
			[--with-xserver-file-man-dir@<:@=DIR@:>@],
			[Specify the path, where X file-manpages should be installed. @<:@DIR=$mandir/man5@:>@]
		),
		[
		 if test -z $withval ; then
			 PATH_XSERVER_MAN_FILE="$mandir/man5"
		 else
			 PATH_XSERVER_MAN_FILE=$withval
		 fi
		],
		[PATH_XSERVER_MAN_FILE="$mandir/man5"]
	)

	AC_MSG_CHECKING([for X-server application-manpages dir])
	AC_MSG_RESULT([$PATH_XSERVER_MAN_APP])
	AC_MSG_CHECKING([for X-server driver-manpages dir])
	AC_MSG_RESULT([$PATH_XSERVER_MAN_DRIVER])
	AC_MSG_CHECKING([for X-server file-manpages dir])
	AC_MSG_RESULT([$PATH_XSERVER_MAN_FILE])

	AC_SUBST([PATH_XSERVER_MAN_APP])
	AC_SUBST([PATH_XSERVER_MAN_DRIVER])
	AC_SUBST([PATH_XSERVER_MAN_FILE])
]) # MP_PATH_XSERVER_MAN


dnl @synopsis MP_PROG_XMLLINT
dnl
dnl @summary Determine if we can use the xmllint program
dnl
dnl This is a simple macro to define the location of xmllint (which can
dnl be overridden by the user) and special options to use.
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-11-25
dnl @license AllPermissive
AC_DEFUN([MP_PROG_XMLLINT],[
	AC_REQUIRE([PKG_PROG_PKG_CONFIG])

	AC_ARG_VAR(
		[XMLLINT],
		[The 'xmllint' binary with path. Use it to define or override the location of 'xmllint'.]
	)
	AC_PATH_PROG([XMLLINT], [xmllint])
	if test -z $XMLLINT ; then
		AC_MSG_ERROR(['xmllint' was not found. We cannot validate the XML sources.]) ;
	else
		AC_MSG_CHECKING([for xmllint >= 2.6.24])
		m4_ifdef(
			[PKG_CHECK_EXISTS],
			[
			 PKG_CHECK_EXISTS(
				 [libxml-2.0 >= 2.6.24],
				 [AC_MSG_RESULT([yes])],
				 [
				  AC_MSG_RESULT([no])
				  AC_MSG_ERROR(['xmllint' too old. We cannot validate the XML sources.])
				  XMLLINT=""
				 ]
			 )
			],
			[
			 if $PKG_CONFIG libxml-2.0 --atleast-version=2.6.24; then
				 AC_MSG_RESULT([yes])
			 else
				 AC_MSG_RESULT([no])
				 AC_MSG_ERROR(['xmllint' too old. We cannot validate the XML sources.])
				 XMLLINT=""
			 fi
			]
		)
	fi

	AC_ARG_VAR(
		[XMLLINT_FLAGS],
		[More options, which should be used along with 'xmllint', like e.g. '--nonet'.]
	)
	AC_MSG_CHECKING([for optional xmllint options to use])
	AC_MSG_RESULT([$XMLLINT_FLAGS])

	AC_SUBST([XMLLINT])
	AC_SUBST([XMLLINT_FLAGS])
]) # MP_PROG_XMLLINT


dnl @synopsis MP_PROG_XSLTPROC
dnl
dnl @summary Determine if we can use the xsltproc program
dnl
dnl This is a simple macro to define the location of xsltproc (which can
dnl be overridden by the user) and special options to use.
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-11-25
dnl @license AllPermissive
AC_DEFUN([MP_PROG_XSLTPROC],[

	AC_ARG_VAR(
		[XSLTPROC],
		[The 'xsltproc' binary with path. Use it to define or override the location of 'xsltproc'.]
	)
	AC_PATH_PROG([XSLTPROC], [xsltproc])
	if test -z $XSLTPROC ; then
		AC_MSG_ERROR(['xsltproc' was not found! We cannot proceed. See README.]) ;
	fi

	AC_ARG_VAR(
		[XSLTPROC_FLAGS],
		[More options, which should be used along with 'xsltproc', like e.g. '--nonet'.]
	)
	AC_MSG_CHECKING([for optional xsltproc options to use])
	AC_MSG_RESULT([$XSLTPROC_FLAGS])

	AC_SUBST([XSLTPROC])
	AC_SUBST([XSLTPROC_FLAGS])
]) # MP_PROG_XSLTPROC


dnl @synopsis MP_PROG_MAN
dnl
dnl @summary Determine if we can use the man program
dnl
dnl This is a simple macro to define the location of man (which can
dnl be overridden by the user).
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-11-25
dnl @license AllPermissive
AC_DEFUN([MP_PROG_MAN],[

	AC_ARG_VAR(
		[MAN],
		[The 'man' binary with path. Use it to define or override the location of 'man'.]
	)
	AC_PATH_PROG([MAN], [man])
	if test -z $MAN ; then
		AC_MSG_ERROR(['man' was not found. We cannot check the manpages for errors. See README.]) ;
	fi

	AC_SUBST([MAN])
]) # MP_PROG_MAN
