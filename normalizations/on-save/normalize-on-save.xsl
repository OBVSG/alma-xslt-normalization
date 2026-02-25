<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="https://share.obvsg.at/xml/xsl/utils" xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib" exclude-result-prefixes="xs utils mrclib" expand-text="yes" version="3.0">

  <!--~doc:global
      @title Normalize on Save
      @includeMd normalize-on-save.md
  -->

  <!--~doc:stylesheet
      Dies ist das Haupt-Stylesheet für `OBV_normalize-on-save`.

      Hier wird der Datensatz gematcht und die grundsätzliche Logik abgearbeitet. Danach werden die Felder sortiert in einem `record`-Element ausgegeben. Alles darüber hinaus wird in den inkludierten Dateien deklariert.

      Alles, wofür kein Template vorhanden ist, wird 1:1 in die Ausgabe kopiert.

      @title normalize-on-save.xsl
  -->

  <!--
      Default mode für normalize on save. Alles, wofür kein explizites Templates vorhanden ist,
      wird 1:1 in die Ausgabe geschrieben.
  -->
  <xsl:mode on-no-match="shallow-copy" />

  <xsl:include href="src/leader.xsl" />
  <xsl:include href="src/001-009.xsl" />
  <xsl:include href="src/01X-09X.xsl" />
  <xsl:include href="src/1XX.xsl" />
  <xsl:include href="src/20X-24X.xsl" />
  <xsl:include href="src/25X-28X.xsl" />
  <xsl:include href="src/3XX.xsl" />
  <xsl:include href="src/6XX.xsl" />
  <xsl:include href="src/70X-75X.xsl" />
  <xsl:include href="src/760-787.xsl" />
  <xsl:include href="src/80X-83X.xsl" />
  <xsl:include href="src/970-974.xsl" />
  <xsl:include href="src/alpha.xsl" />
  <xsl:include href="src/geografika.xsl" />
  <xsl:include href="src/ids.xsl" />
  <xsl:include href="src/perFamKor.xsl" />
  <xsl:include href="src/sort.xsl" />
  <xsl:include href="../utils/utils.xsl" />
  <xsl:include href="../../mrclib-xslt/xslt/mrclib.xsl" />

  <!--
      Dieses Template ist der Einsprungspunkt für die Normalisierung.

      Es matcht aus den MARC-Record und wendet weitere Templates auf die Kind-Elemente an.
      Das Ergebnis wird in eine Variable geschrieben, damit die Felder dann sortiert in den
      resultierenden Datensatz geschrieben werden können.
  -->
  <xsl:template match="record">
    <xsl:variable name="meta" select="utils:collect-metadata(.)" />
    <xsl:variable name="transformedFields" as="item()*">
      <xsl:apply-templates>
        <xsl:with-param name="meta" select="$meta" tunnel="yes" />
      </xsl:apply-templates>
      <xsl:if test="not(datafield[@tag='040'])">
        <xsl:call-template name="handle040">
          <xsl:with-param name="meta" select="$meta" tunnel="yes" />
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <record>
      <xsl:apply-templates select="$transformedFields" mode="sort">
        <xsl:sort select="@tag" />
        <!-- Sortiere `035##$$a(AT-OBV)...` zuerst, die restlichen Felder `035` in Eingangsreihenfolge -->
        <xsl:sort select="if (current()[@tag='035'][subfield[@code='a'][starts-with(., '(AT-OBV)')]]) then 0 else 1" />
      </xsl:apply-templates>
    </record>
  </xsl:template>

</xsl:stylesheet>
