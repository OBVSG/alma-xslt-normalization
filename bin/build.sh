#!/usr/bin/bash

rm -rf test/*
# build distributable files and tests
xslbundler -c config.xml -n "$(git log -n 1 --decorate=full)"

# run tests
export TEST_DIR="dist/test/xspec"
bash temp/testrunner.sh
