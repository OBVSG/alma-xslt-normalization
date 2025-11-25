<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Transformationen für die Felder `1XX`
  -->

  <!--
    Wenn es eine ORCID in `100XX$$0` gibt, übertrage diese in URL-Form nach `$$1`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 100
  -->
  <xsl:template match="datafield[@tag='100'][subfield[@code='2'][.='orcid']]/subfield[@code='0']">
    <xsl:call-template name="handleOrcidSubfield" />
  </xsl:template>


  <!--
    Entferne `100XX$$2orcid`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 100
  -->
  <xsl:template match="datafield[@tag='100']/subfield[@code='2'][.='orcid']" />

  <!--
    Wenn es eine ORCID in `100XX$$9(orcid)` gibt, übertrage diese in URL-Form nach `$$1`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 100
  -->
  <xsl:template match="datafield[@tag='100']/subfield[@code='9'][starts-with(., '(orcid)')]">
    <xsl:call-template name="handleOrcidSubfield" />
  </xsl:template>

</xsl:stylesheet>
