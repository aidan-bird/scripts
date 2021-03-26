#!/bin/sh

# Aidan Bird 2021
# 
# changes the laptop display backlight
#

[ "$#" -ne 1 ] && xbacklight ||  xbacklight -set $1
exit 0
