#!/bin/sh

# Aidan Bird 2021
#
# Makes the binaries needed for some scripts. 
# The binaries are stored in bin.
#

bin_dir=bin
find utils -type f -name 'makefile' -print0 \
    | xargs -P 0 -0 -I '{}' sh -c \
    "utilroot=\"\$(dirname \"{}\")\";
    bin=\"\$(basename \"\$utilroot\")\";
    echo \"{}\";
    make -C \"\$utilroot\";
    cp ./\"\$utilroot/\$bin\" ./\"$bin_dir\"/;"
