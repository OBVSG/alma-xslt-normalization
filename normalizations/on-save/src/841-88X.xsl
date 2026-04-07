<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Dieses Stylesheet sorgt für die Verarbeitung der Felder 841-88X.
  -->

  <!--
      Lösche `856` ohne `$$u`.
  -->
  <xsl:template match="datafield[@tag='856'][not(subfield[@code='u'])]" />
</xsl:stylesheet>
