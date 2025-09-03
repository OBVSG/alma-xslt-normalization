<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="http://www.obvsg.at/xslt/utils" xmlns:doc="http://www.obvsg.at/ns/doc" expand-text="yes" version="3.0">

  <doc:doc scope="global">
    <doc:title>Normalize on Save</doc:title>
    <doc:includeMd href="normalize-on-save.md" />
  </doc:doc>
  <doc:doc scope="stylesheet">
    <doc:title>normalize-on-save.xsl</doc:title>
    <doc:desc>Dies ist das Haupt-Stylesheet für `OBV_normalize-on-save`.

Hier wird der Datensatz gematcht und die grundsätzliche Logik abgearbeitet. Danach werden die Felder sortiert in einem `record`-Element ausgegeben. Alles darüber hinaus wird in den inkludierten Dateien deklariert.

Alles, wofür kein Template vorhanden ist, wird 1:1 in die Ausgabe kopiert.
    </doc:desc>
  </doc:doc>

  <xsl:mode on-no-match="shallow-copy" />

  <xsl:include href="src/geografika.xsl" />

  <!--
      Dieses Template ist der Einsprungspunkt für die Normalisierung.

      Es matcht aus den MARC-Record und wendet weitere Templates auf die Kind-Elemente an.
      Das Ergebnis wird in eine Variable geschrieben, damit die Felder dann sortiert in den
      resultierenden Datensatz geschrieben werden können.
  -->
  <xsl:template match="record">
    <xsl:variable name="transformedFields" as="item()*">
      <xsl:apply-templates />
    </xsl:variable>
    <record>
      <xsl:perform-sort select="$transformedFields">
        <xsl:sort select="@tag" />
      </xsl:perform-sort>
    </record>
  </xsl:template>

</xsl:stylesheet>
