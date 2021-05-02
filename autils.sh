#!/bin/sh

# Aidan Bird 2021
# 
# Contains some useful functions. 
# This file should not be made executable.
#
# HOW TO USE: 
# Assuming that the calling script is in the same directory as this file; run
# 
# source "$(dirname "$0")/autils.sh"
#

# REQUIRES: first parameter must be a number
# MODIFIES: none
# EFFECTS: prints a string of length $1 containing random alpha numeric 
# characters (base32)
random_text() {
    echo "$(head -c "$1" /dev/urandom | base32 | head -c "$1")"
}

