#!/bin/sh

# Aidan Bird 2021
#
# convert a video file into a webm
#

cmd_usage="usage: $(basename "$0") [VIDEO FILE]"
[ $# -lt 1 ] && echo "$cmd_usage" && exit -1
ffmpeg -i "$1" -c:v libvpx -c:a libvorbis -crf 4 -vf scale=-1:480 -f webm "$1".webm
# ffmpeg -i "$1" -c:v libvpx -c:a libvorbis -crf 4 -b:v 1500K -vf scale=-1:480 "$1".webm
