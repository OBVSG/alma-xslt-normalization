<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="https://share.obvsg.at/xml/xsl/utils" xmlns:xs="http://www.w3.org/2001/XMLSchema" expand-text="yes" version="3.0">

  <!--~doc:stylesheet
      Hier finden sich Templates und Funktionen, die sich speziell auf geografische Ressourcen beziehen.

      Das sind z. B.:
      - Das Erstellen einer `255` aus der `034`
  -->

  <!--
      Wenn es noch kein Feld `255` gibt, erstelle eines, mit den Koordinaten aus `034 $$d $$e $$f $$g`.

      Wenn das Feld nur `$$2bound` (also den Wert aus dem Template) enthält und sonst nichts, lösche es.
      @_marcFields 034 255
  -->
  <xsl:template match="datafield[@tag='034']">
    <!-- Bearbeite nur Felder 034, die wirklich Daten enthalten. -->
    <xsl:if test="not(subfield[@code='2'] and count(subfield[text()]) eq 1)">
      <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
        <xsl:apply-templates />
        <xsl:if test="not(subfield[@code='3']) and count(../datafield[@tag='034']) gt 1 and not(../datafield[ftag='255'])">
          <subfield code="3">n:{position()}</subfield>
        </xsl:if>
      </datafield>
    </xsl:if>

    <xsl:call-template name="create255from034" />
  </xsl:template>

  <!--
      Generiere `255` aus `034`.
      - wenn `034$$b` vorhanden erzeuge `255$$a1:{034$$b mit ' ' als Tausender-Trennzeichen}`
      - wenn möglich, erzeuge `255$$c` mit formatierten Koordinaten
  -->
  <xsl:template name="create255from034">
    <xsl:variable name="scale" select="if (subfield[@code='b'][1][matches(., '^\d+$')]) then subfield[@code='b'][1] else ()" />
    <xsl:if test="not(../datafield[@tag='255']) and ($scale or utils:df034isValid(.))">
      <datafield tag="255" ind1=" " ind2=" ">
        <xsl:if test="$scale">
          <subfield code="a">1:{format-integer(xs:integer($scale), "0 000")}</subfield>
        </xsl:if>
        <xsl:if test="utils:df034isValid(.)">
          <subfield code="c">{utils:formatCoordinatesFrom034(.)}</subfield>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="subfield[@code='3'][text()]">
            <subfield code="3">{subfield[@code='3'][text()][1]}</subfield>
          </xsl:when>
          <xsl:when test="count(../datafield[@tag='034']) gt 1 and not(../datafield[@tag='255'])">
            <subfield code="3">n:{position()}</subfield>
          </xsl:when>
        </xsl:choose>
      </datafield>
    </xsl:if>
  </xsl:template>

  <!--
      Template für MARC `255`, wenn es genau eine `255` und genau eine `034` gibt.

      Wenn es mehr als ein `034` oder mehr als ein `255` gibt, matcht dieses Template nicht
      und die `255` wird per Default 1:1 in die Ausgabe kopiert. Diese Einschränkung ist notwendig,
      weil bei mehreren Feldern keine Zuordnung möglich ist.

      - Wenn es ein Feld `034` mit validen Koordinaten gibt, aktualisiere `$$c`.

      @_marcFields 255
  -->
  <xsl:template match="datafield[@tag='255']">
    <xsl:variable name="sf3" select="subfield[@code='3']" />
    <xsl:variable name="assoc034" as="element(datafield)?">
      <xsl:choose>
        <xsl:when test="count(../datafield[@tag='255']) eq 1 and count(../datafield[@tag='034']) eq 1">
          <xsl:sequence select="../datafield[@tag='034']" />
        </xsl:when>
        <xsl:when test="$sf3">
          <xsl:sequence select="../datafield[@tag='034'][subfield[@code='3'][.=$sf3]]" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$assoc034">
        <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
          <xsl:if test="not(subfield[@code='a']) and $assoc034/subfield[@code='b']/text()">
            <subfield code="a">1:{format-integer(xs:integer($assoc034/subfield[@code='b']), "0 000")}</subfield>
          </xsl:if>
          <xsl:apply-templates select="subfield[@code=('a', 'b')]" />
          <xsl:choose>
            <xsl:when test="utils:df034isValid($assoc034)">
              <subfield code="c">{utils:formatCoordinatesFrom034($assoc034)}</subfield>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="subfield[@code='c']" />
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="subfield[not(@code=('a', 'b', 'c'))]" />
        </datafield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="utils:shallow-copy" />
      </xsl:otherwise>
    </xsl:choose>
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
