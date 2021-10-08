#!/bin/sh

# Aidan Bird 2021 
#
# check grammar using languagetool
#

prog="$(basename "$0")"
cmd_usage="usage: $prog [TEX File]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
tmp_file="$(mktemp "/tmp/$prog.XXXXXX")"
trap "rm -f $tmp_file" 0 2 3 15
pandoc "$1" --to=plain >> "$tmp_file"
languagetool -d 'WHITESPACE_RULE,DASH_RULE[1],DASH_RULE[2],EN_SPECIFIC_CASE,UPPERCASE_SENTENCE_START' "$tmp_file"
exit 0
