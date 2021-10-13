#!/bin/sh

#
# aidan bird 2021
#
# register new two factor authentication qr code
#

prog="$(basename "$0")"
cmd_usage="usage: $prog [pass name] [qr code]"
[ -z "$1" ] && { echo "$cmd_usage"; exit 1; }
[ -z "$2" ] && { echo "$cmd_usage"; exit 1; }
tmp_file="$(mktemp "/tmp/$prog.XXXXXX")"
trap "shred -zu $tmp_file" 0 2 3 15
zbarimg -q --raw "$2" >> "$tmp_file"
[ $? != 0 ] && { echo "$prog: cannot read qr code."; exit 1; }
pass otp insert "$1" < "$tmp_file"
[ $? != 0 ] && { echo "$prog: cannot register 2FA code."; exit 1; }
exit 0
