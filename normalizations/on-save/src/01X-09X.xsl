<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <xsl:mode on-no-match="shallow-copy" />

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

  <!-- Setze zweiten Indikator von `028` immer auf `2`. -->
  <xsl:template match="datafield[@tag='028']/@ind2">
    <xsl:attribute name="ind2">2</xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
