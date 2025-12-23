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
</xsl:stylesheet>
