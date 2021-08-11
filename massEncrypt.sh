#!/bin/sh

# Aidan Bird 2021
#
# encrypt all files in a directory.
#

# . "$(dirname "$0")/autils.sh"
prog_root="$(dirname "$0")"
prog="$(basename "$0")"
cmd_usage="usage: $prog [DIRECTORY PATH] [OPTIONAL KEY NAME] [OPTIONAL INPLACE -i]"
[ $# -lt 1 ] && { echo "$cmd_usage"; exit 1; }
pathroot="$(realpath "$1")"
keyid="$2"
if [ -z "$keyid" ]
then
    gpgStat="$(gpg -K --with-colons)"
    keyNames="$(echo "$gpgStat" | sed -e '/uid/!d' \
        | awk -F':' '{ print $10 }')"
    fprs="$(echo "$gpgStat" | sed -e '/fpr/!d' \
        | awk -F ':' '{ print $10 }')"
    keyid="$("$prog_root"/bin/columnizer -d "\n" "--" "$fprs" "$keyNames" | fzf \
        | sed -e 's/ .*//')"
fi
gpg --check-sig "$keyid"
[ "$?" != 0 ] && { echo "$prog: invalid key id!"; exit 1; }
if [ "$3" = "-i" ]
then
    temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" 0 2 3 15
    find "$pathroot" -maxdepth 1 -type f -print0 | xargs -P 0 -0 -I '{}' sh -c \
        "escPath=\"\$(printf '{}')\"
        fname=\"\$(basename \"\$escPath\")\" ; 
        gpg -q --output \"$temp_dir/\$fname.gpg\" -r$keyid --encrypt \"\$escPath\" ;
        [ "\$?" != 0 ] && { echo \"$prog: errors encrypting \$fname\"; exit 1; };
        shred -u \"\$escPath\" ;
        mv \"$temp_dir/\$fname.gpg\" \"\$escPath.gpg\" ;"
else
    find "$pathroot" -maxdepth 1 -type f | gpg -r"$keyid" --encrypt-files
fi
exit 0
