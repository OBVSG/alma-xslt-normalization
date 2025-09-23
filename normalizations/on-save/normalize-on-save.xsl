<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="https://share.obvsg.at/xml/xsl/utils" expand-text="yes" version="3.0">

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

  <xsl:mode on-no-match="shallow-copy" />

  <xsl:include href="src/760-787.xsl" />
  <xsl:include href="src/80X-83X.xsl" />
  <xsl:include href="src/geografika.xsl" />
  <xsl:include href="src/sort.xsl" />
  <xsl:include href="../utils/utils.xsl" />

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
    </xsl:variable>
    <record>
      <xsl:apply-templates select="$transformedFields" mode="sort">
        <xsl:sort select="@tag" />
      </xsl:apply-templates>
    </record>
  </xsl:template>


</xsl:stylesheet>
