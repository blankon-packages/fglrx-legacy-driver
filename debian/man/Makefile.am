# Document  $WgDD: fglrx_man/Makefile.am,v 1.35 2007-06-02 12:51:31 dleidert Exp $
# Summary   Makefile for the fglrx_man project. It converts the XML source
#           into manpages and installs them into the right location.
#
# Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

AUTOMAKE_OPTIONS = dist-bzip2 1.7

EXTRA_DIST = \
	CHIPLIST \
	NEWS.html \
	$(fglrx_man_src) \
	fglrx_man_history.xml \
	fglrx_html.xsl \
	fglrx_man.xsl \
	fglrx_man.css

CLEANFILES = \
	$(fglrxman1_DATA) \
	$(fglrxman1x_DATA) \
	$(fglrxman4x_DATA) \
	$(fglrxman5x_DATA) \
	$(fglrx_man_src:.xml=.html)

DISTCLEANFILES = \
	fglrx_man_entities.dtd \
	fglrx_html_stylesheet.xsl \
	fglrx_man_stylesheet.xsl 

MAINTAINERCLEANFILES = \
	aclocal.m4 \
	configure \
	install-sh \
	missing \
	mkinstalldirs \
	Makefile.in \
	NEWS.html \
	@PACKAGE@-@VERSION@.tar.gz \
	@PACKAGE@-@VERSION@.tar.bz2

DISTCHECK_CONFIGURE_FLAGS = \
	--enable-build-checks \
	--with-docbook-xsl-dir=http://docbook.sourceforge.net/release/xsl/current

VPATH += @builddir@

XMLLINT_FLAGS += --noout --path "$(VPATH)" --valid
XSLTPROC_FLAGS += --path "$(VPATH)"


fglrx_man_src = \
	fireglcontrol.1.xml \
	aticonfig.1x.xml \
	fgl_glxgears.1x.xml \
	fglrxinfo.1x.xml \
	fglrx_xgamma.1x.xml \
	fglrx.4x.xml \
	atiodcli.1x.xml \
	atiode.1x.xml

fglrxman1dir    = $(mandir)/man1
fglrxman1_DATA  = $(patsubst %.1.xml,%.1,$(filter %.1.xml,$(fglrx_man_src)))

fglrxman1xdir   = $(PATH_XSERVER_MAN_APP)
fglrxman1x_DATA = $(patsubst %.1x.xml,%.1x,$(filter %.1x.xml,$(fglrx_man_src)))

fglrxman4xdir   = $(PATH_XSERVER_MAN_DRIVER)
fglrxman4x_DATA = $(patsubst %.4x.xml,%.4x,$(filter %.4x.xml,$(fglrx_man_src)))

fglrxman5xdir   = $(PATH_XSERVER_MAN_FILE)
fglrxman5x_DATA = $(patsubst %.5x.xml,%.5x,$(filter %.5x.xml,$(fglrx_man_src)))

fglrxdocsdir    = $(datadir)/doc/fglrx_man
fglrxdocs_DATA  = $(fglrx_man_src:.xml=.html) fglrx_man.css AUTHORS CHIPLIST COPYING NEWS.html THANKS NEWS


% : fglrx_man.xsl %.xml
	@echo -e "\033[1mBuilding $*.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^


%.html : fglrx_html.xsl %.xml
	@echo -e "\033[1mBuilding $@.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) -o $@ $^

NEWS.html : fglrx_html.xsl fglrx_man_history.xml
	@echo -e "\033[1mBuilding $@.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) -o $@ $^


check-local:
	$(info "Correct any errors before making a distribution.")
if ENABLE_BUILD_CHECKS
	@echo -e "\033[1mChecking XML sources.\033[0m"
	$(XMLLINT) $(XMLLINT_FLAGS) $(fglrx_man_src) fglrx_man_history.xml
	@echo -e "\033[1mChecking manpages for issues.\033[0m"
	LANG=C MANWIDTH=80 $(MAN) $(addprefix ./,$(patsubst %.xml,%,$(fglrx_man_src))) > /dev/null
#	TODO: Add spell check:
#	ispell -d american -n ...groff files...
else
	$(info "Use --enable-build-checks to enable the check-target(s).")
endif

