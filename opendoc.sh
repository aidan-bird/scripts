#!/bin/sh

# aidan bird 2021
#
# list and open e-textbooks in ~/doc/text
#

doc_path="$(realpath ~/doc/text)/"
sed_str_doc_path="$(echo "$doc_path" | sed 's/\//\\\//g')"
sel="$(find "$doc_path" -type f -print0 | sed -z "s/$sed_str_doc_path//g" | fzf --read0)"
[ -z "$sel" ] && { echo 'bad selection'; exit 1; }
echo "$sel" | xargs -I '{}' sh -c "zathura \"$doc_path{}\" & disown"
exit 0
