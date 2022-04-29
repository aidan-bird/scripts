#!/bin/sh

# Aidan Bird 2022
#
# convert a video file to a webm suitable for embedding on discord  
#

# ############# CONFIG #############
# audio bitrate in KB
audio_bitrate=48
# target file size in MB
target_size=8
# ##################################

output_file=""
me="$(basename "$0")"
usage="usage: $me [video file] [optional output name]"
[ $# -lt 1 ] && { echo "$usage"; exit 1; }
[ $# -lt 2 ] && { output_file="$(echo "$1" \
    | sed 's/\(.*\)\..*$/\1-discord/')" ; } || { output_file="$2" ; }
duration="$(ffprobe -show_format "$1" 2> /dev/null \
    | sed '/duration=*/!d;s/duration=//')"
# compute video bitrate in KB
video_bitrate="$(echo "scale=5;($target_size * 8000 / $duration - $audio_bitrate) * 0.99;" | bc -l)"
# convert video
ffmpeg -i "$1" -c:v libvpx -b:v "$video_bitrate"K -c:a libvorbis -b:a "$audio_bitrate"K -threads 4 "$output_file.webm"
exit 0
