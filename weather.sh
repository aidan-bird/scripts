#!/bin/sh

# Aidan Bird 2021
#
# print a weather report using wttr.in
#
# TODO make a cli argument 'r' which bypasses the caching mechanism
#

prog="$(basename "$0")"
CACHE_PATH=~/.config/weather_report
DELTA=86400

if [ ! -f $CACHE_PATH ] || [ $(expr $(date +'%s') - $(date +'%s' -r $CACHE_PATH)) -gt $DELTA ]
then
    echo "$prog: updating cache"
    curl -s 'wttr.in' > "$CACHE_PATH"
    [ "$?" != 0 ] && { echo "$prog: update failed"; exit 1; }
    echo "$prog: updated cache"
fi
cat $CACHE_PATH
exit 0;
