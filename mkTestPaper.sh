#!/bin/sh

# Aidan Bird 2021
#
# Automatically generate a pdf containing a selection of images.
# This script is intended to be used to create test submissions containing
# pictures of written work for online exams.
#
# requires a latex installation

# TODO caching for a speed up

source "$(dirname "$0")/autils.sh"
prog="$(basename "$0")"
cmd_usage="usage: $prog [image path] [OPTIONAL -o output file] 
    [OPTIONAL -t title] [OPTIONAL -a author] 
    [OPTIONAL -q non-interactive(skip selection)]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
# script error messages
msg_err_args_output_file_1="$prog: -o can only appear once."
msg_err_args_output_file_2="$prog: -o expected file."
msg_err_args_title_1="$prog: -a can only appear once."
msg_err_args_title_2="$prog: -a expected title."
msg_err_args_author_1="$prog: -t can only appear once."
msg_err_args_author_2="$prog: -t expected author."
msg_err_args_unk="$prog: unknown argument"
msg_help_args="$prog: check optional arguments."
msg_err_no_selection="$prog: no image selection."
#
default_title='Assignment Submission'
img_path="$(realpath "$1")"
# flags for keeping track of each type of argument
flag_output_file=0
flag_title=0
flag_author=0
flag_is_quiet=0
is_flags=0
# consume the first argument (input dir)
shift
# parse cli args here 
while [ "$#" -gt 0 ]
do
    case "$1" in
        -o)
            # output file argument
            [ "$flag_output_file" -eq 1 ] \
                && { echo "$msg_err_args_output_file_1"; exit 1; }
            flag_output_file=1
            is_flags=1
            [ -z "$2" ] && { echo "$msg_err_args_output_file_2"; exit 1; }
            output_file="$2"
            shift
            shift
            ;;
        -t) 
            # title argument
            [ $flag_title -eq 1 ] && { echo "$msg_err_args_title_1"; exit 1; }
            flag_title=1
            is_flags=1
            [ -z "$2" ] && { echo "$msg_err_args_title_2"; exit 1; }
            title="$2"
            shift
            shift
            ;;
        -a) 
            # author argument
            [ $flag_author -eq 1 ] \
                && { echo "$msg_err_args_author_1"; exit 1; }
            flag_author=1
            is_flags=1
            [ -z "$2" ] && { echo "$msg_err_args_author_2"; exit 1; }
            author="$2"
            shift
            shift
            ;;
        -q)
            # non-interactive
            flag_is_quiet=1
            is_flags=1
            shift
            ;;
        *)
            # unknown argument
            echo "$msg_err_args_unk $1."
            [ "$is_flags" -eq 1 ] && { echo "$msg_help_args"; } \
                || { echo "$cmd_usage"; }
            exit 1
            ;;
    esac
done
# setup defaults
[ "$flag_output_file" -eq 0 ] \
    && { output_file="$(random_text 10)$prog.pdf"; }
[ "$flag_title" -eq 0 ] && { title="$default_title"; }
[ "$flag_author" -eq 0 ] && { author="$MKTESTPAPER_AUTHOR"; }
# latex template
latex_header="\\documentclass[10pt,a4paper]{article}
\\usepackage{datetime}
\\usepackage{pdfpages}
\\usepackage{hyperref}
\\newdateformat{autodate}{\\THEDAY~\\monthname[\\THEMONTH] \\THEYEAR}
\\begin{document}
\\title{$title}
\\author{$author}
\\date{\\autodate\\today}
\\maketitle
\\newpage"
latex_fig_start="\\includepdf{"
latex_fig_end="}"
latex_doc_end="\\end{document}"
# strip author field if it is not defined
[ -z "$author" ] && { latex_header="$(echo "$latex_header" | sed '8d')"; }
doc_code="$latex_header"
# setup tmpdir
tmp_dir="/run/user/$(id -u)/$prog"
fig_dir="$tmp_dir/figures"
out_dir="$tmp_dir/out"
[ ! -d "$tmp_dir" ] && mkdir -p "$tmp_dir"
[ ! -d "$fig_dir" ] && mkdir -p "$fig_dir" || rm -f "$fig_dir"/*
[ ! -d "$out_dir" ] && mkdir -p "$out_dir" || rm -f "$out_dir"/*
trap "rm -rf $tmp_dir" 0 2 3 15
if [ "$flag_is_quiet" -eq 1 ]
then
    image_list="$(find "$img_path" -type f -cmin -180)"
else
    image_list="$(find "$img_path" -type f -cmin -180 \
        -exec sxiv -p -q -t -o {} \+)"
fi
[ -z "$image_list" ] && { echo "$msg_err_no_selection"; exit 1; }
echo "$image_list" | \
    xargs -P 0 -o -I '{}' sh -c "fname=\"\$(basename \"{}\")\";
    convert \"{}\" -auto-orient -compress JPEG -quality 30 -format \\
    pdf \"$fig_dir/\$fname.pdf\";"
doc_code="${doc_code}$(find "$fig_dir" -type f | xargs -P 0 -o -I '{}' \
    sh -c \ "echo \"$latex_fig_start{}$latex_fig_end\";")
$latex_doc_end"
echo "$doc_code" > "$tmp_dir"/doc.tex
compile-latex.sh "$tmp_dir/doc.tex" "$output_file"
echo "$prog: Done compiling document!"
exit 0
