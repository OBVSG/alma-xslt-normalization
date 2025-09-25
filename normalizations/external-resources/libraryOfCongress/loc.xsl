<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="https://share.obvsg.at/xml/xsl/utils" expand-text="yes" version="3.0">

  <xsl:mode on-no-match="shallow-copy" />
  <!--~doc:stylesheet
      Diese Normalisierung sorgt dafür, dass Datensätze, die von der Library of Congress importiert werden, an den Verbundstandard angepasst werden.
  -->

  <xs:include href="../../../mrclib-xslt/mrclib.xsl" />

  <!--
      Template für den Datensatz als ganzes.

      Hier passiert nicht viel, außer, dass die Ergebnisse der Transformation in eine Variable geschrieben werden, sodass diese dann nach Feldnummern sortiert ausgegeben werden können. Die eigentliche Logik passiert in den Match-Templates.
  -->
  <xsl:template match="record" >
    <xsl:variable name="fields" as="item()*">
      <xsl:apply-templates />
    </xsl:variable>

    <record>
      <xsl:perform-sort select="$fields">
        <xsl:sort select="@tag" />
      </xsl:perform-sort>
    </record>
  </xsl:template>

  <!--
      Lösche 800, 810, 811, 830 und erzeuge je eine 830#0 mit leeren Subfeldern w and v.
  -->
  <xsl:template match="datafield[@tag=('800', '810', '811', '830')]">
    <datafield tag="830" ind1=" " ind2="0">
      <subfield code="w"></subfield>
      <subfield code="v"></subfield>
    </datafield>
  </xsl:template>

  <!--
       Entferne Felder bedingungslos. Für die Liste, siehe `match`.
  -->
  <xsl:template match="datafield[@tag=('263', '334', '353', '758', '884')]" />

  <!-- Entferne 035 $$9 -->
  <xsl:template match="datafield[@tag='035']/subfield[@code='9']" />

  <!--
      Entferne Subfelder `$$0`, `$$1` und `$$4`, wenn sie die Zeichenkette `id.loc.gov` oder `https://isni.org` enthalten, egal in welchem Feld.
  -->
  <xsl:template match="subfield[@code=('0', '1', '4')]
                               [contains(., 'id.loc.gov')
                               or starts-with(., 'https://isni.org')
                               or starts-with(., 'http://id.worldcat.org/fast')]" />

 </xsl:stylesheet>
