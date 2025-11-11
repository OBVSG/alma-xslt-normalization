<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <xsl:mode on-no-match="shallow-copy" />

  <!--
      Entferne die Striche aus der ISBN in `020##$$a`
      @_marcFields 020
  -->
  <xsl:template match="datafield[@tag='020']/subfield[@code='a']">
    <subfield code="a">{replace(., "-", "")}</subfield>
  </xsl:template>

</xsl:stylesheet>
