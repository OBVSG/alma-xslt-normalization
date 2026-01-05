<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
    Normalisierungen für die Felder `01X-09X`.
  -->

  <!--
      Entferne `016`, wenn es nur Text aus der Vorlage enthält.

      D. h. es wird gelöscht, wenn es keinen Wert in `$$a` oder `$$z`, also keinen Identifikator, enthält.
      @_marcFields 016
  -->
  <xsl:template match="datafield[@tag='016'][not(subfield[@code=('a', 'z')]/text())]" />

  <!--
      Bearbeite `016##$$2DE-600`, d. h. die `016` bei ZDB-Datensätzen.

      - Wenn es eine `035##$$a(DE-600)...` oder `035##$$aZDB-NEU-...` gibt, entferne sie. Sie wird anhand der `035` neu gebildet.
      - Wenn es **keine** `035##$$a(DE-600)...` oder `035##$$aZDB-NEU-...` gibt, kopiere die gegenständliche `016` in die Ausgabe und erstelle eine korrespondierende `035##$$a(DE-600)...` mit dem Wert aus `$$a`.

      Die Prüfung auf `[subfield[@code='a']/text()]` im `match` ist notwendig, damit es nicht mit [dem Template](#temp;datafield%5B@tag='016'%5D%5Bnot(subfield%5B@code=('a',%20'z')%5D/text())%5D;nil) kollidiert, das `016`er ohne sinnvollen Inhalt löscht.
      @_marcFields 016
  -->
  <xsl:template match="datafield[@tag='016'][subfield[@code='2'][.='DE-600']][subfield[@code='a']/text()]">
    <xsl:if test="not(../datafield[@tag='035'][subfield[@code='a'][starts-with(., '(DE-600)') or starts-with(upper-case(.), 'ZDB-NEU')]])">
      <!-- Das Feld selbst kopieren -->
      <xsl:sequence select="." />
      <!-- Die 035 erstellen -->
      <datafield tag="035" ind1=" " ind2=" ">
        <subfield code="a">(DE-600){subfield[@code="a"]}</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>

  <!--
      Entferne die Striche aus der ISBN in `020##$$a`
      @_marcFields 020
  -->
  <xsl:template match="datafield[@tag='020']/subfield[@code='a']">
    <subfield code="a">{replace(., "-", "")}</subfield>
  </xsl:template>

  <!--
      Entferne "Bestellnummer" bzw. "Best.-Nr." aus `028$$a` und füge ein entsprechendes `$$bBestellnummer` hinzu,
      sofern noch nicht vorhanden.
      @_marcFields 028
  -->
  <xsl:template match="datafield[@tag='028']/subfield[@code='a'][starts-with(., 'Bestellnummer') or starts-with(., 'Best.-Nr.')]">
    <subfield code="a">{replace(., "^(Bestellnummer|Best\.-Nr\.):? *", "")}</subfield>
    <xsl:if test="not(../subfield[@code='q'])">
      <subfield code="q">Bestellnummer</subfield>
    </xsl:if>
  </xsl:template>

  <!--
      Setze zweiten Indikator von `028` immer auf `2`.
      @_marcFields 028
  -->
  <xsl:template match="datafield[@tag='028']/@ind2">
    <xsl:attribute name="ind2">2</xsl:attribute>
  </xsl:template>

  <!--
      Synchronisiere `035` mit `016` bei ZDB-Datensätzen.

      Die Synchronisierung von `035` und `016` teilt sich auf mehrere Templates auf. Dieses hier
      tritt in Aktion, wenn `035##$$a` entweder mit "(DE-600)" oder "ZDB-NEU" (case insensitive)
      beginnt.

      Das heißt:
      - Erstelle eine `016` mit der ZDB-Nummer mit dem Wert von `$$a` (ohne das Präfix "(DE-600)")
        in `$$a` und `$$2DE-600`
      - Lösche vorhandene `016`, wenn eine `035##$$a(DE-600)` bzw. mit "ZDB-NEU" vorhanden ist. Siehe: LINK ZU TEMPLATE
      - Wenn keine passende `035` vorhanden ist, erstelle eine aus einer etwaigen `016`. Siehe: LINK ZU TEMPLATE

      @_marcFields 016 035
  -->
  <xsl:template match="datafield[@tag='035'][subfield[@code='a'][starts-with(., '(DE-600)') or starts-with(upper-case(.), 'ZDB-NEU')]]">
    <xsl:sequence select="." />
    <datafield tag="016" ind1=" " ind2=" ">
      <subfield code="a">{replace(., "^\(DE-600\)", "")}</subfield>
      <subfield code="2">DE-600</subfield>
    </datafield>

  </xsl:template>

  <!--
      Stelle `scc` und `scr` in `041` (beliebiges Subfeld) auf `qsh` um.

      Wenn beide Codes in Subfeldern mit gleichen Subfeldcodes vorkommen, übernimm nur einen.
      @_marcFields 041
  -->
  <xsl:template match="datafield[@tag='041']/subfield[.=('scc', 'scr')]">
    <xsl:variable name="sfCode" select="@code" />
    <!-- Wenn beide codes in Subfeldern mit gleichen Codes vorhanden sind, übernimm nur einen. -->
    <xsl:if test="not((preceding-sibling::subfield[@code=$sfCode]|following-sibling::subfield[@code=$sfCode])[.=('scr')])">
      <subfield code="{$sfCode}">qsh</subfield>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
