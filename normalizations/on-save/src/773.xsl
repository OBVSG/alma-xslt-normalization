<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="https://share.obvsg.at/xml/xsl/doc" xmlns:utils="http://share.obvsg.at/xml/xsl/utils" expand-text="yes" version="3.0">

  <!--~doc:stylesheet
      773 enthält im OBV Links zu Überordnungen bei TATs, Aufsätzen und Sonderdrucken.

      Hier wird z. B. folgendendes gemacht:
      - die Indikatoren bedingungslos auf `08` gesetzt
      - `$$a` bedingungslos gelöscht
  -->

  <!--
      Die Indikatoren von `773` sind im OBV immer `08` also werden sie hier einfach bedingungslos gesetzt.
  -->
  <xsl:template match="datafield[@tag='773']/@ind1|datafield[@tag='773']/@ind2">
    <xsl:attribute name="{name()}">{if (name() = 'ind1') then '0' else '8'}</xsl:attribute>
  </xsl:template>

  <!--
      Es darf kein SFa in `773` geben, daher wird es bedingungslos gelöscht.
  -->
  <xsl:template match="datafield[@tag='773']/subfield[@code='a']" />

</xsl:stylesheet>
