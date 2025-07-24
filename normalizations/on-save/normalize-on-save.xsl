<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="http://www.obvsg.at/xslt/utils" expand-text="yes" version="3.0">

  <xsl:mode on-no-match="shallow-copy" />

  <xsl:include href="src/034to255.xsl" />

  <xsl:template match="record">
    <record>
      <xsl:apply-templates />
    </record>
  </xsl:template>

</xsl:stylesheet>
