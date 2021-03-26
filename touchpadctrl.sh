#!/bin/sh

# Aidan Bird 2021
# 
# disable the laptop touchpad
#

TPID=$(xinput --list --short | grep "TouchPad")
[ "$?" != 0 ] && exit 1
TPID=$(echo $TPID | sed 's/.*id=//;s/\s.*//;')
case $1 in
    0) xinput --disable $TPID;; # disable
    1) xinput --enable $TPID;; # enable 
esac
[ "$?" != 0 ] && exit 1
exit 0
