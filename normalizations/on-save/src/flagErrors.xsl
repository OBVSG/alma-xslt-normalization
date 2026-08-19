<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--
      Template zur Markierung von Fehlern.
  -->
  <xsl:template name="flagErrors">
    <xsl:variable name="errors" as="map(xs:string, xs:string)">
      <xsl:map>
        <xsl:if test="count(controlfield[@tag='001']) ne 1">
          <xsl:map-entry key="'E0001'" select="'Count of controlfield 001 should be exactly 1. Found: ' || count(controlfield[@tag='001'])" />
        </xsl:if>
      </xsl:map>
    </xsl:variable>
    <xsl:for-each select="map:keys($errors)">
      <datafield tag="974" ind1="e" ind2=" ">
        <subfield code="e">{.}</subfield>
        <subfield code="t">{$errors(.)}</subfield>
      </datafield>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
