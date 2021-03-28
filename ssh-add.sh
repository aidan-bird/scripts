#!/bin/sh

# Aidan Bird 2021
#
# presented a list of keys to add to the ssh-agent instance.
#

prog="$(basename "$0")"
sec_path=~/sec
[ "$1" != '' ] && sec_path="$1"
cmd_usage="usage: $prog [sec path = ~/sec]"
pgrep 'ssh-agent' 2>&1 >> /dev/null || { echo "$prog: no ssh-agent instance"; exit 1; }
keys="$(find ~/sec/key -type f -exec file {} \+ | grep 'OpenSSH private key' \
    | sed 's/: *OpenSSH private key//')"
[ "$keys" = '' ] && exit 1
key_select="$(echo "$keys" | fzf)" || exit 1
ssh-add "$key_select" || { echo "$prog: failed to add key $key_select"; exit 1; }
echo "$prog: added key $key_select"
exit 0
