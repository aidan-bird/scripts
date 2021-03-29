#!/bin/sh

# Aidan Bird 2021
#
# Automatically generate a pdf containing a selection of images.
# This script is intended to be used to create test submissions containing
# pictures of written work for online exams.
#
# requires a latex installation

# TODO caching for a speed up

prog="$(basename "$0")"
title='Assignment Submission'
[ "$3" != '' ] && title=$3
cmd_usage="usage: $prog [image path] [output name] [OPTIONAL title]"
latex_header="\\documentclass[10pt,a4paper]{article}
\\usepackage{datetime}
\\usepackage{pdfpages}
\\newdateformat{autodate}{\\THEDAY~\\monthname[\\THEMONTH] \\THEYEAR}
\\begin{document}
\\title{$title}
\\author{$MKTESTPAPER_AUTHOR}
\\date{\\autodate\\today}
\\maketitle
\\newpage"
latex_fig_start="\\includepdf{"
latex_fig_end="}"
latex_doc_end="\\end{document}"
tmp_dir="/run/user/$(id -u)/$prog"
fig_dir="$tmp_dir/figures"
out_dir="$tmp_dir/out"
doc_code="$latex_header"

[ $# -lt 2 ] && { echo "$cmd_usage"; exit 1; }
[ ! -d "$tmp_dir" ] && mkdir -p "$tmp_dir"
[ ! -d "$fig_dir" ] && mkdir -p "$fig_dir" || rm -f "$fig_dir"/*
[ ! -d "$out_dir" ] && mkdir -p "$out_dir" || rm -f "$out_dir"/*
trap "rm -rf $tmp_dir" 0 2 3 15
img_path=$(realpath "$1")
output_path="$2"
# only display the files created in the last 3 hours
image_list="$(find "$img_path" -type f -cmin -180 -print | sxiv -i -t -o)"
[ ! "$image_list" ] && { echo "$cmd_usage"; exit 1; }
IFS="$(printf "\nx")"
i=0
for x in $image_list
do
    # use low quality images to make output smaller and improve upload time.
    convert "$x" -auto-orient -compress JPEG -quality 30 -format pdf \
        "$fig_dir/$i".pdf
    doc_code="${doc_code}$latex_fig_start$fig_dir/$i.pdf$latex_fig_end"
    i=$(($i + 1))
done
doc_code="${doc_code}$latex_doc_end"
echo "$doc_code" > "$tmp_dir"/doc.tex
# compile document
pdflatex -halt-on-error -output-directory="$out_dir" "$tmp_dir/doc.tex" \
    || { echo "$prog: Can't compile document!"; exit 1; }
cp "$out_dir/doc.pdf" "$output_path"
echo "$prog: Done compiling document!"
exit 0
