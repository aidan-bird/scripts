#!/bin/sh

# Aidan Bird 2021
# 
# set the desktop wallpaper
#

[ "$#" -eq 1 ] && cp "$1" ~/.config/wall.png
xwallpaper --stretch ~/.config/wall.png
