#!/bin/dash

# Aidan Bird
#
# statusbar for dwm
#

export musvolume="$(i3vol.sh)"
export current_song="$(i3mpd.sh)"
export now=0
export load=0
export battery=0
export divider="      |      "
# set current song on signal
trap "current_song=\"\$(i3mpd.sh)\" ; xsetroot -name \"\$current_song\$divider\$musvolume\$divider\$load\$divider\$battery\$divider\$now\" ;" RTMIN+11
# set music volume on signal
trap "musvolume=\"\$(i3vol.sh)\" ; xsetroot -name \"\$current_song\$divider\$musvolume\$divider\$load\$divider\$battery\$divider\$now\" ;" RTMIN+10

while [ 1 ]
do
    # mpd + vol + load + batt + time
    # date & time
    now="$(date --iso-8601=minutes | sed 's/^\(.*\)T\(.*\)-.*/\1    \2/')"
    # load average
    load="LOAD $(uptime | sed 's/.*load average: //;s/, .*, .*//')"
    # battery and charging status
    battery="$(i3batt.sh)"
    statusbar="$current_song$divider$musvolume$divider$load$divider$battery$divider$now"
    xsetroot -name "$statusbar"
    sleep 1 &
    wait $!
done
