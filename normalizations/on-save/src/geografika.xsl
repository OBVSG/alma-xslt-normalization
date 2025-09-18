<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="https://share.obvsg.at/xml/xsl/utils" xmlns:xs="http://www.w3.org/2001/XMLSchema" expand-text="yes" version="3.0">

  <!--~doc:stylesheet
      Hier finden sich Templates und Funktionen, die sich speziell auf geografische Ressourcen beziehen.

      Das sind z. B.:
      - Das Erstellen einer `255` aus der `034`
  -->

  <!--
      Wenn es noch kein Feld `255` gibt, erstelle eines, mit den Koordinaten aus `034 $$d $$e $$f $$g`.
  -->
  <xsl:template match="datafield[@tag='034'][not(../datafield[@tag='255'])]">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates />
    </datafield>

    <xsl:if test="utils:df034isValid(.)">
      <datafield tag="255" ind1=" " ind2=" ">
        <subfield code="c">{utils:formatCoordinatesFrom034(.)}</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>

  <!--
      Template für MARC `255`.

      - Wenn es ein Feld `034` mit validen Koordinaten gibt, aktualisiere `$$c`.
  -->
  <xsl:template match="datafield[@tag='255']">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates select="subfield[@code=('a', 'b')]" />
      <xsl:choose>
        <xsl:when test="../datafield[@tag='034'] and utils:df034isValid(../datafield[@tag='034'])">
          <subfield code="c">{utils:formatCoordinatesFrom034(../datafield[@tag='034'])}</subfield>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="subfield[@code='c']" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="subfield[not(@code=('a', 'b', 'c'))]" />
    </datafield>
  </xsl:template>

  <!--
      Überprüfe, ob die Koordinaten in MARC `034` formal valide aussehen, d. h. dem
      Regulären Ausdruck `^[NESW]\d{7}$` entsprechen.
  -->
  <xsl:function name="utils:df034isValid" as="xs:boolean">
    <xsl:param name="df034" as="element(datafield)" />
    <xsl:variable name="subfieldCountValid"
                  as="xs:boolean*"
                  select="for $code in ('d', 'e', 'f', 'g') return count($df034/subfield[@code=$code]) eq 1">
    </xsl:variable>
    <xsl:variable name="stringsValid" as="xs:boolean*">
      <xsl:for-each select="$df034/subfield[@code=('d', 'e', 'f', 'g')]">
        <xsl:value-of select="matches(., '^[NESW]\d{7}$')" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="not($subfieldCountValid = false())
                          and not($stringsValid = false())" />
  </xsl:function>

  <!--
      Bringe die Koordinaten aus `034 $$d $$e $$f $$g` in eine menschenlesbare Form.

      Das heißt
      ```
      034 ## $$d E0044125 $$e E0102931 $$f N0474830 $$g N0455314 $$2 bound

      wird zu

      255 ## $$c E 04°41"25'-E 10°29"31'/N 47°48"30'-N 45°53"14'
      ```
  -->
  <xsl:function name="utils:formatCoordinatesFrom034" as="xs:string">
    <xsl:param name="df034" as="element(datafield)" />
    <xsl:variable name="westernmostLong" select="utils:mapCoordinates($df034/subfield[@code='d'])" />
    <xsl:variable name="easternmostLong" select="utils:mapCoordinates($df034/subfield[@code='e'])" />
    <xsl:variable name="northernmostLat" select="utils:mapCoordinates($df034/subfield[@code='f'])" />
    <xsl:variable name="southernmostLat" select="utils:mapCoordinates($df034/subfield[@code='g'])" />
    <xsl:variable name="formattedCoordinates">{
      $westernmostLong('dir') || " " || $westernmostLong('deg') || $westernmostLong('min') || $westernmostLong('sec') || "-" ||
      $easternmostLong('dir') || " " || $easternmostLong('deg') || $easternmostLong('min') || $easternmostLong('sec') || "/" ||
      $northernmostLat('dir') || " " || $northernmostLat('deg') || $northernmostLat('min') || $northernmostLat('sec') || "-" ||
      $southernmostLat('dir') || " " || $southernmostLat('deg') || $southernmostLat('min') || $southernmostLat('sec')
    }</xsl:variable>

    <xsl:sequence select="$formattedCoordinates" />
  </xsl:function>

  <!--
      Helferfunktion für `utils:formatCoordinatesFrom034`

      Teilt die Eingabedaten in Himmelsrichtung, Grade, Minuten und Sekunden und gibt eine `map`
      mit den Teilen zurück.

      @returns Eine `map` mit den einzelnen Datenelementen (Himmelsrichtung, Grade, Minuten, Sekunden)
  -->
  <xsl:function name="utils:mapCoordinates" as="map(*)">
    <xsl:param name="coordRaw" as="xs:string" />
    <xsl:variable name="dir" select="substring($coordRaw, 1, 1)" />
    <xsl:variable name="deg" select="substring($coordRaw, 2, 3) => xs:integer() => format-integer('00')" />
    <xsl:variable name="min" select="substring($coordRaw, 5, 2) => xs:integer() => format-integer('00')" />
    <xsl:variable name="sec" select="substring($coordRaw, 7, 2) => xs:integer() => format-integer('00')" />

    <xsl:map>
      <xsl:map-entry key="'dir'">{$dir}</xsl:map-entry>
      <xsl:map-entry key="'deg'">{if (not($deg eq '')) then $deg || '°' else ''}</xsl:map-entry>
      <xsl:map-entry key="'min'">{if (not($min eq '')) then $min || "'" else ''}</xsl:map-entry>
      <xsl:map-entry key="'sec'">{if (not($sec eq '')) then $sec || '"' else ''}</xsl:map-entry>
    </xsl:map>
  </xsl:function>

</xsl:stylesheet>
