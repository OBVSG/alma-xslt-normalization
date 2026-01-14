<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Dieses Stylesheet sorgt für die Verarbeitung der Felder 80X-83X. Im OBV bedeutet das de facto: `830`. Andere Felder in diesem Bereich sind im Verbund nicht in Verwendung.
  -->

  <!--
      Ergänze ISIL-Präfix "(AT-OBV)", wenn der Subfeldwert mit "AC" beginnt
      @_marcFields 830
  -->
  <xsl:template match="datafield[@tag='830']/subfield[@code='w']">
    <xsl:choose>
      <xsl:when test="starts-with(., 'AC')">
        <subfield code="w">(AT-OBV){.}</subfield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Ändere `830#0$$a` auf `$$w`, wenn es eine AC-Nummer enthält und noch kein
      `$$w` vorhanden ist. Ergänze das ISIL-Präfix `(AT-OBV)`, wenn notwendig.

      @_marcFields 830
  -->
  <xsl:template match="datafield[@tag='830']/subfield[@code='a'][matches(., '(\(AT-OBV\))?AC')]">
    <subfield code="w">{if (starts-with(., 'AC')) then "(AT-OBV)" else ""}{.}</subfield>
  </xsl:template>

  <!--
      Entferne `830` ohne `$$w`.

      Es wird auch auf `$$a` mit AC-Nummer geprüft. Sollte eine solche vorhanden
      sein, ist das Feld nicht zu löschen, weil daraus ja ein `$$w` erstellt
      wird.

      @_marcFields 830
  -->
  <xsl:template match="datafield[@tag='830'][not(subfield[@code='w']) and not(subfield[@code='a'][matches(., '(\(AT-OBV\))?AC')])]" />

</xsl:stylesheet>
