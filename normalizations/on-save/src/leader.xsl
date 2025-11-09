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
    - `773XX$$iSonderdruck aus` => `LDR/19=#`
    - `LDR/07=m` und `773 $$w` vorhanden => `LDR/19=c`
    - `LDR/07=m`, NICHT `LDR/19=a` und `830` vorhanden => `LDR/19=b`
    - `LDR/07!=m` => `LDR/19=#`
    - Sonst: `LDR/19` bleibt unverändert.

    `LDR/19` muss bei `LDR/07=m` unverändert bleiben bei MtMs mit Gesamttitel!
  -->
  <xsl:template match="leader">
    <xsl:variable name="pos7in" select="substring(., 8, 1)" />
    <xsl:variable name="pos19in" select="substring(., 20, 1)" />
    <xsl:variable name="pos19">
      <xsl:choose>
        <xsl:when test="../datafield[@tag='773'][subfield[@code='i'][.='Sonderdruck aus']]">{' '}</xsl:when>
        <xsl:when test="$pos7in eq 'm' and ../datafield[@tag='773'][subfield[@code='w']]">c</xsl:when>
        <xsl:when test="$pos7in eq 'm'
                        and $pos19in ne 'a'
                        and ../datafield[@tag='830'][subfield[@code='w']]">b</xsl:when>
        <xsl:when test="not($pos7in eq 'm')">{' '}</xsl:when>
        <xsl:otherwise>{$pos19in}</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <leader>{
      mrclib:replace-control-substring(., 18, 18, "c")
      => mrclib:replace-control-substring(19, 19, $pos19)
    }</leader>
  </xsl:template>


</xsl:stylesheet>
