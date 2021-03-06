#!/bin/sh

# Aidan Bird 2021 
#
# compile a latex project 
#

. "$(dirname "$0")/autils.sh"
octaveFigurePrefix="fig"
prog="$(basename "$0")"
cmd_usage="usage: $(basename "$0") [Path to latex file] [OPTIONAL output DIRECTORY or FILE.pdf]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
doc_name="$(basename "$1" '.tex')"
output_dir="$(getOutputFilePath "$2" ".pdf" "$doc_name")"
proj_path="$(dirname "$1")"
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" 0 2 3 15
cp -r "$proj_path" "$temp_dir" || { echo "$prog: Can't copy project files!"; \
    exit 1; }
cd "$(find "$temp_dir" -type f -name "$doc_name.tex" -exec dirname {} \; -quit)" \
    || { echo "$prog: cannot find $doc_name.tex"; exit 1; }
src_dir="$(pwd)"
find . -type f -name "$octaveFigurePrefix*.m" -exec octave --no-gui --norc -q -H {} \; \
    || { echo "$prog: Can't compile octave figures!"; }
# clean up intermediate figure files
# find . -type f -name "fig*.tex" -exec rm {} \+
pdflatex -halt-on-error -output-directory="$src_dir" "$doc_name.tex" \
    || { echo "$prog: Can't compile document (pass 1)!"; exit 1; }
biber --input-directory "$src_dir" --output-directory "$src_dir" "$doc_name" \
    || echo "$prog: Can't compile bibliography!"
pdflatex -halt-on-error -output-directory="$src_dir" "$doc_name.tex" \
    || { echo "$prog: Can't compile document (pass 2)!"; exit 1; }
# pdflatex -halt-on-error -output-directory="$src_dir" "$doc_name.tex" \
#     || { echo "$prog: Can't compile document (pass 3)!"; exit 1; }
find . -type f -name "$doc_name.pdf" -exec cp {} "$output_dir" \; -quit
echo "$prog: copied $doc_name.pdf to $output_dir"
exit 0
