#!/bin/sh

# Aidan Bird 2021
# 
# turn off the laptop screen and set the display output to vga
#

xrandr --output VGA1 --auto --primary --output LVDS1 --off
