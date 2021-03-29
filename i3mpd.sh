#!/bin/sh

# Aidan Bird 2021
# 
# print information about the current mpd status.
# for use in statusbars.

TEXT=$(mpc current -f "[[%artist% - ]%title%]|[%file%]")
if [ -n "$TEXT" ]
then
    STATUS=$(mpc status | grep -q 'playing' || echo 'paused: ')
    echo "$STATUS$TEXT"
fi
