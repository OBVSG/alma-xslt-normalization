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
      <xsl:if test="substring($record/controlfield[@tag='008'][1], 24, 1) eq 'o'">E</xsl:if>
      <xsl:if test="$record/datafield[@tag='970'][@ind1='2'][@ind2=' '][subfield[@code='d'][.='NAK']]">NAK</xsl:if>
      <xsl:if test="$record/datafield[@tag='591']/subfield[@code='a'][.='B']">B</xsl:if>
      <xsl:if test="$record/datafield[@tag='035'][subfield[@code='a'][matches(., '^\(DE-600\)[0-9]+')]]">ZDB</xsl:if>
      <xsl:if test="substring($record/leader, 8, 1) eq 's' and not($record/datafield[@tag='035'][subfield[@code='a'][matches(., '^\(DE-600\)[0-9]+')]])">fR</xsl:if>
    </xsl:sequence>

  </xsl:function>



</xsl:stylesheet>
