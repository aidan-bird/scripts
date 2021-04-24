#!/bin/sh

# Aidan Bird 2021
# 
# convert the flac files in an album to high-fidelity mp3 files
#

src_wd="$(pwd)"
prog="$(basename "$0")"
cmd_usage="usage: $prog [album path]"
file_ext="flac"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
src_path="$1"
tmp_dir="$(mktemp -d)" \
    || { echo "$prog: cannot create temporary directory"; exit 1; }
trap "rm -rf $tmp_dir" 0 2 3 15
cp -r "$src_path"/* "$tmp_dir" \
    || { echo "$prog: cannot copy files to temporary directory"; exit 1; }
LC_ALL=C find "$tmp_dir" -name "*.$file_ext" -print0 | xargs -P 0 -o -0 -I '{}' \
    sh -c "fname=\"\$(echo \"{}\" | sed -e \"s/\.$file_ext$/.mp3/\")\"; 
    ffmpeg -i \"{}\" -ab 320k -map_metadata 0 -id3v2_version 3 \"\$fname\";
    rm \"{}\";"
cp -r "$tmp_dir" "$src_path.mp3"
exit 0

