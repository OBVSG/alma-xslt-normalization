<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">
  <!--~doc:global
      @title Schreibvorlage E2P
      @includeMd schreibvorlage-e2p.md
  -->
  <!--~doc:stylesheet
      Hauptstylesheet für Schreibvorlage E2P
      @title schreibvorlage-e2p.xsl
  -->
  <!-- https://wiki.obvsg.at/Katalogisierungshandbuch/AlmaWissenDatensatzerweiternSchreibvorlage -->

  <xsl:include href="../../../../mrclib-xslt/xslt/mrclib.xsl" />
  <xsl:mode on-no-match="shallow-copy" />

  <!--
      Einstiegspunkt für die Transformation. Hier passiert alles, was nicht in anderen Templates abgehandelt wird. D. h. einfügen von leeren Feldern etc.
  -->
  <xsl:template match="record">
    <xsl:variable name="fields" as="item()*">
      <xsl:apply-templates />
      <controlfield tag="007">tu</controlfield>
      <datafield tag="020" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
        <subfield code="q"></subfield>
        <subfield code="c"></subfield>
      </datafield>
      <datafield tag="040" ind1=" " ind2=" ">
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
      <datafield tag="336" ind1=" " ind2=" ">
        <subfield code="b">txt</subfield>
      </datafield>
      <datafield tag="337" ind1=" " ind2=" ">
        <subfield code="b">n</subfield>
      </datafield>
      <datafield tag="338" ind1=" " ind2=" ">
        <subfield code="b">nc</subfield>
      </datafield>
      <xsl:if test="not(datafield[@tag='970'][@ind1='1'][@ind2=' '][subfield[@code='c']/text()])">
        <datafield tag="970" ind1="1" ind2=" ">
          <subfield code="c"></subfield>
        </datafield>
      </xsl:if>
    </xsl:variable>

    <record>
      <xsl:perform-sort select="$fields">
        <xsl:sort select="@tag" />
      </xsl:perform-sort>
    </record>
  </xsl:template>

  <!-- Lösche controlfields -->
  <xsl:template match="controlfield[@tag=('001', '007', '009')]" />

  <!-- Lösche datafields -->
  <xsl:template match="datafield[@tag=('015', '016', '024', '035', '040', '336', '337', '338', '347', '856', '912', '972', '974')]" />

  <!--
      Bearbeite MARC `008`
  -->
  <xsl:template match="controlfield[@tag='008']">
   <controlfield tag="008">{
     mrclib:replace-control-substring(., 0, 5, "     ")
     => mrclib:replace-control-substring(23, 23, " ")
   }</controlfield>
  </xsl:template>

  <!--
      ISBN der Print-Ausgabe nach `77608` übertragen
  -->
  <xsl:template match="datafield[@tag='020'][subfield[@code='a']]">
    <datafield tag="776" ind1="0" ind2="8">
      <subfield code="i">Erscheint auch als</subfield>
      <subfield code="n">Online-Ausgabe</subfield>
      <subfield code="z">{subfield[@code='a']}</subfield>
    </datafield>
  </xsl:template>

  <!--
      Den Text "1 Online-Ressource (...)" aus `300##$$a` entfernen.
  -->
  <xsl:template match="datafield[@tag='300']/subfield[@code='a'][starts-with(., '1 Online-Ressource')]">
    <subfield code="a">{replace(., "^1 Online-Ressource \((.*)\)", "$1")}</subfield>
  </xsl:template>

  <!-- Lösche den Inhalt von `77308$$w`. -->
  <xsl:template match="datafield[@tag='773']/subfield[@code='w']/text()" />

  <!-- ISBNs der Druck-Ausgaben nach 020 übetragen -->
  <xsl:template match="datafield[@tag='776'][subfield[@code='n'][.='Druck-Ausgabe']]">
    <xsl:for-each select="subfield[@code='z']">
      <datafield tag="020" ind1=" " ind2=" ">
        <subfield code="a">{.}</subfield>
      </datafield>
    </xsl:for-each>
  </xsl:template>

  <!-- Lösche den Inhalt von `830$$w` -->
  <xsl:template match="datafield[@tag='830']/subfield[@code='w']/text()" />

</xsl:stylesheet>
