<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <xsl:mode on-no-match="shallow-copy" />
  <xsl:output indent="yes" />

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

</xsl:stylesheet>
