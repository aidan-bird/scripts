#!/bin/sh

# Aidan Bird 2021
#
# preview a latex document
#
# can be used with vim e.g. in vimrc,
# autocmd FileType tex map <F5> :!preview-latex.sh<space>%:p<CR>
# 

prog="$(basename "$0")"
output_path=/tmp
cmd_usage="usage: $prog [Path to latex file]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
doc_name="$prog$(realpath "$(basename "$1" '.tex')" | md5sum | sed 's/ .*//').pdf"
compile-latex.sh "$1" "$output_path/$doc_name"
[ $? != 0 ] && { echo "$prog: Failed to compile document."; exit 1; }
pgrep -f "$READER .*$doc_name"
if [ $? != 0 ]
then
    $READER "$output_path/$doc_name" &
    disown
fi
exit 0
