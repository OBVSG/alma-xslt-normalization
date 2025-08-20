#!/usr/bin/bash

rm -rf test/*
# build distributable files and tests
saxon-xslt -xsl:build/build.xsl -it:main configFile=../config.xml

# run tests
export TEST_DIR="test/xspec"
bash temp/testrunner.sh
