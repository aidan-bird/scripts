#!/bin/sh

# Aidan Bird 2021
# 
# Print volume information about the sound system.
# for use in statusbars.

[ $(pamixer --get-mute) == "true" ] && echo -n "VOL ---" || echo VOL $(pamixer --get-volume)%
