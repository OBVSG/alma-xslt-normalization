#!/usr/bin/env sh

saxon-xslt -s:normalizations/on-save/normalize-on-save.xsl build/build.xsl > dist/OBV_KATA_XSLT.xsl
saxon-xslt -s:normalizations/derive-record/schreibvorlage/schreibvorlage.xsl build/build.xsl > dist/OBV_Schreibvorlage_XSLT.xsl
saxon-xslt -s:normalizations/derive-record/aufsatz-p/aufsatz-p.xsl build/build.xsl > dist/OBV_Aufsatz_Ableiten_XSLT.xsl
