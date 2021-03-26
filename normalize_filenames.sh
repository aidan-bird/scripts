#!/bin/sh

# Aidan Bird 2021
# 
# fix broken music file names
#

cmd_usage="usage: $(basename "$0") [file extension] [music directory path] [OPTIONAL: no clobber -n]"
file_ext="$1"
cpy_path="$(id -u)$(basename $0)"
src_path="$2" 

[ $# -lt 2 ] && echo "$cmd_usage" && exit -1
[ "$3" == "-n" ] && cp -r "$src_path" "$cpy_path" || cpy_path=$src_path
cd "$cpy_path"
for x in *$file_ext
do
    song_name=$(exiftool "$x" | grep 'Title ' | sed 's/Title.*: //')
    echo "renaming $x to $song_name$file_ext"
    mv -n "$x" "$song_name$file_ext"
done
file=$(find . -name '*.flac' -print -quit)
albumName=$(echo "$file" | xargs -I '{}' exiftool '{}' | grep 'Album ' | sed 's/Album.*: //')
albumArtistName=$(echo "$file" | xargs -I '{}' exiftool '{}' | grep 'Albumartist ' | sed 's/Albumartist.*: //')
cd ..
mv -n "$cpy_path" "$albumArtistName - $albumName"
exit 0
