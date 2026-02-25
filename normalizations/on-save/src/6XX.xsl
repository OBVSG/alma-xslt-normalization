<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für den Bereich MARC 6XX.
      @title 6XX.xsl
  -->

  <!--
      Verschiebe `655` mit `$$2gnd-music` nach `348`
  -->
  <xsl:template match="datafield[@tag='655'][subfield[@code='2'][.='gnd-music']]">
    <datafield tag="348" ind1=" " ind2=" ">
      <xsl:apply-templates />
    </datafield>
  </xsl:template>
</xsl:stylesheet>
