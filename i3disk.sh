#!/bin/sh

# Aidan Bird 2021
# 
# print formatted disk usage
#

ROOT=$(df -h | awk '/\/dev\/sda3/ {print $5}')
HOME=$(df -h | awk '/\/dev\/sda4/ {print $5}')
echo "/ $ROOT ~ $HOME"
