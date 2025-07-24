<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:config="http://www.obvsg.at/ns/xslt/config"
                xmlns:doc="http://www.obvsg.at/ns/xslt/doc"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:utils="http://www.obvsg.at/xslt/utils"
                exclude-result-prefixes="config doc fn xs"
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
    <xsl:variable name="testRoot"
                  select="$projectRoot || 'test/' " />

    <xsl:for-each select="$config/config:normalization">
      <xsl:variable name="distStylesheet"
                    select="$projectRoot || 'dist/' || @distName || '.xsl'" as="xs:string" />

      <!-- bundle the source code -->
      <xsl:result-document href="{$distStylesheet}">
        <xsl:apply-templates select="doc($projectRoot || @main)" />
      </xsl:result-document>

      <!-- bundle the tests -->
      <xsl:apply-templates select="doc($projectRoot || @testMain)">
        <xsl:with-param name="testDir"
                        select="$testRoot || @distName || '/'" />
        <xsl:with-param name="testFileName"
                        select="@distName || '.xspec'" />
        <xsl:with-param name="distStylesheet"
                        select="$distStylesheet" />
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>

  <!-- Templates for bundling stylesheets into one file -->
  <xsl:template match="xsl:stylesheet">
    <xsl:variable name="modulePaths" select="utils:getModules(.)" />
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
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

  <!-- transform tests for CI i. e. copy them to into a directory and use the bundled stylesheet -->
  <xsl:template match="x:description">
    <xsl:param name="distStylesheet" />
    <xsl:param name="testDir" />
    <xsl:param name="testFileName" />
    <xsl:variable name="xspecFile"
                  select="$testDir || $testFileName" />

    <xsl:result-document href="{$xspecFile}">
      <xsl:copy>
        <xsl:apply-templates select="node() | @*">
          <xsl:with-param name="distStylesheet" select="$distStylesheet" />
          <xsl:with-param name="testDir" select="$testDir" />
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="x:description/@stylesheet">
    <xsl:param name="distStylesheet" required="yes" />
    <xsl:attribute name="stylesheet">{$distStylesheet}</xsl:attribute>
  </xsl:template>

  <xsl:template match="x:import">
    <xsl:param name="testDir" />
    <xsl:param name="distStylesheet" required="yes" />
    <xsl:variable name="uriBaseInput">{base-uri() => replace("^file:", "") => replace("[^/]+$", "")}</xsl:variable>

    <xsl:sequence select="." />
    <xsl:apply-templates select="doc($uriBaseInput || @href)">
      <xsl:with-param name="distStylesheet" select="$distStylesheet" />
      <xsl:with-param name="testDir" />
      <xsl:with-param name="testFileName" select="$testDir || @href" />
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
