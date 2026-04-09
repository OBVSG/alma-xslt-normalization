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
      @_marcFields 240
  -->
  <xsl:template match="datafield[@tag='240']/@ind2">
    <xsl:attribute name="ind2">0</xsl:attribute>
  </xsl:template>

  <!--
      Ändere `240 $$F` auf `$$a`.
      @_marcFields 240
  -->
  <xsl:template match="datafield[@tag='240']/subfield[@code='F']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Ergänze `242 $$yger`, falls nicht vorhanden
      @_marcFields 242
  -->
  <xsl:template match="datafield[@tag='242']">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates />
      <xsl:if test="not(subfield[@code='y'])">
        <subfield code="y">ger</subfield>
      </xsl:if>
    </datafield>
  </xsl:template>

  <!--
      Setze `245 ind1`:

      - Wenn es `1XX $$a` im Datensatz gibt: `1`
      - Sonst: `0`
      @_marcFields 245
  -->
  <xsl:template match="datafield[@tag='245']/@ind1">
    <xsl:variable name="recCreator" select="../../datafield[starts-with(@tag,'1')]/subfield[@code='a']/text()" />
    <xsl:attribute name="ind1">{if ($recCreator) then '1' else '0'}</xsl:attribute>
  </xsl:template>

  <!--
      Setze `245 ind2` fix auf `0`. Nichtsortierzeichen werden [hier](#temp;datafield%5B@tag='245'%5D%5B@ind2%20ne%20'0'%5D/subfield%5B@code='a'%5D%5Bnot(starts-with(.,%20'%3C'))%5D/text();nil) gesetzt.

      @_marcFields 245
  -->
  <xsl:template match="datafield[@tag='245'][@ind2 ne '0']/@ind2">
    <xsl:attribute name="ind2">0</xsl:attribute>
  </xsl:template>

  <!--
      Bei fortlaufenden Ressourcen `245 $$n` löschen, wenn es nur `[...]` enthält.
      @_marcFields 245
  -->
  <xsl:template match="datafield[@tag='245']/subfield[@code='n'][.='[...]']">
    <xsl:param name="meta" tunnel="yes" />
    <xsl:choose>
      <xsl:when test="$meta('flags') = ('serial')" />
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Nichtsortierzeichen in `245 $$a` gemäß `ind2` setzen. `ind2` wird [hier](#temp;datafield%5B@tag='245'%5D%5B@ind2%20ne%20'0'%5D/@ind2;nil) auf `0` gesetzt.
      @_marcFields 245
  -->
  <xsl:template match="datafield[@tag='245'][@ind2 ne '0']/subfield[@code='a'][not(starts-with(., '&lt;'))]/text()">
    <xsl:text>{mrclib:nonFilingChars(., ../../@ind2)}</xsl:text>
  </xsl:template>

  <!--
      Setze Indikatoren für `246`
      - `24630 => 24610`
      - `24631 => 24611`
      - `24633 => 2463#`
      @_marcFields 246
  -->
  <xsl:template match="datafield[@tag='246']">
    <xsl:copy>
      <xsl:attribute name="tag" select="@tag" />
      <xsl:choose>
        <xsl:when test="@ind1 eq '3' and @ind2 eq '0'">
          <xsl:attribute name="ind1">1</xsl:attribute>
          <xsl:attribute name="ind2">0</xsl:attribute>
        </xsl:when>
        <xsl:when test="@ind1 eq '3' and @ind2 eq '1'">
          <xsl:attribute name="ind1">1</xsl:attribute>
          <xsl:attribute name="ind2">1</xsl:attribute>
        </xsl:when>
        <xsl:when test="@ind1 eq '3' and @ind2 eq '3'">
          <xsl:attribute name="ind1">3</xsl:attribute>
          <xsl:attribute name="ind2">{' '}</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="ind1" select="@ind1" />
          <xsl:attribute name="ind2" select="@ind2" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <!--
      Entferne `247`, wenn in `$$a` nichts steht.
      @_marcFields 247
  -->
  <xsl:template match="datafield[@tag='247'][not(subfield[@code='a']/text())]" />
</xsl:stylesheet>
