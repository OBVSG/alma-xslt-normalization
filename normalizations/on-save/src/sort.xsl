<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                version="3.0">

  <!--~doc:stylesheet
      In diesem Stylesheet wird der mode `sort` definiert und templates in diesem mode. Neben Sortierungen werden hier auch noch [leere Subfelder](#temp;datafield/subfield[not(text())];sort) und [leere Felder](#temp;datafield[not(subfield/text())];sort) (bzw. [689X# ohne zugehörige Schlagwortfolge](#temp;datafield[@tag='689'];sort)) gelöscht.

      Diese dienen dazu, während der abschließenden Sortierung nach tags auch noch innerhalb der Felder die Subfelder zu sortieren. Das dazu verwendete template `utils:sortSubfields` ist in [utils.xsl](#stylesheet;../utils/utils.xsl) deklariert. `utils.xsl` wird hier nicht via `xsl:include` eingebunden, weil das schon in `normalize-on-save.xsl` passiert.

      ## Allgemeines zur Sortierung von Subfeldern
      - Subfeld `$$6` wird NICHT zu den anderen numerischen Subfeldern nach hinten sortiert, weil es beim automatischen einfügen im MDE vorne hingestellt wird und die Bearbeiter:innen das so gewohnt sind.
      - Subfeld `$$9` wird immer ans Ende gestellt.

      @references temp;record;nil Dort ist die `xsl:apply-templates`-Deklaration, die die Templates dieses Stylesheets aufruft.
      @references temp;utils:sortSubfields Das Template zum Sortieren der Subfelder.
  -->
  <!--
      mode der während der abschließenden Sortierung der Felder nach tags eingesetzt wird.

      Wenn es in diesem Mode kein Template vorhanden ist, wird das Feld 1:1 in den Output kopiert.

      Über die Sortierung hinaus werden hier leere Felder und leere Subfelder gelöscht.
  -->
  <xsl:mode name="sort" on-no-match="shallow-copy" />

  <!--
      Sortiere die Subfelder von 100, 110
      @_marcFields 100 110
  -->
  <xsl:template match="datafield[@tag=('100', '110')]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4e', '7', '8', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 111
      @_marcFields 111
  -->
  <xsl:template match="datafield[@tag='111']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4j', '7', '8', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 130
      @_marcFields 130
  -->
  <xsl:template match="datafield[@tag='130']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '7', '8', 'k', 'o', 'v', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 240
      @_marcFields 240
  -->
  <xsl:template match="datafield[@tag='240']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '7', '8', 'k', 'o', 'v', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 385
      @_marcFields 385
  -->
  <xsl:template match="datafield[@tag='385']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '3', '7', '8', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 600, 610, 611, 630, 650, 651
      @_marcFields 600 610 611 630 650 651
  -->
  <xsl:template match="datafield[@tag=('600', '610', '611', '630', '650', '651')]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '3', '4', '7', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 655
      @_marcFields 655
  -->
  <xsl:template match="datafield[@tag='655']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '3', '7', '8', 'xyz', '9')" />
    </xsl:call-template>
  </xsl:template>

 <!--
     Sortiere die Subfelder von `689`.

     ### Institutionskennungen in 689 ind2=#
     Entferne `689X#`, wenn es keine weiteren `689` mit `ind1=X` gibt.

     In den Schablonen sind oft mehrere Folgen vorhanden, jeweils mit der
     `689X#$$5ISIL`. Wenn aber eine Folge nicht ausgefüllt wirt, sollten diese
     natürlich gelöscht werden.
     @_marcField 689
  -->
  <xsl:template match="datafield[@tag='689']" mode="sort">
    <xsl:variable name="ind1" select="@ind1" />
    <xsl:variable name="hasTermSequence"
                  select="(preceding-sibling::datafield[@tag='689']|following-sibling::datafield[@tag='689'])[@ind1 = $ind1][subfield[@code='a']/text()]" />
    <xsl:if test="not(@ind2 eq ' ') or $hasTermSequence">
      <xsl:call-template name="mrclib:sortSubfieldsToEnd">
        <xsl:with-param name="sortSpec" select="('D', '0', '1', '2', '9')" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 700, 710
      @_marcFields 700 710
  -->
  <xsl:template match="datafield[@tag=('700', '710')]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4e', '7', '8', 'k', 'o', 'v', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 711
      @_marcFields 711
  -->
  <xsl:template match="datafield[@tag='711']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4j', '7', '8', 'k', 'o', 'v', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 730
      @_marcFields 730
  -->
  <xsl:template match="datafield[@tag='730']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '4', '5', '8', 'k', 'o', 'v', '9')" />
    </xsl:call-template>
  </xsl:template>

  <!--
      Sortiere die Subfelder von 751
      @_marcFields 751
  -->
  <xsl:template match="datafield[@tag='751']" mode="sort">
    <xsl:call-template name="mrclib:sortSubfieldsToEnd">
      <xsl:with-param name="sortSpec" select="('0', '1', '2', '3', '4e', '7', '8', '9')" />
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

  <!--
      Sortiere die Subfelder von `9700#$$aAI-Assistant ...` in der Reihenfolge `aiyr`
  -->
  <xsl:template match="datafield[@tag='970'][subfield[@code='a'][.='AI-Assistant']]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfields">
      <xsl:with-param name="sortSpec" select="'axyir'" />
    </xsl:call-template>
  </xsl:template>


  <!--
      Entferne leere Subfelder.
  -->
  <xsl:template match="datafield/subfield[not(text())]" mode="sort" />

  <!--
      Entferne leere Felder.
  -->
  <xsl:template match="datafield[not(subfield/text())]" mode="sort" />

</xsl:stylesheet>
