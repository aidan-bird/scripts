#!/bin/sh

# Aidan Bird 2021
#
# preview a latex document; for use in vim.
#

# TODO try storing the hash of the project directory and then compare it with
# the directory in the argument to check if any changes are made. if there are no changes
# then open the pdf file if it already exists.
#
# TODO create a script for comparing directories quickly. use various huristics.
# make it extendable for use in other scripts. this will be used for caching
#

prog="$(basename "$0")"
output_path=/tmp
cmd_usage="usage: $prog [Path to latex file]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
doc_name="$(basename "$1" '.tex')"
compile-latex.sh "$1" "$output_path"
[ $? != 0 ] && exit 1
pgrep -f "$READER .*$doc_name\.pdf"
if [ $? != 0 ]
then
    $READER "$output_path/$doc_name.pdf" &
    disown
fi
exit 0
