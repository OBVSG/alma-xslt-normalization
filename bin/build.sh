#!/usr/bin/bash

# build distributable files and tests
saxon -xsl:build/build.xsl -it:main configFile=../config.xml

# run tests
export TEST_DIR="test/xspec"

xspec.sh -j -e test/OBV_normalize-on-save/OBV_normalize-on-save.xspec
xspec.sh -j -e test/OBV_aufsatz-ableiten-p/OBV_aufsatz-ableiten-p.xspec
xspec.sh -j -e test/OBV_schreibvorlage/OBV_schreibvorlage.xspec
