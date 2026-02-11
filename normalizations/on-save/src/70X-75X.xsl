<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
    Transformationen für die Felder `70X-75X`.
  -->

  <!--
    Bearbeite Feld `700`

    Füge default BZK ein. Den Rest machen speziellere Templates
    @_marcFields 700
  -->
  <xsl:template match="datafield[@tag='700']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:call-template name="addDefaultRelator" />
    </xsl:copy>
  </xsl:template>

  <!--
    Setze `ind1` bei Personen in MARC `700`. Siehe Template `personInd1` für das genaue Verhalten.
  -->
  <xsl:template match="datafield[@tag='700']/@ind1">
    <xsl:call-template name="personInd1" />
  </xsl:template>

  <!--
    Wenn es eine ORCID in `700XX$$0` gibt, übertrage diese in URL-Form nach `$$1`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 700
  -->
  <xsl:template match="datafield[@tag='700'][subfield[@code='2'][.='orcid']]/subfield[@code='0']">
    <xsl:call-template name="handleOrcidSubfield" />
  </xsl:template>


  <!--
    Entferne `700XX$$2orcid`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 700
  -->
  <xsl:template match="datafield[@tag='700']/subfield[@code='2'][.='orcid']" />

  <!--
    Wenn es eine ORCID in `700XX$$9(orcid)` oder `$$0(orcid)` gibt, übertrage diese in URL-Form nach `$$1`.

    @intComment Tests in `ids.xspec`.
    @_marcFields 700
  -->
  <xsl:template match="datafield[@tag='700']/subfield[@code=('9', '0')][starts-with(., '(orcid)')]">
    <xsl:call-template name="handleOrcidSubfield" />
  </xsl:template>

  <!--
    Bearbeite Feld `710`

    Füge default BZK ein. Den Rest machen speziellere Templates
    @_marcFields 710
  -->
  <xsl:template match="datafield[@tag='710']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:call-template name="addDefaultRelator" />
    </xsl:copy>
  </xsl:template>

  <!--
    Bearbeite Feld `711`

    Füge default BZK ein. Den Rest machen speziellere Templates
    @_marcFields 711
  -->
  <xsl:template match="datafield[@tag='711']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:call-template name="addDefaultRelator" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
