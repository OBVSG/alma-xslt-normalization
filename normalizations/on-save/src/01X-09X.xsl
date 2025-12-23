<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
    Normalisierungen für die Felder `01X-09X`.
  -->

  <!--
      Entferne die Striche aus der ISBN in `020##$$a`
      @_marcFields 020
  -->
  <xsl:template match="datafield[@tag='020']/subfield[@code='a']">
    <subfield code="a">{replace(., "-", "")}</subfield>
  </xsl:template>

  <!--
      Entferne "Bestellnummer" bzw. "Best.-Nr." aus `028$$a` und füge ein entsprechendes `$$bBestellnummer` hinzu,
      sofern noch nicht vorhanden.
      @_marcFields 028
  -->
  <xsl:template match="datafield[@tag='028']/subfield[@code='a'][starts-with(., 'Bestellnummer') or starts-with(., 'Best.-Nr.')]">
    <subfield code="a">{replace(., "^(Bestellnummer|Best\.-Nr\.):? *", "")}</subfield>
    <xsl:if test="not(../subfield[@code='q'])">
      <subfield code="q">Bestellnummer</subfield>
    </xsl:if>
  </xsl:template>

  <!--
      Setze zweiten Indikator von `028` immer auf `2`.
      @_marcFields 028
  -->
  <xsl:template match="datafield[@tag='028']/@ind2">
    <xsl:attribute name="ind2">2</xsl:attribute>
  </xsl:template>

  <!--
      Stelle `scc` und `scr` in `041` (beliebiges Subfeld) auf `qsh` um.

      Wenn beide Codes in Subfeldern mit gleichen Subfeldcodes vorkommen, übernimm nur einen.
      @_marcFields 041
  -->
  <xsl:template match="datafield[@tag='041']/subfield[.=('scc', 'scr')]">
    <xsl:variable name="sfCode" select="@code" />
    <!-- Wenn beide codes in Subfeldern mit gleichen Codes vorhanden sind, übernimm nur einen. -->
    <xsl:if test="not((preceding-sibling::subfield[@code=$sfCode]|following-sibling::subfield[@code=$sfCode])[.=('scr')])">
      <subfield code="{$sfCode}">qsh</subfield>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
