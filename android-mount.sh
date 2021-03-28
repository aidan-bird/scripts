#!/bin/sh
# mount android devices

cmd_usage="usage: $(basename "$0") [MOUNT PATH]"

if [ $# -eq 0 ]
then
    echo "$cmd_usage"
    simple-mtpfs -l
    exit 0
fi
simple-mtpfs -l | fzf | awk '{print $1}' | tr ':' ' ' | xargs -I{} simple-mtpfs --device {} $1
exit 0

