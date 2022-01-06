#!/bin/sh

# Aidan Bird 2021
# 
# open discord's web app
#

DISCORDAPP='discordapp.com/login'

if [ "$USE_BASICBROWSER" = true ];
then
    basicbrowser.sh "$DISCORDAPP"
else
    nohup "$BROWSER" "$DISCORDAPP" >/dev/null 2>&1 &
fi
