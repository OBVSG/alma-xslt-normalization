<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="http://www.obvsg.at/xslt/utils" xmlns:xs="http://www.w3.org/2001/XMLSchema" expand-text="yes" version="3.0">


  <xsl:template match="datafield[@tag='034'][not(../datafield[@tag='255'])]">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates />
    </datafield>

    <datafield tag="255" ind1=" " ind2=" ">
      <subfield code="c">{utils:formatCoordinatesFrom034(.)}</subfield>
    </datafield>
  </xsl:template>

  <xsl:template match="datafield[@tag='255']">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates select="subfield[@code=('a', 'b')]" />
      <xsl:choose>
        <xsl:when test="../datafield[@tag='034']">
          <subfield code="c">{utils:formatCoordinatesFrom034(../datafield[@tag='034'])}</subfield>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="subfield[@code='c']" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="subfield[not(@code=('a', 'b', 'c'))]" />
    </datafield>
  </xsl:template>

  <xsl:function name="utils:formatCoordinatesFrom034" as="xs:string">
    <xsl:param name="df035" as="element(datafield)" />
    <xsl:variable name="westernmostLong" select="utils:mapCoordinates($df035/subfield[@code='d'])" />
    <xsl:variable name="easternmostLong" select="utils:mapCoordinates($df035/subfield[@code='e'])" />
    <xsl:variable name="northernmostLat" select="utils:mapCoordinates($df035/subfield[@code='f'])" />
    <xsl:variable name="southernmostLat" select="utils:mapCoordinates($df035/subfield[@code='g'])" />
    <xsl:variable name="formattedCoordinates">{
      $westernmostLong('dir') || " " || $westernmostLong('deg') || $westernmostLong('min') || $westernmostLong('sec') || "-" ||
      $easternmostLong('dir') || " " || $easternmostLong('deg') || $easternmostLong('min') || $easternmostLong('sec') || "/" ||
      $northernmostLat('dir') || " " || $northernmostLat('deg') || $northernmostLat('min') || $northernmostLat('sec') || "-" ||
      $southernmostLat('dir') || " " || $southernmostLat('deg') || $southernmostLat('min') || $southernmostLat('sec')
    }</xsl:variable>

    <xsl:sequence select="$formattedCoordinates" />
  </xsl:function>

  <xsl:function name="utils:mapCoordinates" as="map(*)">
    <xsl:param name="coordRaw" />
    <xsl:variable name="dir" select="substring($coordRaw, 1, 1)" />
    <xsl:variable name="deg" select="substring($coordRaw, 2, 3) => replace('^0+', '')" />
    <xsl:variable name="min" select="substring($coordRaw, 5, 2) => replace('^0+', '')" />
    <xsl:variable name="sec" select="substring($coordRaw, 7, 2) => replace('^0+', '')" />

    <xsl:map>
      <xsl:map-entry key="'dir'" select="$dir" />
      <xsl:map-entry key="'deg'">{if (not($deg eq '')) then $deg || '°' else ''}</xsl:map-entry>
      <xsl:map-entry key="'min'">{if (not($min eq '')) then $min || "'" else ''}</xsl:map-entry>
      <xsl:map-entry key="'sec'">{if (not($sec eq '')) then $sec || '"' else ''}</xsl:map-entry>
    </xsl:map>
  </xsl:function>

</xsl:stylesheet>
