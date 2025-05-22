<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:x="http://www.jenitennison.com/xslt/xspec" expand-text="yes" version="3.0">
  <!--
      Wenn für ein Element kein Template vorhanden ist, wird es samt seinen Kindknoten
      in die Ausgabe kopiert. Ausnahme sind Kindknoten, für die explizite Regeln vorhanden
      sind.
  -->
  <xsl:output indent="yes" omit-xml-declaration="yes"/>
  <xsl:mode on-no-match="shallow-copy" />

  <xsl:template match="/">
    <xsl:variable name="rec">
      <xsl:apply-templates select="//marc:record" />
    </xsl:variable>
    <x:scenario label="!!! FIX SCENARIO LABEL !!!">
      <x:context>
        <xsl:sequence select="$rec" />
      </x:context>
      <x:expect label="!!! FIX EXPECT LABEL !!">
        <error>CHECK EXPECTED OUTPUT!</error>
        <xsl:sequence select="$rec" />
      </x:expect>
    </x:scenario>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node() | text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="marc:datafield[marc:subfield[@code='9']='P']" />
  <!-- template to copy attributes -->
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- Template to copy text nodes -->
  <xsl:template match="comment() | text() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>
</xsl:stylesheet>
