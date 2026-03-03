<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für den Bereich MARC 6XX.
      @title 6XX.xsl
  -->

  <!--
      Verschiebe `655` mit `$$2gnd-music` nach `348`
      @_marcFields 655 348
  -->
  <xsl:template match="datafield[@tag='655'][subfield[@code='2'][.='gnd-music']]">
    <datafield tag="348" ind1=" " ind2=" ">
      <xsl:apply-templates />
    </datafield>
  </xsl:template>

  <!--
      Entferne `655` ohne `$$a` oder `$$N`. `$$N` enthält CV für den NAK, wird dann [hier](#temp;datafield%5B@tag='655'%5D/subfield%5B@code='N'%5D/@code;nil) in `$$a` umgewandelt.
      @_marcFields 655
  -->
  <xsl:template match="datafield[@tag='655'][not(subfield[@code=('a', 'N')]/text())]" />

  <!--
      Ändere `655 $$N` auf `$$a`.
      @_marcFields 655
  -->
  <xsl:template match="datafield[@tag='655']/subfield[@code='N']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Setze `655 ind2` auf "7", wenn es ein `$$2` gibt.

        changeSecondIndicator "655" to "7" if (exists "655.{-,*}.2")
      @_marcFields 655
  -->
  <xsl:template match="datafield[@tag='655'][subfield[@code='2']/text()]/@ind2">
    <xsl:attribute name="ind2">7</xsl:attribute>
  </xsl:template>



</xsl:stylesheet>
