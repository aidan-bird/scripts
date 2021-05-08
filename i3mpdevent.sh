#!/bin/sh

# Aidan Bird 2021
# 
# send a signal to the statusbar telling it 
# to update the currently playing song.
# originally used with i3, now it is used with my configuration of dwmblocks


while [ 1 ]
do
mpc idle player
pkill -RTMIN+11 dwmblocks
current_song="$(mpc current -f "[[%artist% - ]%title%]|[%file%]")"
if [ "$last_song" != "$current_song" ]
then
    notifyMPDPlaying.sh
fi
last_song="$current_song"
done
