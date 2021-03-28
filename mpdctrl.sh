#!/bin/sh

# Aidan Bird 2021
# 
# DEPRECATED
#

case $1 in
	0)  mpc next ;; # next
	1)  mpc prev ;; # prev
	2)  mpc play;; #play
	3)  mpc pause;; #pause
esac
pkill -RTMIN+11 i3blocks
