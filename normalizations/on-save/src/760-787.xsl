<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="http://share.obvsg.at/xml/xsl/utils" expand-text="yes" version="3.0">

  <!--~doc:stylesheet
      Die Felder `760-787` enthalten Informationen und Verknüpfungen zu verschiedenen in Beziehung stehenden Ressourcen.

      Manche Änderungen sind für alle diese Felder gleich vorzunehmen und haben daher zusammenfassende Templates:
      - in `$$w` das Präfix "(AT-OBV)" ergänzen, wenn der Feldinhalt mit "AC" beginnt.

      Hier wird z. B. folgendendes gemacht:
      - die Indikatoren von `773` bedingungslos auf `08` gesetzt
      - `773 $$a` bedingungslos gelöscht
  -->

  <!--
      Füge für alle `$$w` im Bereich `760-787` das Präfix "(AT-OBV)" ein, wenn der Subfeldinhalt
      mit "AC" beginnt.
      @_marcFields 760 762 765 767 770 772 773 774 775 776 777 780 785 786 787
  -->
  <xsl:template match="datafield[@tag ge '760' and @tag le '787']/subfield[@code='w']">
    <xsl:choose>
      <xsl:when test="starts-with(., 'AC')">
        <subfield code="w">(AT-OBV){.}</subfield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Entferne Bindestriche aus der ISBN von 765-787 SFz.
      @_marcFields 760 762 765 767 770 772 773 774 775 776 777 780 785 786 787
  -->
  <xsl:template match="datafield[@tag ge '765' and @tag le '787']/subfield[@code='z']">
    <subfield code="z">{replace(., "-", "")}</subfield>
  </xsl:template>
  <!--
      Die Indikatoren von `773` sind im OBV immer `08` also werden sie hier einfach bedingungslos gesetzt.
      @_marcFields 773
  -->
  <xsl:template match="datafield[@tag='773']/@ind1|datafield[@tag='773']/@ind2">
    <xsl:attribute name="{name()}">{if (name() = 'ind1') then '0' else '8'}</xsl:attribute>
  </xsl:template>

  <!--
      Bearbeite `773` bei Aufsätzen, d. h. mit `$$iEnthalten in`.

      Falls kein `$$d` vorhanden ist, ergänze eines mit den Daten aus `264#1`, sofern ein solches
      vorhanden ist und der Datensatz nicht aus dem NAK stammt.
      @_marcFields 773
  -->
  <xsl:template match="datafield[@tag='773'][subfield[@code='i'][.='Enthalten in']]">
    <xsl:param name="meta" tunnel="yes" as="map(*)" />
    <datafield tag="773" ind1="0" ind2="8">
      <xsl:apply-templates />
      <xsl:if test="not(subfield[@code='d'])
                    and $meta('flags') = 'article'
                    and not($meta('flags') = 'NAK')
                    and ../datafield[@tag='264'][@ind1=' '][@ind2='1']">
        <xsl:variable name="df264" select="../datafield[@tag='264'][@ind1=' '][@ind2='1'][1]" />
        <subfield code="d">{
          string-join($df264/subfield[@code='a'], ' ; ') ||
          (if ($df264/subfield[@code='a'] and $df264/subfield[@code='b']) then ' : ' else '') ||
          (if ($df264/subfield[@code='b']) then $df264/subfield[@code='b'] else '') ||
          (if ($df264/subfield[@code='a'] or $df264/subfield[@code='b']) then ', ' else '') ||
          (if ($df264/subfield[@code='c']) then $df264/subfield[@code='c'] else '')
        }</subfield>
      </xsl:if>
    </datafield>
  </xsl:template>

  <!--
      Es darf kein SFa in `773` geben, daher wird es bedingungslos gelöscht.
      @_marcFields 773
  -->
  <xsl:template match="datafield[@tag='773']/subfield[@code='a']" />

  <!--
      773 löschen, wenn sie nur `$$iSonderdruck aus` aber kein `$$t` hat.

      Ersetzt die drools-Regel [KATA-028-rm773](https://gitlab.obvsg.at/AlmaConfig/droolsConfig/-/blob/master/rules/normalizationRules/KATA/src/KATA-028-rm773.src).
      @_marcFields 773
  -->
  <xsl:template match="datafield[@tag='773'][subfield[@code='i'][.='Sonderdruck aus']][not(subfield[@code='t']/text())]" />

  <!--
      Lösche `776`, wenn es nur Template-Text enthält, es also kein Subfeld mit einem der Codes `owxz` gibt.
      @_marcFields 776
  -->
  <xsl:template match="datafield[@tag='776'][not(subfield[@code=('o', 'w', 'x', 'z')]/text())]" />

  <!--
      Lösche `77608$$nOnline-Ausgabe`, wenn es kein `$$iErscheint auch als` gibt.

      Die Vorlagen für mono, tut und tat enthalten vorbefüllte Subfelder in
      77608, bei expand from template in bereits existierende Felder gemerged werden
      (Namentlich solche mit SFi Elektronische Reproduktion, die kein SFn haben).

      Das eingefügte SFn mit "Online-Ausgabe" soll dementsprechend entfernt werden,
      wenn es kein passendes SFi gibt.
      @_marcFields 776
  -->
  <xsl:template match="datafield[@tag='776'][not(subfield[@code='i'][.='Erscheint auch als'])]/subfield[@code='n'][.='Online-Ausgabe']" />


  <!--
      Setze `780 ind1` fix auf "0".
      @_marcFields 780
  -->
  <xsl:template match="datafield[@tag='780']/@ind1">
    <xsl:attribute name="ind1">0</xsl:attribute>
  </xsl:template>

  <!--
      Setze `780 ind2` je nach Inhalt von `$$i`
      @_marcFields 780
  -->
  <xsl:template match="datafield[@tag='780']/@ind2">
    <xsl:variable name="relation" select="../subfield[@code='i']" />

    <xsl:attribute name="ind2">
      <xsl:choose>
        <xsl:when test="$relation = ('Fortsetzung von', 'Prequel', 'Sequel zu', 'Vorangegangen ist')">0</xsl:when>
        <xsl:when test="$relation = 'Teilweise Fortsetzung von'">1</xsl:when>
        <xsl:when test="$relation = 'Ersatz von'">2</xsl:when>
        <xsl:when test="$relation = 'Teilweise Ersatz von'">3</xsl:when>
        <xsl:when test="$relation = 'Vereinigung von'">4</xsl:when>
        <xsl:when test="$relation = 'Darin aufgegangen'">5</xsl:when>
        <xsl:when test="$relation = 'Teilweise darin aufgegangen'">6</xsl:when>
        <xsl:when test="$relation = 'Abgespalten von'">7</xsl:when>
        <xsl:otherwise>{.}</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!--
      Setze `785 ind1` fix auf "0".
      @_marcFields 785
  -->
  <xsl:template match="datafield[@tag='785']/@ind1">
    <xsl:attribute name="ind1">0</xsl:attribute>
  </xsl:template>

  <!--
      Setze `785 ind2` je nach Inhalt von `$$i`
      @_marcFields 785
  -->
  <xsl:template match="datafield[@tag='785']/@ind2">
    <xsl:variable name="relation" select="../subfield[@code='i']" />
    <xsl:attribute name="ind2">
      <xsl:choose>
        <xsl:when test="$relation ='Fortgesetzt durch'">0</xsl:when>
        <xsl:when test="$relation ='Prequel zu'">0</xsl:when>
        <xsl:when test="$relation ='Sequel'">0</xsl:when>
        <xsl:when test="$relation ='Gefolgt von'">0</xsl:when>
        <xsl:when test="$relation ='Teilweise fortgesetzt durch'">1</xsl:when>
        <xsl:when test="$relation ='Ersetzt durch'">2</xsl:when>
        <xsl:when test="$relation ='Teilweise ersetzt durch'">3</xsl:when>
        <xsl:when test="$relation ='Aufgegangen in'">4</xsl:when>
        <xsl:when test="$relation ='Teilweise aufgegangen in'">5</xsl:when>
        <xsl:when test="$relation ='Gesplittet in'">6</xsl:when>
        <xsl:when test="$relation ='Vereinigt, um ... zu bilden'">7</xsl:when>
        <xsl:otherwise>{.}</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
