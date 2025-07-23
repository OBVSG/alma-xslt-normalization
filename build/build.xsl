<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:config="http://www.obvsg.at/ns/xslt/config"
                xmlns:doc="http://www.obvsg.at/ns/xslt/doc"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:utils="http://www.obvsg.at/xslt/utils"
                expand-text="yes"
                version="3.0">

  <xsl:output indent="yes" />
  <xsl:mode on-no-match="shallow-copy" />

  <xsl:param name="configFile" required="yes" />

  <xsl:template name="main">
    <xsl:variable name="config"
                  select="doc($configFile)/config:config/config:normalizations" />
    <xsl:variable name="projectRoot">{
      base-uri($config)
      => replace("^file:", "")
      => replace("[^/]+$", "")
    }</xsl:variable>
    <xsl:for-each select="$config/config:normalization">
      <xsl:result-document href="dist/{@distName}">
        <xsl:apply-templates select="doc($projectRoot || @master)" />
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="xsl:stylesheet">
    <xsl:variable name="modulePaths" select="utils:getModules(.)" />
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:comment>
      === IMPORTS STARTING HERE ===
   </xsl:comment>
      <xsl:for-each select="$modulePaths">
        <xsl:comment> START == Imported from {.} </xsl:comment>
        <xsl:apply-templates select="doc(.)/xsl:stylesheet/child::node()" />
        <xsl:comment> END == Imported from {.} </xsl:comment>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:include" />

  <xsl:template match="xsl:variable[starts-with(@select, 'doc(')]">
    <xsl:variable name="uriBase">{base-uri() => replace("^file:", "") => replace("[^/]+$", "")}</xsl:variable>
    <!-- Message werfen mit terminate=yes wenn doc nicht am Anfang -->
    <xsl:if test="matches(@select, '.+doc(')">
      <xsl:message terminate="yes">more than one call to 'doc(...)'?</xsl:message>
    </xsl:if>
    <xsl:variable name="docPath">{
      replace(@select, "^doc\('", "doc('" || $uriBase)
    }</xsl:variable>
    <xsl:variable name="docData">
      <xsl:evaluate xpath="$docPath" />
    </xsl:variable>
    <xsl:element name="xsl:variable">
      <xsl:attribute name="name">{@name}</xsl:attribute>
      <xsl:sequence select="$docData" />
    </xsl:element>
  </xsl:template>

  <xsl:function name="utils:getModules" as="xs:string*">
    <xsl:param name="stylesheetRoot" />
    <xsl:variable name="uriBase">{base-uri($stylesheetRoot) => replace("^file:", "") => replace("[^/]+$", "")}</xsl:variable>
    <xsl:variable name="modulePaths" as="xs:string*">
      <xsl:for-each select="$stylesheetRoot/xsl:include/@href">
        <xsl:sequence select="$uriBase || ." />
        <xsl:sequence select="utils:getModules(doc($uriBase || .)/xsl:stylesheet)" />
      </xsl:for-each>
    </xsl:variable>

    <xsl:sequence select="$modulePaths => distinct-values()" />
  </xsl:function>

</xsl:stylesheet>
