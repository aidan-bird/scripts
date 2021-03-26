#!/bin/sh

# Aidan Bird 2021
# 
# make a ramdisk
#

mkdir ~/ramdisk/
sudo mount -o size=15G -t tmpfs none ~/ramdisk/
