<?xml version='1.0'?>

<!--
  Document  $WgDD: fglrx_man/fglrx_html.xsl,v 1.5 2007-06-02 12:51:31 dleidert Exp $
  Summary   XSLT stylesheet to convert XML sources into html pages.
  
  Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

	<xsl:import href="fglrx_html_stylesheet.xsl"/>

	<xsl:output method="html"
	            encoding="ISO-8859-1"
	            indent="yes"
	            doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
	            doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>

<!-- Paramaters -->

	<xsl:param name="admon.graphics" select="1"/>
	<xsl:param name="admon.style" select="''"/>
	<xsl:param name="html.stylesheet">
		<xsl:choose>
			<xsl:when test="not(/revhistory)">
				<xsl:value-of select="'fglrx_man.css'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<xsl:param name="index.on.type">1</xsl:param>
	<xsl:param name="make.single.year.ranges" select="1"/>
	<xsl:param name="make.year.ranges" select="1"/>
	<xsl:param name="segmentedlist.as.table" select="1"/>
	<xsl:param name="variablelist.as.table" select="0"/>
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

	<!--  add missing AUTHOR(S) section -->
	<xsl:template match="refentry">
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="refentryinfo//author">
				<xsl:apply-templates select="refentryinfo" mode="authorsect"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="refentryinfo" mode="authorsect">
		<div class="refsect1">
			<xsl:call-template name="language.attribute"/>
			<xsl:call-template name="anchor">
				<xsl:with-param name="conditional" select="0"/>
			</xsl:call-template>
			<h2>
				<xsl:text>AUTHOR</xsl:text>
				<xsl:if test="count(.//author)+count(.//othercredit)>1">
					<xsl:text>S</xsl:text>
				</xsl:if>
			</h2>
			<xsl:text>&#10;</xsl:text>
			<xsl:if test="count(.//author)>0">
				<p>
					<xsl:text>This manual page was written by </xsl:text>
					<xsl:for-each select=".//author">
						<xsl:if test="position() > 1">
							<xsl:choose>
								<xsl:when test="position() = last()">
									<xsl:text> and </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>, </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:apply-templates select="." mode="authorsect"/>
					</xsl:for-each>
					<xsl:text> for the Debian system (but may be used by others).</xsl:text>
				</p>
			</xsl:if>
			<xsl:if test="count(.//othercredit)>0">
				<p>
					<xsl:text>Contributions were derived from </xsl:text>
					<xsl:for-each select=".//othercredit">
						<xsl:if test="position() > 1">
							<xsl:choose>
								<xsl:when test="position() = last()">
									<xsl:text> and </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>, </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:apply-templates select="." mode="authorsect"/>
					</xsl:for-each>
					<xsl:text>.</xsl:text>
				</p>
			</xsl:if>
			<xsl:if test="count(.//editor)>0">
				<p>
					<xsl:text disable-output-escaping="yes">Edited by </xsl:text>
					<xsl:for-each select=".//editor">
						<xsl:if test="position() > 1">
							<xsl:choose>
								<xsl:when test="position() = last()">
									<xsl:text> and </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>, </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:apply-templates select="." mode="authorsect"/>
					</xsl:for-each>
					<xsl:text>.</xsl:text>
				</p>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="author|editor|othercredit" mode="authorsect">
		<span class="{name(.)}">
			<xsl:call-template name="anchor"/>
			<xsl:call-template name="person.name"/>
			<xsl:if test=".//email">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select=".//email"/>
			</xsl:if>
		</span>
	</xsl:template>
	
</xsl:stylesheet>
