<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.obvsg.at/doc" xmlns:utils="http://www.obvsg.at/fhv/utils" expand-text="yes" version="3.0">

  <xsl:mode on-no-match="shallow-copy" />

  <xsl:template match="record">
    <record>
      <leader>{"#####naa#a22######c#4500" => replace("#", " ")}</leader>
      <xsl:sequence select="controlfield[@tag='007']" />
      <controlfield tag="008">{
        ("######s????####|||########|########" ||
        (if (datafield[@tag="041"]/subfield[@code="a"][1][string-length(.) eq 3]) then
          datafield[@tag="041"]/subfield[@code="a"][1]
        else
          "|||") ||
        "#c")
        => replace("#", " ")
      }</controlfield>
      <xsl:sequence select="datafield[@tag=('041', '044')]" />
      <datafield tag="245" ind1="0" ind2="0">
        <subfield code="a" />
        <subfield code="b" />
        <subfield code="c" />
      </datafield>
      <xsl:sequence select="datafield[@tag=('264', '336', '337', '338', '490')]" />
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
        <subfield code="w">{datafield[@tag="035"]/subfield[@code="a"][starts-with(., "(AT-OBV)")]}</subfield>
        <subfield code="x"></subfield>
        <subfield code="z"></subfield>
      </datafield>
    </record>
  </xsl:template>

</xsl:stylesheet>
