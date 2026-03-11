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

  <!--
      Generiere eine `337` aus der `338` wenn noch keine vorhanden ist.
      @_marcFileds 337 338
  -->
  <xsl:template match="datafield[@tag='338'][subfield[@code='b']/text()]">
    <xsl:variable name="mediaType" select="substring(subfield[@code='b'][1], 1, 1)" />
    <!--  Copy the field to the output -->
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>

    <xsl:if test="not(../datafield[@tag='337'][subfield[@code='b'][.=$mediaType]])">
      <datafield tag="337" ind1=" " ind2=" ">
        <subfield code="b">{$mediaType}</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>

  <!--
      Ergänze `\x` in `336`, `337` oder `338` `$$b`, wenn nicht vorhanden.
      @_marcFields 336 337 338
  -->
  <xsl:template match="datafield[@tag=('336', '337', '338')]/subfield[@code='8']">
    <subfield code="8">{.}{if (ends-with(., "\x")) then '' else '\x'}</subfield>
  </xsl:template>

  <!--
      Entferne `$$e` von `347`, wenn es "Region ..." lautet.

      Das kann zu einem leeren `datafield` führen. Dieses wird in `sort.xsl` entfernt.
      @_marcFields 347
  -->
  <xsl:template match="datafield[@tag='347']/subfield[@code='e'][.='Region ...']" />

  <!--
      Ändere `348##$$N` in `$$a`.

      Für den NAK ist in `$$N` ein CV hinterlegt, im Endefekt soll der Term dann aber in `$$a`.
      @_marcFields 348
  -->
  <xsl:template match="datafield[@tag='348']/subfield[@code='N']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Setze `362 ind1` fix auf "0".
      @_marcFields 362
  -->
  <xsl:template match="datafield[@tag='362']/@ind1">
    <xsl:attribute name="ind1">0</xsl:attribute>
  </xsl:template>

  <!--
      Setze `362 ind2` fix auf "#".
      @_marcFields 362
  -->
  <xsl:template match="datafield[@tag='362']/@ind2">
    <xsl:attribute name="ind2">{' '}</xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
