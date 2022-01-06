#!/bin/sh

# Aidan Bird 2021
# 
# open the university's login page
#

if [ "$USE_BASICBROWSER" = true ];
then
    basicbrowser.sh "$UNI_URL"
else
    nohup "$BROWSER" "$UNI_URL" >/dev/null 2>&1 &
fi
