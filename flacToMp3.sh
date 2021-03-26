#!/bin/sh

# Aidan Bird 2021
# 
# convert the flac files in an album to high-fidelity mp3 files
#

src_ext="flac"
cmd_usage="usage: $(basename "$0") [album path]"
[ $# -lt 1 ] && echo "$cmd_usage" && exit -1
files=$(printf '%q' "$1" | xargs -I '{}' find '{}' -type f -name "*.$src_ext")
IFS=$'\n'
for x in $files
do
    filename=$(echo "$x" | sed "s/.$src_ext//")
    ffmpeg -i $filename.$src_ext -ab 320k -map_metadata 0 -id3v2_version 3 $filename.mp3
    [ $? -ne 0 ] && echo "Failed to convert $filename.$src_ext! Quitting." && exit -1 
done
rm *.$src_ext
