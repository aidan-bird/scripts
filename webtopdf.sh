#!/bin/sh

# Aidan Bird 2021
# 
# TRY to download a webpage and convert it into a pdf
#

MAINFONT='Latin Modern Math'

[ "$#" -ne 1 ] && exit 1
pandoc --highlight-style tango --pdf-engine xelatex --variable \
    mainfont="${mainfont}" --variable graphics=yes \
    --variable 'geometry:margin=1in' --variable 'compact-title:yes' -f html \
    -t pdf $1 | zathura -
exit 0
