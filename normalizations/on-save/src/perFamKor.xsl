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

  <!--
    Setze Standard-Beziehungskennzeichen in `100`, `110`, `111` bzw. `700`, `710`, `711`  `$$4`, wenn nicht vorhanden.

    - Wenn es in `1XX` kein `$$4` gibt füge ein SF4 hinzu:
      - `$$4aut` bei Text (`LDR/06=a|t`)
      - `$$4cmp` bei Musikdrucken (`LDR/06=c|d`)
      - `$$4cre` für alle anderen Fälle
    - Wenn es in `7XX` kein `$$4` und kein `$$t` gibt, füge ein `$$4ctb` hinzu

    @context datafield[@tag=('100', '110', '111', '700', '710', '711')]
    @_marcFields 100 110 111 700 710 711
  -->
  <xsl:template name="addDefaultRelator">
    <xsl:param name="meta" tunnel="yes" />
    <xsl:variable name="ldr06" select="../leader/substring(., 7, 1)" />
    <xsl:choose>
      <xsl:when test="starts-with(@tag, '1') and not(subfield[@code='4']/text())">
        <subfield code="4">
          <xsl:choose>
            <xsl:when test="$meta('ldr06') = ('a', 't')">aut</xsl:when>
            <xsl:when test="$meta('ldr06') = ('c', 'd')">cmp</xsl:when>
            <xsl:otherwise>cre</xsl:otherwise>
          </xsl:choose>
        </subfield>
      </xsl:when>
      <xsl:when test="starts-with(@tag, '7') and not(subfield[@code='t']/text()) and not(subfield[@code='4']/text())">
        <subfield code="4">ctb</subfield>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
