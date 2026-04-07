<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      Diverse Hilfsfunktionen, die in verschiedenen Normalisierungen gebraucht werden.
  -->


  <!--
      Sammle Metadaten zum Datensatz.

      Diese Metadaten werden in einer Map gesammelt, die dann als Tunnel-Parameter zur Verwendung
      durch beliebige Templates weitergereicht werden.

      Die Einträge in der Map sind:
      - `flags`: `article`, `NAK`, etc. Siehe die Funktion [caclulate-flags](#func;utils:calculate-flags)
      - `isil`: der ISIL der bearbeitenden Institution
  -->
  <xsl:function name="utils:collect-metadata" as="map(*)">
    <xsl:param name="record" as="element(record)" />
    <xsl:map>
      <xsl:map-entry key="'flags'" select="utils:calculate-flags($record)" />
      <xsl:map-entry key="'isil'" select="$record/datafield[@tag='MOD']/subfield[@code='I']/text()" />
      <xsl:map-entry key="'source'" select="$record/datafield[@tag='SRC']/subfield[@code='S']/text()" />
      <xsl:map-entry key="'ldr06'" select="if ($record/leader) then $record/leader/substring(., 7, 1) else ()" />
    </xsl:map>
  </xsl:function>

  <!--
      Berechne Flags, um den Datensatz zu klassifizieren.

      Mögliche Flags sind z. B.:
      - `serial`
      - `ZDB`
      - `article`
      - ...

      Für alle Flags, siehe Quellcode.
  -->
  <xsl:function name="utils:calculate-flags" as="xs:string*">
    <xsl:param name="record" as="element(record)" />
    <xsl:sequence>
      <xsl:if test="substring($record/leader, 8, 1) eq 'a'">article</xsl:if>
      <xsl:if test="substring($record/leader, 8, 1) eq 'i'">integrating</xsl:if>
      <xsl:if test="substring($record/leader, 8, 1) eq 's'">serial</xsl:if>
      <xsl:if test="substring($record/controlfield[@tag='008'][1], 24, 1) eq 'o'">E</xsl:if>
      <xsl:if test="$record/datafield[@tag='970'][@ind1='2'][@ind2=' '][subfield[@code='d'][.='NAK']]">NAK</xsl:if>
      <xsl:if test="$record/datafield[@tag='591']/subfield[@code='a'][.='B']">B</xsl:if>
      <xsl:if test="not($record/datafield[@tag='035'][subfield[@code='a'][starts-with(., '(AT-OBV)')]])">new</xsl:if>
      <xsl:if test="$record/datafield[@tag='035'][subfield[@code='a'][matches(., '^\(DE-600\)[0-9]+')]]">ZDB</xsl:if>
    </xsl:sequence>
  </xsl:function>

  <!--
      Dedupliziere Subfelder mit gleichem Code und gleichem Wert.

      D. h. aus

      ```xml
      <datafield tag="090" ind1=" " ind2=" ">
        <subfield code="a">1</subfield>
        <subfield code="a">1</subfield>
        <subfield code="a">2</subfield>
        <subfield code="b">1</subfield>
        <subfield code="c">2</subfield>
      </datafield>
      ```

      wird

      ```xml
      <datafield tag="090" ind1=" " ind2=" ">
        <subfield code="a">1</subfield>
        <subfield code="a">2</subfield>
        <subfield code="b">1</subfield>
        <subfield code="c">2</subfield>
      </datafield>
      ```

      Das Template kann ohne Parameter im Kontext eines `datafield` aufgerufen werden. Wenn der Kontext kein Datafield ist, kann das zu deduplizierende Datafield als Parameter `datafieldParam` übergeben werden.

      ## Definierte Fehler
      Wenn weder der Parameter übergeben, noch das Template im Konext eines `datafield` aufgerufen wurde, wird eine Warnung ausgegeben und nichts in die Ausgabe geschrieben. Die Verarbeitung läuft aber weiter.

      @param datafieldParam Das `datafield`, dessen Subfelder dedupliziert werden sollen.
      @context datafield
  -->
  <xsl:template name="utils:dedupSubfields">
    <xsl:param name="datafieldParam" />
    <xsl:variable name="datafield"
                  select="if ($datafieldParam) then $datafieldParam else
                            if (local-name() = 'datafield') then . else ()" />

    <xsl:choose>
      <xsl:when test="$datafield">
        <datafield tag="{$datafield/@tag}" ind1="{$datafield/@ind1}"
          ind2="{$datafield/@ind2}">
          <xsl:for-each select="$datafield/subfield">
            <xsl:variable name="code" select="@code" />
          <xsl:variable
              name="value" select="text()" />
          <xsl:if
              test="not(preceding-sibling::subfield[@code=$code][.=$value])">
              <xsl:sequence select="." />
            </xsl:if>
          </xsl:for-each>
        </datafield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="no">WARNING: utils:dedupSubfields called in inadequate context</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Make a shallow copy of the context node in the current mode.
  -->
  <xsl:template name="utils:shallow-copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current" />
   </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
