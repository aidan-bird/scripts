#!/bin/sh

# Aidan Bird 2021
# 
# set the wallpaper to a random image in the wallpaper directory
#

wallpaper_dir=~/img/wallpaper
file_paths="$(find $wallpaper_dir -type f)"
file_count="$(echo "$file_paths" | wc -l)"
index="$(expr $RANDOM % $file_count + 1)"
img="$(echo "$file_paths" | sed "$index p;d")"
xwallpaper --stretch "$img"
