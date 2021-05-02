#!/bin/sh

# Aidan Bird 2021
# 
# TRY to download a webpage and convert it into a pdf
#

source "$(dirname "$0")/autils.sh"
MAINFONT='Latin Modern Math'
prog="$(basename "$0")"
cmd_usage="usage: $prog [link to webpage] [OPTIONAL output path = .]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
[ -z "$2" ] && { output_path="$(pwd)/$(random_text 10)$prog.pdf"; } \
    || { output_path="$2"; }
pandoc --highlight-style tango --pdf-engine xelatex --variable \
    mainfont="${MAINFONT}" --variable graphics=yes \
    --variable 'geometry:margin=1in' --variable 'compact-title:yes' -f html \
    -t pdf "$1" >> "$output_path"
exit 0
