<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
    Normalisierungen für die Felder `001-009`.
  -->

  <!--
      Stelle `007` bei Musikalien auf `qu`
      @_marcFields 007
  -->
  <xsl:template match="controlfield[@tag='007'][substring(../leader, 7, 1) = ('c', 'd')]">
    <controlfield tag="007">qu</controlfield>
  </xsl:template>

  <!--
      Bearbeite Feld `008`.

      Hier passiert folgendes:
      - [X] setze `008/15-17` auf `|||`, wenn es einen Ländercode in `044##$$c` gibt.
      - [X] Wenn `008/35-37` keinen Sprachcode enthält, füge den aus `041##$$a` ein, falls vorhanden.
      - [X] Wenn der Sprachcode in `041` aus dem lokalen Bereich `qaa-qtz` ist, setze `008/35-37=|||`
      - [X] setze `008/39` (cataloging source) auf `c` für "cooperative cataloging"
      - [X] setze `008/19` auf `|`, wenn es sich um eine fortlaufende Ressource handelt

      **Anm.:** Mit "Sprachcode aus 041" und ähnlichen Formulierungen ist immer der Inhalt des ersten Subfelds a des ersten
      Feldes 041 gemeint.
      @_marcFields 008
  -->
  <xsl:template match="controlfield[@tag='008']">
    <xsl:param name="meta" tunnel="yes" />
    <xsl:variable name="firstLang041" select="../datafield[@tag='041'][1]/subfield[@code='a'][1]" />
    <xsl:variable name="pos15_17"
                  select="if (../datafield[@tag='044'][subfield[@code='c']]) then '|||' else substring(., 16, 3)" />
    <xsl:variable name="pos19"
                  select="if ($meta('flags') = ('serial')) then '|' else substring(., 20, 1)" />
    <xsl:variable name="pos35_37">
      <xsl:choose>
        <xsl:when test="$firstLang041 ge 'qaa' and $firstLang041 le 'qtz'">|||</xsl:when>
        <xsl:when test="substring(., 36, 3) = ('   ', '|||', '###', 'mul') and matches($firstLang041, '^[a-z]{3}$')">{
          $firstLang041
        }</xsl:when>
        <xsl:otherwise>{substring(., 36, 3)}</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <controlfield tag="008">{
      mrclib:replace-control-substring(., 15, 17, $pos15_17)
      => mrclib:replace-control-substring(19, 19, $pos19)
      => mrclib:replace-control-substring(35, 37, $pos35_37)
      => mrclib:replace-control-substring(39, 39, "c")
    }</controlfield>
  </xsl:template>

  <!--
      Template für `009`.

      - `009` selbst 1:1 übernehmen
      - `035##$$a(AT-OBV)AC...` erzeugen
      - bei Bedarf die EKI (`035##$$a(DE-599)OBVAC...`) erzeugen. Bedarf heißt, dass es keine nicht-OBV-EKI gibt.

      Die AC-Nummer und die OBV-EKI die vorhanden sind, werden in [einem anderen Template](#temp;datafield[@tag='035'][subfield[@code='a'][starts-with(., '(AT-OBV)')]];nil) gelöscht.

      @_marcFields 009 035
  -->
  <xsl:template match="controlfield[@tag='009']">
    <xsl:param name="meta" tunnel="yes" />
    <!-- Das Feld 009 selbst 1:1 in die Ausgabe kopieren. -->
    <xsl:sequence select="." />

    <!-- 035 mit der AC-Nummer schreiben. -->
    <datafield tag="035" ind1=" " ind2=" ">
      <subfield code="a">(AT-OBV){.}</subfield>
    </datafield>

    <!-- EKI erzeugen -->
    <xsl:if test="not(../datafield[@tag='035'][subfield[@code='a'][starts-with(., '(DE-599)')]])">
      <datafield tag="035" ind1=" " ind2=" ">
        <subfield code="a">(DE-599)OBV{.}</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
