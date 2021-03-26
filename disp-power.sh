#!/bin/sh

# Aidan Bird YEAR
# 
# turn the laptop display on or off
#

case "$1" in
    "off")
        xset dpms force off;
        ;;
    "on")
        xset dpms force on;
        ;;
esac

