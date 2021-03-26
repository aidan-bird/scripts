#!/bin/sh

# Aidan Bird 2021
# 
# get the current laptop battery capacity
#

battery_cap='/sys/class/power_supply/BAT0/capacity'
battery_stat='/sys/class/power_supply/BAT0/status'

NUM=$(cat "$battery_cap")
[ $? != 0 ] && exit
STATUS=$(cat "$battery_stat")
[ "$STATUS" == "Charging" ] && NUM="$NUM+"
echo "BATT $NUM"
