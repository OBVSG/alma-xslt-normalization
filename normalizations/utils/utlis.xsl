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
      Template, das die Subfelder eines Feldes gemäß der als Parameter übergebenen Reihenfolge
      sortiert. Es gibt das Feld mit sortierten Subfieldern zurück (nicht nur die Subfelder).

      Die Sortierreihenfolge wird dem Parameter `sortSpec` als String von Subfeldcodes übergeben.
      Die Subfelder werden dann in der Reihenfolge, in der die Codes in dem String vorkommen,
      sortiert. Subfelder, die in dem String nicht vorkommen werden am Ende in alphabetischer
      Reihenfolge sortiert. Mehrere Subfelder mit dem gleichen Code behalten ihre relative
      Reihenfolge bei.

      ## Beispiel

      ```xml
      <datafield tag="999" ind1=" " ind2=" ">
        <subfield code="0">SF0</subfield>
        <subfield code="a">SFa</subfield>
        <subfield code="b">SFb</subfield>
        <subfield code="c">SFc1</subfield>
        <subfield code="c">SFc2</subfield>
      </datafield>
      ```

      Wird bei bei Aufruf mit `<xsl:param name='sortSpec' select="'c0'" />` zu

      ```xml
      <datafield tag="999" ind1=" " ind2=" ">
        <subfield code="c">SFc1</subfield>
        <subfield code="c">SFc2</subfield>
        <subfield code="0">SF0</subfield>
        <subfield code="a">SFa</subfield>
        <subfield code="b">SFb</subfield>
      </datafield>
      ```

      @context marc:datafield
  -->
  <xsl:template name="utils:sortSubfields">
    <xsl:param name="sortSpec" as="xs:string" required="yes" />
    <xsl:variable name="datafield" select="." />
    <xsl:variable name="subfSequence"
                  select="for $code in string-to-codepoints($sortSpec)
                          return codepoints-to-string($code)" />
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:for-each select="$subfSequence">
        <xsl:variable name="code" select="." />
        <xsl:sequence select="$datafield/subfield[@code=$code]" />
      </xsl:for-each>
      <xsl:perform-sort select="$datafield/subfield[not(@code=$subfSequence)]">
        <xsl:sort select="@code" />
      </xsl:perform-sort>
    </datafield>
  </xsl:template>


  <!--
      Sammle Metadaten zum Datensatz.

      Das wäre z. B. ob es sich um einen Aufsatz handelt, etc.

      Diese Metadaten werden in einer Map gesammelt, die dann als Tunnel-Parameter zur Verwendung
      durch beliebige Templates weitergereicht werden.
  -->
  <xsl:function name="utils:collect-metadata" as="map(*)">
    <xsl:param name="record" as="element(record)" />
    <xsl:map>
      <xsl:map-entry key="'flags'" select="utils:calculate-flags($record)" />
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
      <xsl:if test="substring($record/controlfield[@tag='008'][1], 24, 1) eq 'o'">E</xsl:if>
      <xsl:if test="$record/datafield[@tag='970'][@ind1='2'][@ind2=' '][subfield[@code='d'][.='NAK']]">NAK</xsl:if>
      <xsl:if test="$record/datafield[@tag='591']/subfield[@code='a'][.='B']">B</xsl:if>
      <xsl:if test="$record/datafield[@tag='035'][subfield[@code='a'][matches(., '^\(DE-600\)[0-9]+')]]">ZDB</xsl:if>
    </xsl:sequence>

  </xsl:function>



</xsl:stylesheet>
