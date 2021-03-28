#!/bin/sh

# Aidan Bird 2021
# 
# list network connections and connect to one
#

SSID=$(nmcli -t -f name con | fzf)
[ $? -eq 0 ] && nmcli con up "$SSID" || exit 1
