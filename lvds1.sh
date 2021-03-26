#!/bin/sh

# Aidan Bird 2021
# 
# turn off the vga output and set the display 
# to output to the built-in laptop display.
#

xrandr --output LVDS1 --auto --primary --output VGA1 --off
