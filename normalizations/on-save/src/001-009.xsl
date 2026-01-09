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
      - [ ] Wenn `008/35-37` keinen Sprachcode enthält, füge den aus `041##$$a` ein, falls vorhanden.
      - [ ] setze `008/15-17` auf `|||`, wenn es einen Ländercode in `044##$$c` gibt.
      - [X] setze `008/39` (cataloging source) auf `c` für "cooperative cataloging"
      - [ ] setze `008/19` auf `|`, wenn es sich um eine fortlaufende Ressource handelt
  -->
  <xsl:template match="controlfield[@tag='008']">
    <controlfield tag="008">{
      mrclib:replace-control-substring(., 39, 39, "c")
    }</controlfield>
  </xsl:template>
</xsl:stylesheet>
