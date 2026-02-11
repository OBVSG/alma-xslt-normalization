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
    Bearbeite Feld `100`

    Füge default BZK ein. Den Rest machen speziellere Templates
    @_marcFields 100
  -->
  <xsl:template match="datafield[@tag='100']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:call-template name="addDefaultRelator" />
    </xsl:copy>
  </xsl:template>

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
    Wenn es eine ORCID in `100XX$$9(orcid)` oder `$$0(orcid)` gibt, übertrage diese in URL-Form nach `$$1`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 100
  -->
  <xsl:template match="datafield[@tag='100']/subfield[@code=('9', '0')][starts-with(., '(orcid)')]">
    <xsl:call-template name="handleOrcidSubfield" />
  </xsl:template>

  <!--
    Bearbeite Feld `110`

    Füge default BZK ein. Den Rest machen speziellere Templates
    @_marcFields 110
  -->
  <xsl:template match="datafield[@tag='110']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:call-template name="addDefaultRelator" />
    </xsl:copy>
  </xsl:template>

  <!--
    Bearbeite Feld `111`

    Füge default BZK ein. Den Rest machen speziellere Templates
    @_marcFields 111
  -->
  <xsl:template match="datafield[@tag='111']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:call-template name="addDefaultRelator" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
