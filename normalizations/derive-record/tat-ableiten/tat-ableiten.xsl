<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">
  <!--~doc:global
      Ableiten von Teilen mit unabhängigem Titel
      @includeMd tat-ableiten.md
      @title TAT ableiten
  -->

  <!--~doc:stylesheet
      @title tat-ableiten.xsl
  -->

  <xsl:mode on-no-match="deep-skip" />

  <xsl:include
    href="../../../mrclib-xslt/xslt/mrclib.xsl" />

  <xsl:variable name="today"
    select="current-date()" />

  <xsl:variable name="datafieldsToCopy"
                select="('041', '044',
                        '100', '110', '111',
                         '246', '250',
                         '700', '710', '711',
                         '880',
                         '970')" />

  <!--
      Match template für `record`. Dies ist der Einsprungspunkt für die Transformation.
     - Wenn es eine `001` gibt, wurde vergessen, den Datensatz vorher zu duplizieren. Er wird unverändert zurückgegeben.
     - Andernfalls wird das Template [processRecord](#temp;processRecord;nil) aufgerufen, dass den Datensatz verarbeitet.
  -->
  <xsl:template match="record">
    <xsl:choose>
      <xsl:when test="controlfield[@tag='001']">
        <xsl:sequence select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="processRecord" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Verarbeitung auf Datensatz-Ebene. Hier wird definiert, welche Felder 1:1 kopiert werden und die Verarbeitung der anderen Felder angestoßen. Das Ergebnis wird in einer Variable gespeichert, die als Zwischenschritt notwendig ist, um die Felder vor Rückgabe zu sortieren.
  -->
  <xsl:template name="processRecord">
    <xsl:variable name="isSet" select="leader[substring(., 7, 1) eq 'o']" />
    <xsl:variable name="acnr" select="datafield[@tag='035']/subfield[@code='a'][starts-with(., '(AT-OBV)')]" />
    <xsl:variable name="fields" as="item()*">
      <!-- Kopieren von Feldern, die unverändert übernommen werden -->
      <xsl:sequence select="controlfield[@tag=('007')]" />
      <!-- Leere Felder einfügen -->
      <xsl:call-template
        name="insertEmptyFields" />
      <!--  IMD-Typen -->
      <xsl:call-template name="handleCMC">
        <xsl:with-param name="isSet" select="$isSet" />
      </xsl:call-template>
      <!-- Link zur Überordnung -->
      <datafield tag="773" ind1="0" ind2="8">
        <subfield code="w">{$acnr}</subfield>
        <subfield code="q"></subfield>
      </datafield>
      <!--  Templates für bestimmte Felder anwenden -->
      <xsl:apply-templates />
    </xsl:variable>
    <record>
      <xsl:perform-sort select="$fields">
        <xsl:sort select="@tag" />
      </xsl:perform-sort>
    </record>
  </xsl:template>

  <!--
      Felder unverändert in die Ausgabe kopieren.
  -->
  <xsl:template match="datafield[@tag=$datafieldsToCopy]">
    <xsl:sequence select="." />
  </xsl:template>

  <!--
      Bearbeite `leader`:

      - Pos. 7 auf `m` setzen
      - Pos. 19 auf `c` setzen
      @_marcFields leader
  -->
  <xsl:template match="leader">
    <leader>{
    mrclib:replace-control-substring(., 7, 7, "m")
    => mrclib:replace-control-substring(19, 19, "c")
    }</leader>
  </xsl:template>

  <!--
      Bearbeite `008`:

      - Aktuelles Datum in Pos. 00-05 eintragen
      - Pos. 06 mit `s` befüllen
      - Pos. 07-14 mit `????####` befüllen
      - Pos. 21 mit `|` befüllen
      @_marcFields 008
  -->
  <xsl:template match="controlfield[@tag='008']">
    <xsl:variable name="date"
      select="format-date($today, '[Y01][M01][D01]')" />
    <controlfield tag="008">{
    mrclib:replace-control-substring(., 0, 5, $date)
    => mrclib:replace-control-substring(6, 6, "s")
    => mrclib:replace-control-substring(7, 14, "????    ")
    => mrclib:replace-control-substring(21, 21, "|")
    }</controlfield>
  </xsl:template>

  <!--
      Bearbeite `245`: Übernehme `$$a` und `$$c`, füge dazwischen je ein leeres `$$n` und `$$p` ein. `$$3` wird gelöscht.
      @_marcFields 245
  -->
  <xsl:template match="datafield[@tag='245']">
    <datafield tag="245" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:sequence select="subfield[@code='a']" />
      <subfield code="n"></subfield>
      <subfield code="p"></subfield>
      <xsl:sequence select="subfield[@code='c']" />
    </datafield>
  </xsl:template>

  <!--
      Bearbeite `264#*`: `$$c` leeren und `$$3` löschen
      @_marcFields 264
  -->
  <xsl:template match="datafield[@tag='264'][@ind1=' ']">
    <datafield tag="264" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:sequence select="subfield[@code=('a', 'b')]" />
      <subfield code="c"></subfield>
    </datafield>
  </xsl:template>

  <!--
      Bearbeite `26431` (beim Ableiten von Reihen).
      - setze die Indikatoren auf `#1`
      - leere `$$c`
      @_marcFields 264
  -->
  <xsl:template match="datafield[@tag='264'][@ind1='3'][@ind2='1']">
    <datafield tag="264" ind1="1" ind2=" ">
      <xsl:sequence select="subfield[not(@code='c')]" />
      <subfield code="c"></subfield>
    </datafield>
  </xsl:template>

  <!--
      Leere `$$v` in `490` und `830`
      @_marcFields 490 830
  -->
  <xsl:template match="datafield[@tag=('490', '830')]">
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:sequence select="subfield[not(@code='v')]" />
      <subfield code="v"></subfield>
    </datafield>

  </xsl:template>

  <!--
      Füge leere Felder ein.
  -->
  <xsl:template name="insertEmptyFields">
    <xsl:if test="leader[substring(., 7, 1) eq 'c']">
      <datafield tag="024" ind1="2" ind2=" ">
        <subfield code="a"></subfield>
      </datafield>
      <datafield tag="028" ind1="2" ind2="2">
        <subfield code="a"></subfield>
      </datafield>
      <datafield tag="028" ind1="3" ind2="2">
        <subfield code="a"></subfield>
      </datafield>
    </xsl:if>
    <datafield tag="020" ind1=" " ind2=" ">
      <subfield code="a"></subfield>
    </datafield>
    <datafield tag="040" ind1=" " ind2=" ">
      <subfield code="b">ger</subfield>
      <subfield code="e">rda</subfield>
    </datafield>
    <xsl:if test="not(datafield[@tag='100'])">
      <datafield tag="100" ind1="1" ind2=" ">
        <subfield code="a"></subfield>
      </datafield>
    </xsl:if>
    <xsl:if test="not(datafield[@tag='250'])">
      <datafield tag="250" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
      </datafield>
    </xsl:if>
    <datafield tag="300" ind1=" " ind2=" ">
      <subfield code="a"></subfield>
      <subfield code="b"></subfield>
      <subfield code="c"></subfield>
    </datafield>
    <datafield tag="655" ind1=" " ind2="7">
      <subfield code="a"></subfield>
    </datafield>
    <datafield tag="700" ind1="1" ind2=" ">
      <subfield code="a"></subfield>
      <subfield code="4"></subfield>
    </datafield>
    <datafield tag="700" ind1="1" ind2=" ">
      <subfield code="a"></subfield>
      <subfield code="4"></subfield>
    </datafield>
    <datafield tag="700" ind1="1" ind2=" ">
      <subfield code="a"></subfield>
      <subfield code="4"></subfield>
    </datafield>
    <xsl:if test="not(datafield[@tag='970'][subfield[@code='c']/text()])">
      <datafield tag="970" ind1="1" ind2=" ">
        <subfield code="c"></subfield>
      </datafield>
    </xsl:if>
    <datafield tag="970" ind1="8" ind2=" ">
      <subfield code="h"></subfield>
    </datafield>
  </xsl:template>

  <xsl:template name="handleCMC">
    <xsl:param name="isSet" required="yes" />
    <xsl:choose>
      <xsl:when test="$isSet or not(datafield[@tag=('336', '337', '338')])">
        <datafield tag="336" ind1=" " ind2=" ">
          <subfield code="b"></subfield>
        </datafield>
        <datafield tag="337" ind1=" " ind2=" ">
          <subfield code="b"></subfield>
        </datafield>
        <datafield tag="338" ind1=" " ind2=" ">
          <subfield code="b"></subfield>
        </datafield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="datafield[@tag=('336', '337', '338')]" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
