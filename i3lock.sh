#!/bin/sh

# Aidan Bird 2021
# 
# mute the sound, pause the music, and lock the system
#

mpc pause
pamixer -m
slock & xset dpms force off
