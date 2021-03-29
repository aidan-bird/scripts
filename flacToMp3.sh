#!/bin/sh

# Aidan Bird 2021
# 
# convert the flac files in an album to high-fidelity mp3 files
#

prog="$(basename "$0")"
src_ext="flac"
cmd_usage="usage: $prog [album path]"
[ $# -lt 1 ] && { echo "$prog: $cmd_usage"; exit 1; }
files=$(printf '%q' "$1" | xargs -I '{}' find '{}' -type f -name "*.$src_ext")
IFS="$(printf "\nx")"
for x in $files
do
    filename=$(echo "$x" | sed "s/.$src_ext//")
    ffmpeg -i "$filename.$src_ext" -ab 320k -map_metadata 0 -id3v2_version 3 \
        "$filename.mp3" || { echo "$prog: Failed to convert $filename.$src_ext! Quitting."; \
        exit 1; }
done
# rm ./*.$src_ext
exit 0
