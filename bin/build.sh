#!/usr/bin/bash

rm -rf test/*
# build distributable files and tests
saxon-xslt -xsl:xslt-bundler/xslt-bundler.xsl -it:main configFile=../config.xml distComment="$(git log -n 1 --decorate=full)"

# run tests
export TEST_DIR="test/xspec"
bash temp/testrunner.sh
