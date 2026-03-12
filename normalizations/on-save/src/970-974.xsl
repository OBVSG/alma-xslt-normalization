<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Dieses Stylesheet verarbeitet die Felder 970-974. Hierbei handelt es sich um im Verbund definierte lokale Felder.
      Siehe im [Katalogisierungshandbuch](https://wiki.obvsg.at/Katalogisierungshandbuch/Kategorien%c3%bcbersichtFEALMA#A_900_45_974)
  -->

  <!--
      Ändere `970 $$A` zu `$$a`. In `$$A` sind Schreibhilfen hinterlegt, die nach dem Speichern in `$$a` sein sollen.
      @_marcFields 970
  -->
  <xsl:template match="datafield[@tag='970']/subfield[@code='A']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Ergänze den ISIL der bearbeitenden Institution in `9700#$$i`, wenn `$$abarrierefrei aufbereitet`, sofern nicht schon vorhanden.

      Wenn von der Institution eingemeldet, wird auch ein `$$u` mit einem URL für weiter Informationen eingefügt.
      @_marcFields 970
  -->
  <xsl:template match="datafield[@tag='970'][subfield[@code=('a', 'A')][.='barrierefrei aufbereitet']][not(subfield[@code='i']/text())]">
    <xsl:param name="meta" tunnel="yes" />
    <xsl:variable name="instUrls" as="map(xs:string, xs:string)">
      <xsl:map>
        <xsl:map-entry key="'AT-UBW'" select="'https://bibliothek.univie.ac.at/literaturservice.html'" />
      </xsl:map>
    </xsl:variable>
    <datafield tag="970" ind1="0" ind2=" ">
      <xsl:apply-templates />
      <subfield code="i">{$meta('isil')}</subfield>
      <xsl:if test="$instUrls($meta('isil'))">
        <subfield code="u">{$instUrls($meta('isil'))}</subfield>
      </xsl:if>
    </datafield>
  </xsl:template>

  <!--
      Lösche `9700#$$i`, wenn es keinen text enthält und `$$abarrerefrei aufbereitet`.
      @_marcFields 970
  -->
  <xsl:template match="datafield[@tag='970'][subfield[@code=('a', 'A')][.='barrierefrei aufbereitet']]/subfield[@code='i'][not(text())]" />

  <!--
      Setze die Indikatoren von `970` auf `0#`, wenn `$$a` oder `$$A` den String
      "Dublette zu" enthalten.
      @_marcFields 970
  -->
  <xsl:template match="datafield[@tag='970'][subfield[@code=('a', 'A')][contains(., 'Dublette zu')]]/(@ind1|@ind2)">
    <xsl:attribute name="{name()}">{if (name() eq 'ind1') then '0' else ' '}</xsl:attribute>
  </xsl:template>

  <!--
      Ergänze den ISIL bei LKR/ITM-Markierungen.
      @_marcFields 970
  -->
  <xsl:template match="datafield[@tag='970'][@ind1='7']/subfield[@code=('a', 'A')][matches(., '^(lkr/itm|lkr|itm)$', 'i')]">
    <xsl:param name="meta" tunnel="yes" />
    <subfield code="a">LKR/ITM-{$meta('isil') => replace('^AT-', '')}</subfield>
  </xsl:template>

</xsl:stylesheet>
