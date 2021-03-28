#!/bin/sh

# Aidan Bird 2021
#
# compile a latex project 
#

prog="$(basename "$0")"
output_dir="$(realpath .)"
cmd_usage="usage: $(basename "$0") [Path to latex file] [OPTIONAL Output Directory]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
[ "$2" != '' ] && output_dir="$(realpath "$2")"
doc_name="$(basename "$1" '.tex')"
proj_path="$(dirname "$1")"
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" 0 2 3 15
cp -r "$proj_path" "$temp_dir"
[ $? != 0 ] && { echo "$prog: Can't copy project files!"; exit 1; }
cd "$(find "$temp_dir" -type f -name "$doc_name.tex" -exec dirname {} \; -quit)"
src_dir="$(pwd)"
find . -type f -name '*.m' -exec octave --no-gui --norc -q -H {} \+
[ $? != 0 ] echo "$prog: Can't compile octave figures!"
pdflatex -halt-on-error -output-directory="$src_dir" "$doc_name.tex"
[ $? != 0 ] && { echo "$prog: Can't compile document (pass 1)!"; exit 1; }
biber --input-directory "$src_dir" --output-directory "$src_dir" "$doc_name"
[ $? != 0 ] && echo "$prog: Can't compile bibliography!"
pdflatex -halt-on-error -output-directory="$src_dir" "$doc_name.tex"
[ $? != 0 ] && { echo "$prog: Can't compile document (pass 2)!"; exit 1; }
pdflatex -halt-on-error -output-directory="$src_dir" "$doc_name.tex"
[ $? != 0 ] && { echo "$prog: Can't compile document (pass 3)!"; exit 1; }
find . -type f -name "$doc_name.pdf" -exec cp {} "$output_dir" \; -quit
echo "$prog: copied $doc_name.pdf to $output_dir/$doc_name.pdf"
exit 0
