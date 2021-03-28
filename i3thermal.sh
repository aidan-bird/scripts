#!/bin/sh

# Aidan Bird 2021
# 
# print the cpu temperature
#

use_html=0
TEMPS=$(sensors "coretemp-isa-0000" -u | awk '/temp1_input/ {print $2}' | awk -F. '{print $1}' | tr -d '\n')

if [ $use_html -eq 1 ]
then
    # for use in i3
    # DEPRECATED
    [ "$TEMPS" -ge 60 ] && color="#FF0000" || color="#FFFFFF"
    echo  "<span color='$color'> CPU $TEMPS°C</span>"
else
    echo  CPU $TEMPS°C
fi
