#!/bin/sh

# Aidan Bird 2021
#
# presented a list of keys to add to the ssh-agent instance.
#

progname="$(basename "$0")"
sec_path=~/sec
[ "$1" != '' ] && sec_path="$1"
cmd_usage="usage: $progname [sec path = ~/sec]"
pgrep 'ssh-agent' 2>&1 >> /dev/null || { echo "$progname: no ssh-agent instance"; exit 1; }
keys="$(find ~/sec/key -type f -exec file {} \+ | grep 'OpenSSH private key' \
    | sed 's/: *OpenSSH private key//')"
[ "$keys" = '' ] && exit 1
key_select="$(echo "$keys" | fzf)" || exit 1
ssh-add "$key_select" || { echo "$progname: failed to add key $key_select"; exit 1; }
echo "$progname: added key $key_select"
exit 0
