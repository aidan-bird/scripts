#!/bin/sh

# Aidan Bird 2021 
#
# compile a latex project 
#

. "$(dirname "$0")/autils.sh"
octaveFigurePrefix="fig"
prog="$(basename "$0")"
cmd_usage="usage: $prog [Path to latex file] [OPTIONAL output DIRECTORY or FILE.pdf]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
doc_name="$(basename "$1" '.tex')"
output_dir="$(getOutputFilePath "$2" ".pdf" "$doc_name")"
proj_path="$(dirname "$1")"
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" 0 2 3 15
cp -r "$proj_path" "$temp_dir" || { echo "$prog: Can't copy project files!"; \
    exit 1; }
src_dir="$(find "$temp_dir" -type f -name "$doc_name.tex" -exec dirname {} \; -quit)" \
    || { echo "$prog: cannot find $doc_name.tex"; exit 1; }
find "$src_dir" -type f -name "$octaveFigurePrefix*.m" -exec octave --no-gui --norc -q -H {} \; \
    || { echo "$prog: Can't compile octave figures!"; }
latexmk -cd -bibtex -g -latexoption="--interaction=nonstopmode" -latex=xelatex \
    -pdfxe -output-directory="$src_dir" "$src_dir/$doc_name.tex" \
    || { echo Cannot compile document!!; exit 1; }
find "$src_dir" -type f -name "$doc_name.pdf" -exec cp {} "$output_dir" \; -quit
echo "$prog: copied $doc_name.pdf to $output_dir"
exit 0
