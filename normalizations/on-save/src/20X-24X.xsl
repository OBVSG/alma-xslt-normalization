<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für den Bereich MARC 20X-24X.
      @title 20X-24X.xsl
  -->

  <!--
      Setze `240 ind1` auf `1`.
      @_marcFileds 240
  -->
  <xsl:template match="datafield[@tag='240']/@ind1">
    <xsl:attribute name="ind1">1</xsl:attribute>
  </xsl:template>

  <!--
      Setze `240 ind2` auf `0`.
      @_marcFileds 240
  -->
  <xsl:template match="datafield[@tag='240']/@ind2">
    <xsl:attribute name="ind2">0</xsl:attribute>
  </xsl:template>

  <!--
      Ändere `240 $$F` auf `$$a`.
  -->
  <xsl:template match="datafield[@tag='240']/subfield[@code='F']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Ergänze `242 $$yger`, falls nicht vorhanden
  -->
  <xsl:template match="datafield[@tag='242']">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates />
      <xsl:if test="not(subfield[@code='y'])">
        <subfield code="y">ger</subfield>
      </xsl:if>
    </datafield>
  </xsl:template>
</xsl:stylesheet>
