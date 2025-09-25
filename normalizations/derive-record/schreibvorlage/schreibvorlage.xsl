<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes" version="3.0"
                exclude-result-prefixes="mrclib utils xs">

    <!--~doc:global
        @title Schreibvorlage P2P
    -->
  <xsl:include href="../../../mrclib-xslt/xslt/mrclib.xsl" />

  <xsl:mode on-no-match="shallow-copy" />

  <xsl:template match="record">
    <xsl:variable name="fields" as="item()*">
      <xsl:apply-templates />
       <xsl:if test="datafield[@tag='015'][subfield[@code='2'][.='oeb']]">
        <datafield tag="015" ind1=" " ind2=" ">
          <subfield code="a"></subfield>
          <subfield code="2"></subfield>
        </datafield>
      </xsl:if>
      <datafield tag="020" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
        <subfield code="c"></subfield>
        <subfield code="q"></subfield>
      </datafield>
      <xsl:if test="datafield[@tag='024'][@ind1='8'][@ind2=' ']">
        <datafield tag="024" ind1="8" ind2=" ">
          <subfield code="a"></subfield>
          <subfield code="q"></subfield>
        </datafield>
      </xsl:if>
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
      <datafield tag="250" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
      </datafield>
      <datafield tag="300" ind1=" " ind2=" ">
        <subfield code="a"></subfield>
        <subfield code="b"></subfield>
        <subfield code="c"></subfield>
      </datafield>
      <xsl:variable name="cmcTags"
                    select="datafield[@tag=('336', '337', '338')]/@tag" />
      <xsl:for-each select="('336', '337', '338')">
        <xsl:if test="not(.=$cmcTags)">
          <datafield tag="{.}" ind1=" " ind2=" ">
            <subfield code="b"></subfield>
          </datafield>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(datafield[@tag='264'])">
        <datafield tag="264" ind1=" " ind2="1">
          <subfield code="a"></subfield>
          <subfield code="b"></subfield>
          <subfield code="c"></subfield>
        </datafield>
      </xsl:if>
      <xsl:if test="not(datafield[@tag='970'][@ind1='1'][@ind2=' '][subfield[@code='c']])">
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


  <xsl:template match="controlfield[@tag=('001', '009')]" />

  <xsl:template match="datafield[@tag=('015', '016', '020', '024', '035', '040',
                                       '250', '300', '776', '856', '912',
                                       '972', '974')]" />

  <xsl:template match="controlfield[@tag='008']">
    <controlfield tag="008">{
      mrclib:replace-substring(., 1, 15, "######|????####")
      => replace("#", " ")
    }</controlfield>
  </xsl:template>

  <xsl:template match="datafield[@tag='264']">
    <datafield tag="264" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates select="subfield[@code=('a', 'b', '3')]" />
      <subfield code="c" />
    </datafield>
  </xsl:template>

</xsl:stylesheet>
