<?xml version='1.0'?>

<!--
  Document  $WgDD: fglrx_man/fglrx_man.xsl,v 1.31 2007-06-02 12:51:31 dleidert Exp $
  Summary   XSLT stylesheet to convert XML sources into manpages.
  
  Copyright (C) 2005, 2006 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns="http://www.w3.org/TR/xhtml1/transitional"
                exclude-result-prefixes="#default">

	<xsl:import href="fglrx_man_stylesheet.xsl"/>

<!-- Paramaters -->

	<xsl:param name="make.single.year.ranges" select="1"/>
	<xsl:param name="make.year.ranges" select="1"/>
	<xsl:param name="man.base.dir" select="''"/>
	<xsl:param name="man.charmap.enabled" select="1"/>
	<xsl:param name="man.charmap.use.subset" select="0"/>
	<xsl:param name="man.hyphenate.computer.inlines" select="0"/>
	<xsl:param name="man.hyphenate.filenames" select="0"/>
	<xsl:param name="man.hyphenate.urls" select="0"/>
	<xsl:param name="man.segtitle.suppress" select="1"/>
	<xsl:param name="man.subdirs.enabled" select="0"/>
	<xsl:param name="refentry.manual.profile.enabled" select="1"/>
	<xsl:param name="refentry.manual.profile">($info/title)[1]/node()</xsl:param>
	<xsl:param name="variablelist.term.break.after">
		<xsl:choose>
			<xsl:when test="//refentry[@id='fglrx_4x' or @id='fgl_glxgears_1x']">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<xsl:param name="variablelist.term.separator">
		<xsl:choose>
			<xsl:when test="//refentry[@id='fglrx_4x' or @id='fgl_glxgears_1x']">
				<xsl:value-of select="''"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="', '"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

<!-- Customization layer -->

	<!-- commands, applications and package should be bold -->
	<xsl:template match="application|package">
		<xsl:if test="$man.hyphenate.computer.inlines = 0">
			<xsl:call-template name="suppress.hyphenation"/>
		</xsl:if>
		<xsl:apply-templates mode="bold" select="."/>
	</xsl:template>

	<!-- varnames in options should be bold (mainly for driver manpage) -->
	<xsl:template match="varname">
		<xsl:choose>
			<xsl:when test="parent::option">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- handle tags/sgmltags -->
	<xsl:template match="tag|sgmltag">
		<xsl:param name="class">
			<xsl:choose>
				<xsl:when test="@class">
					<xsl:value-of select="@class"/>
				</xsl:when>
				<xsl:otherwise>element</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!-- first let's see, if we need an opening symbol/string -->
		<xsl:choose>
			<xsl:when test="$class='element' or $class='emptytag' or $class='starttag'">
				<xsl:text><![CDATA[<]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='endtag'">
				<xsl:text><![CDATA[</]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='genentity'">
				<xsl:text><![CDATA[&]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='numcharref'">
				<xsl:text><![CDATA[&#]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='paramentity'">
				<xsl:text><![CDATA[%]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='pi' or $class='xmlpi'">
				<xsl:text><![CDATA[<?]]></xsl:text>
			</xsl:when>
		</xsl:choose>
		<!-- now let's see, if we have a namespace -->
		<!-- maybe only apply it for tags? test needs to be added in this case -->
		<xsl:if test="@namespace">
			<xsl:value-of select="@namespace"/>
			<xsl:text>:</xsl:text>
		</xsl:if>
		<!-- and now close all possible tags -->
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="$class='element'">
				<xsl:text><![CDATA[ ... >]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='endtag' or $class='pi' or $class='starttag'">
				<xsl:text><![CDATA[>]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='emptytag'">
				<xsl:text><![CDATA[/>]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='genentity' or $class='numcharref' or $class='paramentity'">
				<xsl:text><![CDATA[;]]></xsl:text>
			</xsl:when>
			<xsl:when test="$class='xmlpi'">
				<xsl:text><![CDATA[?>]]></xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
