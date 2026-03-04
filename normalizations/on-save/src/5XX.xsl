<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für den Bereich MARC 5XX.
      @title 5XX.xsl
  -->

  <!--
      Template für `500`. Es wird immer eine shallow copy gemacht (d. h. kopiert und Templates auf die Subfelder angewandt).

      Wenn `$$a` mit "Incipit:", "Bevorzugtes Incipit", "Explicit" oder "Ausreifung / Entstehungsstufe:" beginnt, erzeuge eine entsprechende `290`.

      Die `290` wird immer neu erzeugt. Etwaig vorhandene werden vom [Template für 290](#temp;datafield[@tag='290'];nil) gelöscht.

      @_group nak
      @_marcFields 500 290
  -->
  <xsl:template match="datafield[@tag='500']">
    <xsl:call-template name="utils:shallow-copy" />
    <xsl:choose>
      <xsl:when test="subfield[@code='a'][1][starts-with(., 'Incipit: ')]">
        <datafield tag="290" ind1=" " ind2=" ">
          <subfield code="a">{substring(subfield[@code="a"], 10)}</subfield>
        </datafield>
      </xsl:when>
      <xsl:when test="subfield[@code='a'][1][starts-with(., 'Bevorzugtes Incipit: ')]">
        <datafield tag="290" ind1=" " ind2=" ">
          <subfield code="b">{substring(subfield[@code="a"], 22)}</subfield>
        </datafield>
      </xsl:when>
      <xsl:when test="subfield[@code='a'][1][starts-with(., 'Ausreifung / Entstehungsstufe: ')]">
        <datafield tag="290" ind1=" " ind2=" ">
          <subfield code="c">{substring(subfield[@code="a"], 32)}</subfield>
        </datafield>
      </xsl:when>
      <xsl:when test="subfield[@code='a'][1][starts-with(., 'Explicit: ')]">
        <datafield tag="290" ind1=" " ind2=" ">
          <subfield code="e">{substring(subfield[@code="a"], 11)}</subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      Ändere `500 $$D` in `$$a`.
      @_marcFields 500
  -->
  <xsl:template match="datafield[@tag='500']/subfield[@code='D']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Entferne `500`, wenn es nur die Vortexte "Zusatzmaterial:" oder "Bildseitenverhältnis:" enthält.
      @_marcFields 500
  -->
  <xsl:template match="datafield[@tag='500'][subfield[@code='a'][.=('Zusatzmaterial:', 'Bildseitenverhältnis:')]]" />

  <!--
      Entferne `538`, wenn kein `$$a` vorhanden ist. Das passiert nicht
      zwangsläufig in beim Aufräumen, weil ein `$$i` aus einem Template
      vorhanden sein könnte.
      @_marcFields 538
  -->
  <xsl:template match="datafield[@tag='538'][not(subfield[@code='a']/text())]" />

  <!--
      Entferne `546`, wenn `$$a` nur Vortexte enthält.
  -->
  <xsl:template match="datafield[@tag='546'][matches(subfield[@code='a'], '^(Sprachfassungen|Untertitel): ?$')]" />
</xsl:stylesheet>
