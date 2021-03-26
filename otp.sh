#!/bin/sh

# Aidan Bird 2021
#
# list and activate an otp password
#

key="$(find "$PASSWORD_STORE_DIR" -type f -name '*otp*' -exec basename {} \;\
    | sed -r 's/.{4}$//' | rofi -dmenu)"
[ $? -eq 0 ] && pass otp -c "$key"
