<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:utils="http://www.obvsg.at/xslt/utils" expand-text="yes" version="3.0">

  <xsl:output indent="yes" />
  <xsl:mode on-no-match="shallow-copy" />

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
