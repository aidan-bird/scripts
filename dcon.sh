#!/bin/sh

# Aidan Bird 2021
# 
# disconnect the first nic from a network
#

nmcli -t -g name con | sed 1q | xargs -I'{}' nmcli con down '{}'
