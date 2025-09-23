<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="http://share.obvsg.at/xml/xsl/utils" expand-text="yes" version="3.0">

  <!--~doc:stylesheet
      Die Felder `760-787` enthalten Informationen und Verknüpfungen zu verschiedenen in Beziehung stehenden Ressourcen.

      Manche Änderungen sind für alle diese Felder gleich vorzunehmen und haben daher zusammenfassende Templates:
      - in `$$w` das Präfix "(AT-OBV)" ergänzen, wenn der Feldinhalt mit "AC" beginnt.

      Hier wird z. B. folgendendes gemacht:
      - die Indikatoren bedingungslos auf `08` gesetzt
      - `$$a` bedingungslos gelöscht
  -->

  <!--
      Füge für alle `$$w` im Bereich `760-787` das Präfix "(AT-OBV)" ein, wenn der Subfeldinhalt
      mit "AC" beginnt.
      @marc:fields 760 762 765 767 770 772 773 774 775 776 777 780 785 786 787
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
      Die Indikatoren von `773` sind im OBV immer `08` also werden sie hier einfach bedingungslos gesetzt.
      @marc:fields 773
  -->
  <xsl:template match="datafield[@tag='773']/@ind1|datafield[@tag='773']/@ind2">
    <xsl:attribute name="{name()}">{if (name() = 'ind1') then '0' else '8'}</xsl:attribute>
  </xsl:template>

  <!--
      Bearbeite `773` bei Aufsätzen, d. h. mit `$$iEnthalten in`.

      Falls kein `$$d` vorhanden ist, ergänze eines mit den Daten aus `264#1`, sofern ein solches
      vorhanden ist und der Datensatz nicht aus dem NAK stammt.
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
          string-join($df264/subfield[@code='a'], '; ') ||
          (if ($df264/subfield[@code='b']) then ': ' || $df264/subfield[@code='b'] else "") ||
          (if ($df264/subfield[@code='c']) then ', ' || $df264/subfield[@code='c'] else "")
        }</subfield>
      </xsl:if>
    </datafield>
  </xsl:template>

  <!--
      Es darf kein SFa in `773` geben, daher wird es bedingungslos gelöscht.
      @marc:fields 773
  -->
  <xsl:template match="datafield[@tag='773']/subfield[@code='a']" />

  <!--
      773 löschen, wenn sie nur `$$iSonderdruck aus` aber kein `$$t` hat.

      Ersetzt die drools-Regel [KATA-028-rm733](https://gitlab.obvsg.at/AlmaConfig/droolsConfig/-/blob/master/rules/normalizationRules/KATA/src/KATA-028-rm773.src).
      @marc:fields 773
  -->
  <xsl:template match="datafield[@tag='773'][subfield[@code='i'][.='Sonderdruck aus']][not(subfield[@code='t']/text())]" />

</xsl:stylesheet>
