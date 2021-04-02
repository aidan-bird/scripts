#!/bin/sh

# Aidan Bird 2021
#
# list and activate an otp password
#
key="$(find "$PASSWORD_STORE_DIR" -type f -name '*otp*' -exec basename {} \;\
    | sed -r 's/.{4}$//' | rofi -dmenu)" && pass otp -c "$key" \
    && notify-send -t 2000 "🔑 Copied $key to clipboard."
exit 0
