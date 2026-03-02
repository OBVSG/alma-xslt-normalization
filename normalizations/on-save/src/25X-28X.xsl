<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Normalisierungen für den Bereich MARC 25X-28X.
      @title 25X-28X.xsl
  -->

  <!--
      Mache aus einer `264` mit mehreren `$$b` je eine `264` pro `$$b`.

      Für jedes `$$b` erzeuge eine `264` mit alles Subfeldern vor dem ersten `$$a`, allen Subfeldern
      nach dem letzen `$$b`, und den `$$a`, die direkt vor dem jeweiligen `$$b` kommen.

      Wenn es `$$6` oder `$$8` gibt, wird das Feld derzeit noch ignoriert. Das liegt daran, dass
      hier auch die korrespondierenden Felder `880` bearbeitet werden müssen. Das ist sehr komplex
      und daher noch nicht implementiert.
      @_marcFields 264
  -->
  <xsl:template match="datafield[@tag='264'][count(subfield[@code='b']) gt 1][not(subfield[@code=('6', '8')])]">
    <xsl:variable name="df264" select="." />
    <xsl:variable name="sfsBeforeAb" select="subfield[not(@code=('a', 'b'))][following-sibling::subfield[@code=('a', 'b')]]" />
    <xsl:variable name="sfsAfterAb" select="subfield[not(@code=('a', 'b'))][preceding-sibling::subfield[@code=('a', 'b')]]" />
    <xsl:for-each-group select="subfield[@code=('a', 'b')]"
                        group-ending-with="subfield[@code='b']
                                           [position() eq last() or following-sibling::subfield[1][@code=('a')]]">
        <xsl:variable name="grp" select="current-group()" as="element(subfield)*" />
      <xsl:choose>
        <xsl:when test="count($grp[@code='b']) lt 2">
          <datafield tag="264" ind1="{$df264/@ind1}" ind2="{$df264/@ind2}">
            <xsl:sequence select="$sfsBeforeAb" />
            <xsl:sequence select="current-group()" />
            <xsl:sequence select="$sfsAfterAb" />
          </datafield>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$grp[@code='b']">
            <datafield tag="264" ind1="{$df264/@ind1}" ind2="{$df264/@ind2}">
              <xsl:sequence select="$sfsBeforeAb" />
              <xsl:sequence select="$grp[@code='a']" />
              <xsl:sequence select="." />
            <xsl:sequence select="$sfsAfterAb" />
            </datafield>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!--
      Entferne `264`, wenn es nur ein Subfeld c mit dem Copyright-Zeichen (ohne Jahr) gibt.
      @_marcFields 264
  -->
  <xsl:template match="datafield[@tag='264'][@ind1=' '][@ind2='4'][subfield[@code='c'][normalize-space(.) eq '©']]" />

  <!--
      Entferne `290`. Wenn es eine entsprechende `500` gibt, wird sie [aus dieser neu erzeugt](#temp;datafield[@tag='500'];nil)
      @_group nak
      @_marcFields 290
  -->
  <xsl:template match="datafield[@tag='290']" />
</xsl:stylesheet>
