<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für Personen, Familien und Körperschaften.

      Hier gibt es v. a. named templates, die von `1XX`- und `7XX`-Feldern gemeinsam genutzt werden.
  -->

  <!--
    Setze `ind1` für `100` und `700`.

    - Wenn `$$c` "Familie", "Clan", "Dynastie" oder "Dynasty" enthält, setze `ind1` auf `3`
    - Wenn `$$a` einen Beistrich enthält, setze `ind1` auf `1`
    - In allen anderen Fällen: Setze `ind1` auf `0`

    changeFirstIndicator "100" to "3" if (exists "100.c.*Familie*|*Clan*|*Dynastie*|*Dynasty*")

    @context `100/@ind1` oder `700/@ind1`
    @_marcFields 100 700
  -->
  <xsl:template name="personInd1">
    <xsl:variable name="sfc" select="../subfield[@code='c']" />
    <xsl:variable name="isFamily" select="$sfc and (('Familie', 'Clan', 'Dynastie', 'Dynasty') ! contains($sfc, .)) = true()" />
    <xsl:attribute name="ind1">
      <xsl:choose>
        <xsl:when test="$isFamily">3</xsl:when>
        <xsl:when test="../subfield[@code='a'][contains(., ', ')]">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>


</xsl:stylesheet>
