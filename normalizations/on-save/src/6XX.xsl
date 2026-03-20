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
  <xsl:template
    match="datafield[@tag='655'][not(subfield[@code=('a', 'N')]/text())]" />

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

  <!--
      Füge bei `689X#` am Anfang ein `$$5AT-OBV` hinzu, wenn es nur `$$5` im Feld gibt.
      @_marcFields 689
  -->
  <xsl:template
    match="datafield[@tag='689'][@ind2=' '][subfield[@code='5']][not(subfield[not(@code='5')])]">
    <datafield tag="689" ind1="{@ind1}" ind2="{@ind2}">
      <subfield code="5">AT-OBV</subfield>
      <xsl:apply-templates select="subfield[not(.='AT-OBV')]" />
    </datafield>
  </xsl:template>

  <!--
      Lösche `$$5` aus `689`, wenn es ein `$$a` gibt. Wenn ein Deskriptor (`$$a`) vorhanden ist,
      dann hat `$$5` dort nichts verloren.
      @_marcFields 689
  -->
  <xsl:template match="datafield[@tag='689'][subfield[@code='a']]/subfield[@code='5']" />

  <!--
      Ändere `689XX$$Z` auf `$$a`.

      In `$$Z` gibt es eine CV-Liste. Dadurch eingefügte Terme sollen beim Speichern dann in `$$a` stehen.
      @_marcFields 689
  -->
  <xsl:template match="datafield[@tag='689']/subfield[@code='Z']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

 </xsl:stylesheet>
