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

      - Wenn `$$a` mit 'ZDB-NEU' beinnt, lösche das Feld. Aus der korrespondierenden `035` wird ein Feld `9703#` gebildet.
      - Wenn es eine `035##$$a(DE-600)...` oder `035##$$aZDB-NEU-...` gibt, entferne sie. Sie wird anhand der `035` neu gebildet.
      - Wenn es **keine** `035##$$a(DE-600)...` oder `035##$$aZDB-NEU-...` gibt, kopiere die gegenständliche `016` in die Ausgabe und erstelle eine korrespondierende `035##$$a(DE-600)...` mit dem Wert aus `$$a`.

      Die Prüfung auf `[subfield[@code='a']/text()]` im `match` ist notwendig, damit es nicht mit [dem Template](#temp;datafield%5B@tag='016'%5D%5Bnot(subfield%5B@code=('a',%20'z')%5D/text())%5D;nil) kollidiert, das `016`er ohne sinnvollen Inhalt löscht.
      @_group zdbIds
      @_marcFields 016
  -->
  <xsl:template match="datafield[@tag='016'][subfield[@code='2'][.='DE-600']][subfield[@code='a']/text()]">
    <xsl:if test="not(subfield[@code='a'][starts-with(upper-case(.), 'ZDB-NEU')]) and not(../datafield[@tag='035'][subfield[@code='a'][starts-with(., '(DE-600)')]])">
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
    <subfield code="{@code}">{replace(., "-", "")}</subfield>
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
      Lösche `035` mit AC-Nummer.

      Dieses Feld wird vom [Template für 009](#temp;controlfield[@tag='009'];nil) frisch erzeugt.

      @_marcFields 035
  -->
  <xsl:template match="datafield[@tag='035'][subfield[@code='a'][starts-with(., '(AT-OBV)')]]" />

  <!--
      Synchronisiere `035` mit `016` bei ZDB-Datensätzen.

      Die Synchronisierung von `035` und `016` teilt sich auf mehrere Templates auf. Dieses hier
      tritt in Aktion, wenn `035##$$a` oder `$$Z` entweder mit "(DE-600)" oder "ZDB-NEU" (case insensitive)
      beginnt.

      Das heißt:
      - Wenn `$$a` oder `$$Z` einen 'ZDB-NEU'-Eintrag enthält, verschiebe diesen nach `9703#`
      - Erstelle eine `016` mit der ZDB-Nummer mit dem Wert von `$$a` oder `$$Z` (ohne das Präfix "(DE-600)")
        in `$$a` und `$$2DE-600`
      - Lösche vorhandene `016`, wenn eine `035##$$a(DE-600)` bzw. mit "ZDB-NEU" vorhanden ist. Siehe [entsprechendes Template](#temp;datafield%5B@tag='016'%5D%5Bsubfield%5B@code='2'%5D%5B.='DE-600'%5D%5D%5Bsubfield%5B@code='a'%5D/text()%5D;nil)
      - Wenn keine passende `035` vorhanden ist, erstelle eine aus einer etwaigen `016`. Siehe: [dasselbe Template](#temp;datafield%5B@tag='016'%5D%5Bsubfield%5B@code='2'%5D%5B.='DE-600'%5D%5D%5Bsubfield%5B@code='a'%5D/text()%5D;nil)
      - Wenn es ein `$$Z` gibt, wandle dieses in `$$a` um. Siehe: [Template zu `035##$$Z`](#temp;datafield%5B@tag='035'%5D/subfield%5B@code='Z'%5D;nil)

      @_group zdbIds
      @_marcFields 016 035
  -->
  <xsl:template match="datafield[@tag='035'][subfield[@code=('a', 'Z')][starts-with(., '(DE-600)') or starts-with(upper-case(.), 'ZDB-NEU')]]">
    <xsl:choose>
      <xsl:when test="subfield[@code=('a', 'Z')][matches(., '^(\(DE-600\))?ZDB-NEU')]">
        <datafield tag="970" ind1="3" ind2=" ">
          <subfield code="a">{subfield[@code=('a', 'Z')] => replace('^\(DE-600\)', '')}</subfield>
        </datafield>
      </xsl:when>
      <xsl:when test="not(subfield[@code=('a', 'Z')][.=('(DE-600)', 'ZDB-NEU-JJJJ-MM-TT')])">
        <xsl:call-template name="utils:shallow-copy" />

        <datafield tag="016" ind1=" " ind2=" ">
          <subfield code="a">{replace(., "^\(DE-600\)", "")}</subfield>
          <subfield code="2">DE-600</subfield>
        </datafield>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      Ändere 035 SFZ in SFa

      Dieses Template wird von [diesem Template](#temp;datafield%5B@tag='035'%5D%5Bsubfield%5B@code=('a',%20'Z')%5D%5Bstarts-with(.,%20'(DE-600)')%20or%20starts-with(upper-case(.),%20'ZDB-NEU')%5D%5D;nil) via `xsl:apply-templates` aufgerufen. Die Prüfung, ob hier ein sinnvoller Inhalt vorhanden ist, passiert dort.
      @_group zdbIds
      @_marcFields 035
  -->
  <xsl:template match="datafield[@tag='035']/subfield[@code='Z']/@code">
    <xsl:attribute name="code">a</xsl:attribute>
  </xsl:template>

  <!--
      Bearbeite oder erstelle Feld `040`.

      Der ISIL der bearbeitenden Institution wird im MARC-Feld `MOD` übergeben (das gelöscht wird, siehe [entsprechendes Template](#temp;datafield[@tag='MOD'];nil))
      und über den `$meta`-Parameter im Key `'isil'` weitergereicht (siehe die Funktion [utils:collect-metadata](#func;utils:collect-metadata)).

      - Wenn nicht vorhanden oder leer, erstelle `$$a` mit dem ISIL der bearbeitenden Institution. (`KATA-036-add040a`)
      - Wenn nicht vorhanden oder leer, erstelle `$$bger`. (`KATA-036-add040be`)
      - Erstelle oder ersetze `$$d` mit dem ISIL der bearbeitenden Institution, bei OAI-Importen übernimm den Wert aus der Quelle. (`KATA-036-upd040d`)
      - Wenn es kein `$$e` gibt und `336` vorhanden ist, erstelle ein `$$erda`. (`KATA-036-add040be`)

      Dieses Template ist sowohl ein named template als auch ein matching template. Wenn es keine `040` im Datensatz gibt
      wird es via `xsl:call-template` vom [record](#temp;record;nil) aus aufgerufen. Wenn eine `040` vorhanden ist, matcht
      es. Das erklärt die etwas umständlichen variablen `$hass336` und `$df040in`.
      @_marcFields 040
  -->
  <xsl:template name="handle040" match="datafield[@tag='040']">
    <xsl:param name="meta" tunnel="yes" />
    <xsl:variable name="isil" select="if ($meta('isil')) then $meta('isil') else 'AT-OBV'" />
    <xsl:variable name="has336" select="if (local-name() eq 'record')
                                        then exists(datafield[@tag='336']/subfield[@code='b']/text())
                                        else exists(../datafield[@tag='336']/subfield[@code='b']/text())" />
    <xsl:variable name="isAutoKat" select="if (local-name() eq 'record')
                                           then exists(datafield[@tag='970']/subfield[@code='a'][.='E-KAT - Automatisch erstelltes Katalogisat ohne intellektuelle Prüfung, Optimierung erwünscht'])
                                           else exists(../datafield[@tag='970']/subfield[@code='a'][.='E-KAT - Automatisch erstelltes Katalogisat ohne intellektuelle Prüfung, Optimierung erwünscht'])" />
    <xsl:variable name="df040in" select="if (local-name() eq 'record') then datafield[@tag='040'] else ." />
    <datafield tag="040" ind1=" " ind2=" ">
      <subfield code="a">{if ($df040in/subfield[@code='a']/text()) then $df040in/subfield[@code='a'] else $isil}</subfield>
      <subfield code="b">{if ($df040in/subfield[@code='b']/text()) then $df040in/subfield[@code='b'] else 'ger'}</subfield>
      <xsl:sequence select="$df040in/subfield[@code='c'][1]" />
      <subfield code="d">{if ($meta('source') eq 'oai') then $df040in/subfield[@code="d"] else $isil}</subfield>
      <xsl:choose>
        <xsl:when test="not($df040in/subfield[@code='e']/text())
                        and (not($isAutoKat))
                        and $has336">
          <subfield code="e">rda</subfield>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$df040in/subfield[@code='e']" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:sequence select="$df040in/subfield[@code='6'][1]" />
      <xsl:sequence select="$df040in/subfield[@code='8']" />
    </datafield>
  </xsl:template>

  <!--
      Ignoriere alle Felder `040` nach dem ersten.
      @_marcFields 040
  -->
  <xsl:template match="datafield[@tag='040'][preceding-sibling::datafield[@tag='040']]" />

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

  <!--
      Führe mehrere Felder `090` zusammen und dedupliziere Subfelder mit gleichem Inhalt.

      Dieses Template matcht die erste `090` und holt sich die Daten aus weiteren `090`ern, so vorhanden. Weitere Felder `090` werden ignoriert, siehe [entsprechendes Template](#temp;datafield%5B@tag='090'%5D%5Bposition()%20ne%201%5D;nil)

      Wenn es sich um NAK-Bestand handelt (es also ein `$$v1` gibt) und es noch kein `9702#` gibt, erstelle eines. Wenn schon eines da ist, wird das im [Template für 9702#](#temp;datafield%5B@tag='970'%5D%5B@ind1='2'%5D%5B@ind2='%20'%5D;nil) behandelt.

      Dieses Template betrifft den OAI-Import  und sollte vielleicht irgendwann einmal dorthin.
      @references #temp;datafield[@tag='090'][position() ne 1];nil
      @_marcFields 090 970
  -->
  <xsl:template match="datafield[@tag='090'][1]">
    <xsl:variable name="subfields"
                  select="subfield | following-sibling::datafield[@tag='090']/subfield" />
    <xsl:call-template name="utils:dedupSubfields">
      <xsl:with-param name="datafieldParam" as="element(datafield)">
        <datafield tag="090" ind1=" " ind2=" ">
          <xsl:sequence select="$subfields" />
        </datafield>
      </xsl:with-param>
    </xsl:call-template>
    <!-- Wenn es sich um NAK-Bestand handelt und es noch kein `9702#` gibt, erstelle eines. -->
    <xsl:if test="$subfields[@code='v'][.='1'] and not(../datafield[@tag='970'][@ind1='2'][@ind2=' '])">
      <datafield tag="970" ind1="2" ind2=" ">
        <subfield code="v">NAK-Bestand</subfield>
      </datafield>
    </xsl:if>
  </xsl:template>
  <!--
      Ignoriere jedes Feld `090` nach dem ersten. Diese Felder werden vom Template für die erste `090` abgearbeitet.

      @references temp;datafield[@tag='090'][1];nil
  -->
  <xsl:template match="datafield[@tag='090'][position() ne 1]" />

</xsl:stylesheet>
