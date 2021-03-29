#!/bin/sh

# Aidan Bird 2021
# 
# fix broken music file names
#

src_wd="$(pwd)"
prog="$(basename "$0")"
cmd_usage="usage: $prog [file extension (not including the '.')] [music directory path]"
file_ext="$1"
src_path="$2" 
[ $# -lt 2 ] && { echo "$cmd_usage"; exit 1; }
tmp_dir="$(mktemp -d)" \
    || { echo "$prog: cannot create temporary directory"; exit 1; }
trap "rm -rf $tmp_dir" 0 2 3 15
cp -r "$src_path"/* "$tmp_dir" \
    || { echo "$prog: cannot copy files to temporary directory"; exit 1; }
find "$tmp_dir" -name "*.$file_ext" -print0 | xargs -P 0 -o -0 -I '{}' \
    sh -c "fname=\"\$(exiftool \"{}\" | grep -i title | sed -e \"s/Title.*: //\").$file_ext\"; 
    echo \"$prog: renaming '\$(basename \"{}\")' to '\$fname'\";
    mv \"{}\" $tmp_dir/\"\$fname\";"
cp -r "$tmp_dir" "$src_path.norm"
exit 0
