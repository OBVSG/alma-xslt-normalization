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


</xsl:stylesheet>
