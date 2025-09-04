<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="https://share.obvsg.at/xml/xsl/doc" exclude-result-prefixes="xsl xs doc" expand-text="yes" version="3.0">

  <doc:doc scope="global">
    <doc:title>Aufsatz ableiten - Print</doc:title>
    <doc:desc>Ableiten von Aufsätzen von einem Druckwerk.</doc:desc>
  </doc:doc>

  <doc:doc scope="stylesheet">
    <doc:title>aufsatz-p.xsl</doc:title>
    <doc:desc>Hallo!</doc:desc>
  </doc:doc>

  <xsl:template match="record">
    <record>
      <leader>{"#####naa#a22######c#4500" => replace("#", " ")}</leader>
      <xsl:sequence select="controlfield[@tag='007']" />
      <xsl:call-template name="handle008" />
      <xsl:sequence select="datafield[@tag=('041', '044')]" />
      <datafield tag="245" ind1="0" ind2="0">
        <subfield code="a" />
        <subfield code="b" />
        <subfield code="c" />
      </datafield>

      <xsl:choose>
        <xsl:when test="substring(leader, 8, 1) eq 's'">
          <xsl:apply-templates select="datafield[@tag='264'][@ind1='3'][@ind2='1'][1]"
            mode="serial" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="datafield[@tag='264']" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:sequence select="datafield[@tag=('336', '337', '338', '490')]" />
      <datafield tag="773" ind1="0" ind2="8">
        <subfield code="i">Enthalten in</subfield>
        <subfield code="t">{
          datafield[@tag="245"]/subfield[@code="a"] ||
          (if (exists(datafield[@tag="245"]/subfield[@code="c"])) then
            " / " || datafield[@tag="245"]/subfield[@code="c"]
          else
            "")
        }</subfield>
        <subfield code="d"></subfield>
        <subfield code="g"></subfield>
        <subfield code="k"></subfield>
        <subfield code="w">{
          datafield[@tag="035"]/subfield[@code="a"][starts-with(., "(AT-OBV)")]
        }</subfield>
        <subfield code="x"></subfield>
        <subfield code="z"></subfield>
      </datafield>
    </record>
  </xsl:template>

  <xsl:template match="datafield[@tag='264'][@ind1='3'][@ind2='1'][1]" mode="serial">
    <datafield tag="264" ind1=" " ind2="1">
      <xsl:sequence select="subfield[@code='a']" />
      <xsl:sequence select="subfield[@code='b']" />
      <subfield code="c" />
    </datafield>
  </xsl:template>

  <xsl:template name="handle008">
    <xsl:variable name="isMono" select="substring(leader, 8, 1) eq 'm'" />
    <xsl:variable name="year"
                  select="if ($isMono and exists(controlfield[@tag='008'])) then substring(controlfield[@tag='008'], 8, 4) else '????'"/>
    <xsl:variable name="lang">{
      if (datafield[@tag="041"]/subfield[@code="a"][1][string-length(.) eq 3])
      then
        datafield[@tag="041"]/subfield[@code="a"][1]
      else
        "|||"
    }</xsl:variable>
    <controlfield tag="008">{
      ("######s" ||
      $year ||
      "####|||########|########" ||
       $lang ||
      "#c")
      => replace("#", " ")
    }</controlfield>
  </xsl:template>
</xsl:stylesheet>
