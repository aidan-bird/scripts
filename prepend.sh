#!/bin/sh

# Aidan Bird 2021
# 
# prepend text to file
#

prog="$(basename "$0")"
cmd_usage="usage: $(basename "$0") [file] [text]

example: make files with text prepend to them.
find . -type f | xargs -I '{}' sh -c \"prepend.sh {} 'sample text' > {}.prepended\""
[ $# -lt 1 ] && { >&2 echo "$cmd_usage"; exit 1; }
tmp_file="$(mktemp "/tmp/$prog.XXXXXX")"
trap "rm -f $tmp_file" 0 2 3 15
echo "$2" > "$tmp_file"
cat "$1" >> "$tmp_file"
cat "$tmp_file"
exit 0
