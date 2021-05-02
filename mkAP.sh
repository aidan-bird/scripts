#!/bin/sh

# Aidan Bird 2021
# 
# host a wireless network using a wireless nic
#

prog="$(basename "$0")"
cmd_usage="usage: $prog [wireless ifname]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
create_ap -c 1 -w 2 -m none --hidden "$MKAP_CNT_1" "$MKAP_CNT_2" --daemon -g \
    "$MKAP_GATEWAY_ADDR" "$1" "$MKAP_SSID" "$MKAP_PASS"
exit 0
