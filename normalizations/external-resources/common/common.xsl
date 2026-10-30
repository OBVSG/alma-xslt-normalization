<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                exclude-result-prefixes="xs utils mrclib"
                expand-text="yes"
                version="3.0">

  <xsl:mode on-no-match="shallow-copy" />
  <!--~doc:stylesheet
      Gemeinsame Transformationen für SRU-Importe
      @title: Gemeinsame Transformationen für SRU-Importe
  -->

  <!--
      Filtere unerwünsche Werte in `653$$a`.
      @_marcFields 653
  -->
  <xsl:variable name="antipatterns653Sfa"
                select="('[Rr]abatt|[Hh]ardcover|[Ss]oftcover|[Tt]aschenb[uü]ch|[Pp]aperback|[Nn]euerscheinung|[Pp]roduktgruppe|[Nn]onbook',
                        '(^| )[Ee]-?[Bb]ook',
                        '^\)',
                        '^[A-Z]{3}[0-9]{4}',
                        '^[0-9]{4}:',
                        '^[0-9]{2}\.[0-9][0-9\.]+:',
                        '^ ?([A-Za-z]+)?[Bb]uch( |$)')" />

  <xsl:template match="datafield[@tag='653']/subfield[@code='a']
                                                     [let $self := .
                                                      return ($antipatterns653Sfa ! matches($self, .)) = true()]" />

  <!--
      Wandle  `&#x98;` (start of string) und `&#x9C;` (string terminator) in Nichtsortierzeichen um.
  -->


</xsl:stylesheet>
