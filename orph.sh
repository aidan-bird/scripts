#!/bin/sh

# Aidan Bird 2021
# 
# list and optionally remove orphan packages
#

cmd_usage="usage: $(basename "$0") [r remove orphans]"

>&2 echo "$cmd_usage"
[ "$1" = 'r' ] && sudo pacman -Rns $(pacman -Qtdq) || pacman -Qtdq
exit 0
