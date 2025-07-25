#!/usr/bin/bash

# run tests
export TEST_DIR="test/xspec"

xspec.sh -j test/OBV_normalize-on-save/OBV_normalize-on-save.xspec
xspec.sh -j test/OBV_aufsatz-ableiten-p/OBV_aufsatz-ableiten-p.xspec
xspec.sh -j test/OBV_schreibvorlage/OBV_schreibvorlage.xspec
