#!/bin/sh

# Aidan Bird 2021
# 
# print formatted memory usage
#

use_html=0
MEM="$(free -m | awk 'NR==2{printf "%.1f", $3/1024 }')"

if [ $use_html -eq 1 ]
then
    # for use in i3
    # DEPRECATED
    [ "$(echo "$MEM" | awk -F. '{print $1}')" -ge 6 ] && color="#FF0000" \
        || color="#FFFFFF"
    echo "<span color='$color'> MEM $MEM G</span>"
else
    echo "MEM $MEM G"
fi
