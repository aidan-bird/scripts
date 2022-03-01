#!/bin/sh

# Aidan Bird 2021
# 
# change the volume and update the status bar
#

case $1 in
	0)  pamixer -i 2 ;; # volup
	1)  pamixer -d 2 ;; # voldwn
	2)  	# volmute
		[ "$(pamixer --get-mute)" = "true" ] && pamixer -u || pamixer -m;;
esac
pkill -RTMIN+10 $STATUSBAR
