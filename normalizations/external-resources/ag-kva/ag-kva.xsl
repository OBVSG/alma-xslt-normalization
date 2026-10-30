<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <!--doc:global
      Transformationen für die SRU-Importe aus den Verbünden der AG KVA.
      @title Import AG KVA
  -->

  <!--~doc:stylesheet
      Transformationen für die SRU-Importe aus den Verbünden der AG KVA.
      @title external-resources/ag-kva/ag-kva.xsl
  -->

  <xsl:mode on-no-match="shallow-copy" />
  <xsl:mode name="sort" on-no-match="shallow-copy" />

  <xsl:include href="../../../mrclib-xslt/xslt/mrclib.xsl" />
  <xsl:import href="../common/common.xsl" />

  <xsl:template match="record">
    <xsl:variable name="transformedFields" as="node()*">
      <xsl:apply-templates />
    </xsl:variable>

    <record>
      <xsl:apply-templates select="$transformedFields" mode="sort">
        <xsl:with-param name="transformedFields"
                        select="$transformedFields" as="item()*" tunnel="yes" />
        <xsl:sort select="@tag" />
      </xsl:apply-templates>
    </record>
  </xsl:template>

</xsl:stylesheet>
