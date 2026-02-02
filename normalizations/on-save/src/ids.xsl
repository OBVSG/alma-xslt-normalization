<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Verschiedene Operationen, die IDs betreffen. Das sind z. B.

      - Korrigieren von ORCIDs, die nicht in `$$1` in der Form `https://orcid.org/...` stehen
  -->

  <!--
    Bearbeite Subfelder, die eine ORCID enthalten, es aber nicht sollten. Dies betrifft MARC `100`
    und `700`.

    ORCIDs sollten immer in `$$1` in der Form `https://orcid.org/XXXX-XXXX-XXXX-XXXX` erfasst werden.

    Es gibt hier verschieden Fallgruppen:
    - `$$9(orcid)...`: Die ORCID wurde aus verschiedenen Gründen zeitweise so im OBV erfasst.
      Sollte jemand in alte Muster verfallen, wird das hier abgefangen.
    - Die ORCID steht ohne Präfix in `$$0`, es gibt ein `$$2orcid`. Diese Form scheint aus Fremddaten zu kommen.
    @context `datafield[@tag=('100', '700')]/subfield[@code=('0', '9')]`
    @_marcFields 100 700
  -->
  <xsl:template name="handleOrcidSubfield">
    <xsl:choose>
      <xsl:when test="../subfield[@code='1'][starts-with(., 'https://orcid.org')]" />
      <xsl:when test="matches(., '^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$')">
        <subfield code="1">https://orcid.org/{.}</subfield>
      </xsl:when>
      <xsl:when test="starts-with(., '(orcid)')">
        <subfield code="1">https://orcid.org/{substring(., 8)}</subfield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Generiere die EKI (Erstkatalogisierende Institution) in der Form `035##$$a(DE-599)OBV...` aus `009`, wenn nicht vorhanden

      @context marc:record
      @_marcFields 035
  -->
  <xsl:template name="createEki">
    <xsl:if test="controlfield[@tag='009'] and not(datafield[@tag='035'][subfield[@code='a'][starts-with(., '(DE-599)')]])">
      <datafield tag="035" ind1=" " ind2=" ">
        <subfield code="a">(DE-599)OBV{controlfield[@tag='009']}</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
