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
      @group zdbIds
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
      Entferne die Striche aus der ISBN in `020##$$a` und `$$z`
      @_marcFields 020
  -->
  <xsl:template match="datafield[@tag='020']/subfield[@code=('a', 'z')]">
    <subfield code="a">{replace(., "-", "")}</subfield>
  </xsl:template>

  <!--
      Entferne `024` ohne sinnvollen Inhalt
      @_marcFields 024
  -->
  <xsl:template match="datafield[@tag='024'][not(subfield[@code=('a', 'z')]/text())]" />

  <!--
      Entferne Bindestriche aus der ISMN in `0242#`.
      @_marcFields 024
  -->
  <xsl:template match="datafield[@tag='024'][@ind1='2']/subfield[@code='a']">
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
      - Erstelle eine `016` mit der ZDB-Nummer mit dem Wert von `$$a` oder `$$Z` (ohne das Präfix "(DE-600)")
        in `$$a` und `$$2DE-600`
      - Lösche vorhandene `016`, wenn eine `035##$$a(DE-600)` bzw. mit "ZDB-NEU" vorhanden ist. Siehe [entsprechendes Template](#temp;datafield%5B@tag='016'%5D%5Bsubfield%5B@code='2'%5D%5B.='DE-600'%5D%5D%5Bsubfield%5B@code='a'%5D/text()%5D;nil)
      - Wenn keine passende `035` vorhanden ist, erstelle eine aus einer etwaigen `016`. Siehe: [dasselbe Template](#temp;datafield%5B@tag='016'%5D%5Bsubfield%5B@code='2'%5D%5B.='DE-600'%5D%5D%5Bsubfield%5B@code='a'%5D/text()%5D;nil)
      - Wenn es ein `$$Z` gibt, wandle dieses in `$$a` um. Siehe: [Template zu `035##$$Z`](#temp;datafield%5B@tag='035'%5D/subfield%5B@code='Z'%5D;nil)

      @group zdbIds
      @_marcFields 016 035
  -->
  <xsl:template match="datafield[@tag='035'][subfield[@code=('a', 'Z')][starts-with(., '(DE-600)') or starts-with(upper-case(.), 'ZDB-NEU')]]">
    <xsl:if test="not(subfield[@code=('a', 'Z')][.=('(DE-600)', 'ZDB-NEU-JJJJ-MM-TT')])">
      <datafield tag="035" ind1=" " ind2=" ">
        <xsl:apply-templates />
      </datafield>

      <datafield tag="016" ind1=" " ind2=" ">
        <subfield code="a">{replace(., "^\(DE-600\)", "")}</subfield>
        <subfield code="2">DE-600</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>

  <!--
      Ändere 035 SFZ in SFa und ergänze ISIL, wenn notwendig.

      Dieses Template wird von [diesem Template](#temp;datafield%5B@tag='035'%5D%5Bsubfield%5B@code=('a',%20'Z')%5D%5Bstarts-with(.,%20'(DE-600)')%20or%20starts-with(upper-case(.),%20'ZDB-NEU')%5D%5D;nil) via `xsl:apply-templates` aufgerufen. Die Prüfung, ob hier ein sinnvoller Inhalt vorhanden ist, passiert dort.
      @group zdbIds
      @_marcFields 035
  -->
  <xsl:template match="datafield[@tag='035']/subfield[@code='Z']">
    <subfield code="a">{if (starts-with(., "(DE-600)")) then "" else "(DE-600)"}{.}</subfield>
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

  <!--
      Entferne `084` ohne Inhalt in `$$a`.
      @_marcFields 084
  -->
  <xsl:template match="datafield[@tag='084'][not(subfield[@code='a']/text())]" />

</xsl:stylesheet>
