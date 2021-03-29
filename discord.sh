#!/bin/sh

# Aidan Bird 2021
# 
# open discord's web app
#

nohup "$BROWSER" "discordapp.com/login" >/dev/null 2>&1 &
