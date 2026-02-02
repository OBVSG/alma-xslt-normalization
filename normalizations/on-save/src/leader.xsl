<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
    Normalisierungen für den `leader`.
  -->

  <!--
    Template, dass den `leader` bearbeitet.

    Hier passiert folgendes:
    - `LDR/18` wird fix auf `c` ("ISBD punctuation omitted")
    - `LDR/19` wird je nach Sachverhalt gesetzt (s. U.)

    ## Position 19
    - `LDR/07!=c|d|m` => `LDR/19=#`
    - `LDR/19=a` => bleibt immer stehen
    - `773XX$$w` aber kein `773XX$$i` vorhanden => `LDR/19=c`
    - `830` => `LDR/19=b`
    - `773XX$$i` => `LDR/19=#`
    - Sonst: `LDR/19` bleibt unverändert.
  -->
  <xsl:template match="leader">
    <xsl:variable name="pos7in" select="substring(., 8, 1)" />
    <xsl:variable name="pos19in" select="substring(., 20, 1)" />
    <xsl:variable name="pos19">
      <xsl:choose>
        <xsl:when test="not($pos7in = ('c', 'd', 'm'))">{' '}</xsl:when>
        <xsl:when test="$pos19in eq 'a'">{$pos19in}</xsl:when>
        <xsl:when test="../datafield[@tag='773'][subfield[@code='w']]
                        and not(../datafield[@tag='773'][subfield[@code='i']])">c</xsl:when>
        <xsl:when test="../datafield[@tag='830']">b</xsl:when>
        <xsl:when test="../datafield[@tag='773'][subfield[@code='i']]">{' '}</xsl:when>
        <xsl:otherwise>{$pos19in}</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <leader>{
      mrclib:replace-control-substring(., 18, 18, "c")
      => mrclib:replace-control-substring(19, 19, $pos19)
    }</leader>
  </xsl:template>


</xsl:stylesheet>
