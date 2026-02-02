#!/usr/bin/env bash

MMSID="$1"
curl -s https://obv-at-obvsg.alma.exlibrisgroup.com/view/sru/43ACC_NETWORK\?version\=1.2\&operation\=searchRetrieve\&recordSchema\=marcxml\&query\=mms_id\="$MMSID" | saxon-xslt -s:- scripts/strip_sru.xsl | xclip -selection clipboard
       
#	wl-copy
