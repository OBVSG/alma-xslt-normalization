<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
    Normalizations for Fields with alphabetic codes.
  -->
  <!--
      Lösche das Feld `MOD`. Es wird nur zur Übergabe des ISILs der bearbeitenden Institution gebraucht und soll nie in der Ausgabe aufscheinen.
  -->
  <xsl:template match="datafield[@tag='MOD']" />


</xsl:stylesheet>
