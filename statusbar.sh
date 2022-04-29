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


# txrx="$(awk 'BEGIN { txsum=0; rxsum=0 } NR!~/(1|2)$/ { txsum+=$2 ; \
#     rxsum+=$10 } END { print txsum ; print rxsum } ' < /proc/net/dev)"
# lastTx="$(echo "$txrx" | sed '1q')"
# lastRx="$(echo "$txrx" | sed -n '2p')"
# tx=0
# rx=0
# txrxScale=1024
# txrxScaleLabel="KB/s"

while [ 1 ]
do
    # mpd + vol + tx rx + load + batt + time
    # date & time
    now="$(date --iso-8601=minutes | sed 's/^\(.*\)T\(.*\)-.*/\1    \2/')"
    # load average
    load="LOAD $(uptime | sed 's/.*load average: //;s/, .*, .*//')"
    # battery and charging status
    battery="$(i3batt.sh)"
    # tx rx
    # txrx="$(awk 'BEGIN { txsum=0; rxsum=0 } NR!~/(1|2)$/ { txsum+=$2 ; \
    #     rxsum+=$10 } END { print txsum ; print rxsum } ' < /proc/net/dev)"
    # txrxRate="$(echo "$txrx" | sed "s/\(.*\)/(\1 - AAAA)\/$txrxScale;\1;/;1s/AAAA/$lastTx/;1s/^/scale=2;/;2s/AAAA/$lastRx/" | bc -l)"
    # deltaTx="$(echo "$txrxRate" | sed '1q')"
    # deltaRx="$(echo "$txrxRate" | sed -n '3p')"
    # lastTx="$(echo "$txrxRate" | sed -n '2p')"
    # lastRx="$(echo "$txrxRate" | sed -n '4p')"
    # txrxPrint="$(printf "tx: %-15srx: %-15s$txrxScaleLabel" "$deltaTx" "$deltaRx")"
    # statusbar="$current_song$divider$musvolume$divider$txrxPrint$divider$load$divider$battery$divider$now"
    statusbar="$current_song$divider$musvolume$divider$load$divider$battery$divider$now"
    xsetroot -name "$statusbar"
    sleep 1 &
    wait $!
done
