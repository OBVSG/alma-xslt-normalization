<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:global
      @title AI-Assistant
  -->

  <!--~doc:stylesheet
      Normalisierungen, die bei der Verwendung des KI-Assistenten in Alma laufen.
      @includeMd ai-assistant.md
  -->

  <xsl:import href="../../mrclib-xslt/xslt/lookups.xsl" />

  <!--
      Um Kollisionen von Match-Templates noch unwahrscheinlicher zu machen, wenn
      dieses Stylesheet mit `xsl:import` eingebunden wurde, sind alle
      Match-Templates außer dem für `record` für diesen Mode deklariert.
  -->
  <xsl:mode name="aiAssistant" on-no-match="shallow-copy" />
  <!--
      Dieser Mode dient der Sortierung der Ausgabe. Wofür kein eigenes Template
      in diesem Mode vorhanden ist, wird rekursiv in die Ausgabe kopiert.
  -->
  <xsl:mode name="sort"
    on-no-match="shallow-copy" />

  <xsl:include href="../utils/utils.xsl" />
  <xsl:include href="../../mrclib-xslt/xslt/mrclib.xsl" />

  <!--
      Globaler Parameter fürs aktuelle Datum. Dieser ist notwending, damit bei Tests ein fixes Datum mitgegeben werden kann.
  -->
  <xsl:param name="currentDateTime" select="current-dateTime()" />

  <!--
      Template für den `record`. Das ist der Einsprungspunkt der Transformation.

      Hier werden, wie in Normalize on Save, templates aufgerufen und deren Ergebnis
      in eine Variable (`transformedFields`) geschrieben. Dies dient dazu, dass sie
      am Schluss sortiert werden können.
  -->
  <xsl:template match="record">
    <xsl:variable name="meta" select="utils:collect-metadata(.)" />
    <xsl:variable name="transformedFields" as="item()*">
      <xsl:apply-templates mode="aiAssistant">
        <xsl:with-param name="meta" select="$meta" tunnel="yes" />
      </xsl:apply-templates>
      <xsl:call-template name="flagAiAssistant">
        <xsl:with-param name="meta" select="$meta" tunnel="yes" />
      </xsl:call-template>
    </xsl:variable>
    <record>
      <xsl:apply-templates select="$transformedFields" mode="sort">
        <xsl:sort select="@tag" />
      </xsl:apply-templates>
    </record>
  </xsl:template>

  <!--
      Bearbeite den Leader.
      @_marcFields leader
  -->
  <xsl:template match="leader[not(../controlfield[@tag='009'])]" mode="aiAssistant">
    <xsl:variable name="defaultLeader"
                  select="replace('#####nXX#a22######c#4500', '#', ' ')"
                  />
    <leader>{
      mrclib:replace-control-substring($defaultLeader, 6, 6, substring(., 7, 1))
      => mrclib:replace-control-substring(7, 7, substring(., 8, 1))
    }</leader>
  </xsl:template>

  <!--
      Entferne ISBD-Interpunktion am Ende von allen Subfeldern.
      @_marcFields all
  -->
  <xsl:template match="subfield/text()" mode="aiAssistant">
    <xsl:text>{mrclib:remove-isbd(.)}</xsl:text>
  </xsl:template>

  <!--
      Markiere einen Datensatz als durch den AI-Assistant erstellt oder angereichert.

      Wird ein Datensätz mehrfach angereichert, wird er mehrfach markiert. Diese
      Markierungen unterscheiden sich (zumindest) durch den Zeitstempel in
      `$$y`.
      @_marcFields 970
  -->
  <xsl:template name="flagAiAssistant">
    <xsl:param name="meta" tunnel="yes" />
    <xsl:variable name="aiMode" select="if (ancestor-or-self::record/controlfield[@tag='009']) then 'enhanced' else 'created'" />
    <xsl:variable name="dateTimeString"
                  select="format-dateTime($currentDateTime, '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]')" />

    <datafield tag="970" ind1="0" ind2=" ">
      <subfield code="a">AI-Assistant</subfield>
      <subfield code="x">{$aiMode}</subfield>
      <subfield code="y">{$dateTimeString}</subfield>
      <subfield code="i">{$meta('isil')}</subfield>
    </datafield>
  </xsl:template>

  <!--
      Tausche MARC-Relator Terms gegen relator codes. Basis für die Zuordnung ist die offizielle
      [Liste der Library of Congress](https://www.loc.gov/marc/relators/index.html).

      - Wenn zum Term in `$$e` oder `$$j` (bei `X11`) einen Code gibt, erzeuge ein `$$4` mit dem Code.
      - Wenn bereits ein passender Code vorhanden ist, behalte diesen.
      - Wenn es zum Term keinen passenden Code gibt, übernimm den Term.
      @_marcFields 100 110 111 700 710 711
  -->
  <xsl:template match="datafield[@tag=('100', '110', '111', '700', '710', '711')]/subfield[@code=(if (ends-with(../@tag, '1')) then 'j' else 'e')]" mode="aiAssistant">
    <xsl:variable name="relatorCode" select="mrclib:getRelatorByTerm(mrclib:remove-isbd(.))/@code" />
    <xsl:choose>
      <xsl:when test="$relatorCode and ../subfield[@code='4'][.=$relatorCode]" />
      <xsl:when test="$relatorCode">
        <subfield code="4">{$relatorCode}</subfield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="node()|@*" mode="aiAssistant" />
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      Normalisiere `260` und `264`. Wenn beide vorhanden sind, behalte `264`.
      Wenn es nur eine `260` gibt, mach eine `264` daraus.
      @_marcFields 260 264
  -->
  <xsl:template match="datafield[@tag='260']" mode="aiAssistant">
    <xsl:if test="not(../datafield[@tag='264'])">
      <datafield tag="264" ind1=" " ind2="1">
        <xsl:apply-templates mode="#current" />
      </datafield>
    </xsl:if>
  </xsl:template>

  <!--
      Entferne alle Subfelder außer `$$b` aus `336`, `337` und `338`.
      @_marcFields 336 337 338
  -->
  <xsl:template match="datafield[@tag=('336', '337', '338')]/subfield[not(@code='b')]" mode="aiAssistant" />

  <!--
      Wenn es beim Anreichern bereits IMD-Typen gibt, verwirf die vom KI-Assistenten.

      Notiz an mich: das läuft vor Normalize on Save. Daher bleiben die vorhandenen Felder unangetastet.
      Sollte sich das Verhalten beim Anreichern ändern (also Zugriff auf den ganzen Datensätz vorhanden sein),
      wird diese Regel problematisch.
      @_marcFields 336 337 338
  -->
  <xsl:template match="datafield[@tag=('336', '337', '338')][../controlfield[@tag='009']]" mode="aiAssistant" />

  <!--
      Markiere `600`-`655` mit `$$7Generated by AI`, sofern noch nicht vorhanden.
      @_marcFields 600 610 611 630 647 648 650 651 653 654 655
  -->
  <xsl:template match="datafield[@tag ge '600' and @tag le '655'][not(subfield[@code='7'][.='Generated by AI'])]" mode="aiAssistant">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current" />
      <subfield code="7">Generated by AI</subfield>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
