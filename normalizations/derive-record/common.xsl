<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!-- Mode for testing, not to be used in actual transformations -->
  <xsl:mode name="test" on-no-match="shallow-copy" />

  <!--~doc:stylesheet
      Templates, die für alle "Datensatz ableiten"-Normalisierungen gelten.

      @title ../common.xsl
  -->

  <!--
      Entferne `591`.
      @_marcFields 591
  -->
  <xsl:template match="datafield[@tag='591']" />

  <!--
      Entferne Culturegraph-Markierungen (`$$9O:cgwrk ...`)
  -->
  <xsl:template match="subfield[@code='9'][starts-with(., 'O:cgwrk')]" />

</xsl:stylesheet>
