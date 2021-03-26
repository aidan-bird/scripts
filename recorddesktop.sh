#!/bin/sh

# Aidan Bird 2021
# 
# record the laptop screen
#

ffmpeg -video_size 1366x768 -f x11grab -i :0.0 -c:v libx264rgb -crf 0 \
    -preset ultrafast output.mp4
# alias recorddesktop="ffmpeg -f x11grab -s 1366x768 -i :0.0 -r 25 -vcodec libx264 output.mkv"
# alias recorddesktop="ffmpeg -framerate 15 -video_size 1366x768 -f x11grab -i :0.0 -c:v libx264rgb -crf 0 -preset ultrafast output.mp4"
