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

# $1 = deepest path
# $2 = shallow path 
#
# WHERE $2 is a proper subset of $1. 
# That is, $1 starts with $2, and $1 != $2.
#
# EXAMPLE: /a/b/d/e/f/file /a/b -> /a/b/d
# returns 1 on fail
# returns 0 on pass
eldestChild() {
    ([ -z "$1" ] || [ -z "$2" ]) && { return 1; }
    [ "$1" = "$2" ] && { return 1; }
    (echo "$1" | grep -q -s -m 1 "^$2") || { return 1; }
    x="$1"
    while [ "$x" != "$2" ]
    do
        y="$x"
        x="$(dirname "$x")"
    done
    echo "$y"
    return 0
}

