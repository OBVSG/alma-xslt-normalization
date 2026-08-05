<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:global
      @title Schreibvorlage E2P
      @includeMd schreibvorlage-p2e.md
  -->
  <!--~doc:stylesheet
      Hauptstylesheet für Schreibvorlage P2E
      @title schreibvorlage-p2e.xsl
  -->
  <!-- https://wiki.obvsg.at/Katalogisierungshandbuch/AlmaWissenDatensatzerweiternSchreibvorlage -->

  <xsl:import href="../../common.xsl" />
  <xsl:include href="../../../../mrclib-xslt/xslt/mrclib.xsl" />
  <xsl:mode on-no-match="shallow-copy" />

  <!--
      Einstiegspunkt für die Transformation. Hier passiert alles, was nicht in anderen Templates abgehandelt wird. D. h. einfügen von leeren Feldern etc.
  -->
  <xsl:template match="record">
    <xsl:variable name="fields" as="item()*">
      <xsl:apply-templates />
      <controlfield tag="007">cr |||||||||||</controlfield>
      <datafield tag="020" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
        <subfield code="q"></subfield>
      </datafield>
      <datafield tag="024" ind1="7" ind2=" ">
        <subfield code="a"></subfield>
        <subfield code="2">doi</subfield>
      </datafield>
      <datafield tag="040" ind1=" " ind2=" ">
        <subfield code="b">ger</subfield>
        <subfield code="e">rda</subfield>
      </datafield>
      <xsl:if test="not(datafield[@tag='041'])">
        <datafield tag="041" ind1=" " ind2=" ">
          <subfield code="a"></subfield>
          <subfield code="a"></subfield>
        </datafield>
      </xsl:if>
      <xsl:if test="not(datafield[@tag='044'])">
        <datafield tag="044" ind1=" " ind2=" ">
          <subfield code="c"></subfield>
          <subfield code="c"></subfield>
        </datafield>
      </xsl:if>
      <xsl:if test="not(datafield[@tag='336'])">
        <datafield tag="336" ind1=" " ind2=" ">
          <subfield code="b">txt</subfield>
        </datafield>
      </xsl:if>
      <datafield tag="337" ind1=" " ind2=" ">
        <subfield code="b">c</subfield>
      </datafield>
      <datafield tag="338" ind1=" " ind2=" ">
        <subfield code="b">cr</subfield>
      </datafield>
      <datafield tag="776" ind1="0" ind2="8">
        <subfield code="i">Erscheint auch als</subfield>
        <subfield code="n">Druck-Ausgabe</subfield>
        <xsl:for-each select="datafield[@tag='020']/subfield[@code='a']">
          <subfield code="z">{.}</subfield>
        </xsl:for-each>
        <subfield code="z"></subfield>
      </datafield>
      <xsl:if
        test="not(datafield[@tag='970'][@ind1='1'][@ind2=' '][subfield[@code='c']/text()])">
        <datafield tag="970" ind1="1" ind2=" ">
          <subfield code="c"></subfield>
        </datafield>
      </xsl:if>
      <datafield tag="856" ind1="4" ind2="0">
        <subfield code="u"></subfield>
        <subfield code="x"></subfield>
        <subfield code="3">Volltext</subfield>
      </datafield>
      <datafield tag="912" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
      </datafield>
    </xsl:variable>

    <record>
      <xsl:perform-sort select="$fields">
        <xsl:sort select="@tag" />
      </xsl:perform-sort>
    </record>
  </xsl:template>

  <xsl:variable name="tagsToDelete"
                select="('001', '003', '005', '007', '009',
                        '010', '015', '016', '020', '024', '035', '040', '090',
                        '263', '337', '338',
                        '583', '588', '773', '776', '830', '856', '972', '974')" />
  <!--
      Felder löschen.
      @_marcFields 001 003 005 007 009 010 015 016 020 024 035 040 090 263 337 338 583 588 773 776 830 856 972 974
  -->
  <xsl:template match="(controlfield|datafield)[@tag=$tagsToDelete]" />

  <!--
      Bearbeite Feld `008`.
      @_marcFields
  -->
  <xsl:template match="controlfield[@tag='008']">
    <controlfield tag="008">{
      mrclib:replace-control-substring(., 0, 5, "      ")
      => mrclib:replace-control-substring(6, 6, "s")
      => mrclib:replace-control-substring(23, 23, "o")
    }</controlfield>
  </xsl:template>

  <!--
      Bearbeite `300##$$a`: Ergänze "1 Online-Ressource" und setze den vorhandenen Wert dahinter in runde Klammern.
      @_marcFields 300
  -->
  <xsl:template match="datafield[@tag='300']/subfield[@code='a']">
    <subfield code="a">1 Online-Ressource ({.})</subfield>
  </xsl:template>

  <!--
      Lösche `300##$$c`.
      @_marcFields 300
  -->
  <xsl:template match="datafield[@tag='300']/subfield[@code='c']" />

  <!--
      Lösche alle `970`, außer der Fachgruppe
      @_marcFields 970
  -->
  <xsl:template match="datafield[@tag='970'][not(@ind1 eq '1' and subfield[@code='c']/text())]" />
</xsl:stylesheet>
