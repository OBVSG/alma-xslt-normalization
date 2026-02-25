<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für den Bereich MARC 3XX.
      @title 3XX.xsl
  -->

  <!--
      Setze den ersten Indikator von `300` auf `#`.
      @_marcFields 300
  -->
  <xsl:template match="datafield[@tag='300']/@ind1">
    <xsl:attribute name="ind1">{' '}</xsl:attribute>
  </xsl:template>


  <!--
      Setze den zweiten Indikator von `300` auf `#`.
      @_marcFields 300
  -->
  <xsl:template match="datafield[@tag='300']/@ind2">
    <xsl:attribute name="ind2">{' '}</xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
