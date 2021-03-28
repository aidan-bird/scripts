#!/bin/sh

# Aidan Bird 2021
# 
# delete image metadata
#

prog="$(basename "$0")"
cmd_usage="usage: $prog [image path]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
exiftool -overwrite_original -all= "$1"
cp "$1" "$1".clean
exit 0 
