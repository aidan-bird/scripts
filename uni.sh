#!/bin/sh

# Aidan Bird 2021
# 
# open the university's login page
#

nohup "$BROWSER" "$UNI_URL" >/dev/null 2>&1 &
