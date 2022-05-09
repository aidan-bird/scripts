#!/bin/sh

# Aidan Bird 2022
#
# unzip all zip files in a directory.
# this script does not descend into subdirectories.
#

parallel=1

me="$(basename "$0")"
. "$(dirname "$0")/autils.sh"
cmd_usage="usage: $me [Path to directory of zip files] [OPTIONAL output directory]"
# print usage on bad invocation 
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
# set output_dir
[ -z $2 ] && { output_dir="."; } || { output_dir="$2"; }
# new tmpdir; it deletes itself
tmp_dir=$(mktemp -d)
trap "rm -rf $tmp_dir" 0 2 3 15
# copy files to tmpdir
find "$1" -maxdepth 1 -name '*.zip' -type f -exec cp {} "$tmp_dir" \;

# unzip
unzipexec="dir=\"\$(echo \"{}\" | sed \"s/.zip$//\")\"; mkdir \"\$dir\"; unzip \"{}\" -d \"\$dir\"; rm \"{}\";"
if [ $parallel -eq 0 ]
then
    find "$tmp_dir" -maxdepth 1 -name '*.zip' -exec sh -c "$unzipexec" \;
else
    echo "$me: Unzipping in parallel."
    find "$tmp_dir" -maxdepth 1 -name '*.zip' -print0 | xargs -0 -P 0 -I '{}' sh -c "$unzipexec"
fi

# copy to output directory
cp -r "$tmp_dir" "$output_dir"
exit 0
