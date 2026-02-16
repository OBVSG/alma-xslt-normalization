<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      In diesem Stylesheet wird der mode `sort` definiert und templates in diesem mode.

      Diese dienen dazu, während der abschließenden Sortierung nach tags auch noch innerhalb der Felder die Subfelder zu sortieren. Das dazu verwendete template `utils:sortSubfields` ist in `utils.xsl` deklariert. `utils.xsl` wird hier nicht via `xsl:include` eingebunden, weil das schon in `normalize-on-save.xsl` passiert.

      @references temp;record;nil Dort ist die `xsl:apply-templates`-Deklaration, die die Templates dieses Stylesheets aufruft.
      @references temp;utils:sortSubfields Das Template zum Sortieren der Subfelder.
  -->
  <!--
      mode der während der abschließenden Sortierung der Felder nach tags eingesetzt wird.

      Wenn es in diesem Mode kein Template vorhanden ist, wird das Feld 1:1 in den Output kopiert.
  -->
  <xsl:mode name="sort" on-no-match="shallow-copy" />

  <!--
      Sortiere die Subfelder von 100, 110, 700, 710
      @_marcFields 100 110 700 710
  -->
  <xsl:template match="datafield[@tag=('100', '110', '700', '710')]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4e', '6', '7', '8', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 111, 711
      @_marcFields 111, 711
  -->
  <xsl:template match="datafield[@tag=('111', '711')]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4j', '6', '7', '8', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von `773`.
      @_marcFields 773
  -->
  <xsl:template match="datafield[@tag='773']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfields">
      <xsl:with-param name="sortSpec" select="'itdgkwxz'" />
    </xsl:call-template>
  </xsl:template>



</xsl:stylesheet>
