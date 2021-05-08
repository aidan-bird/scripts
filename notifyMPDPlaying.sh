#!/bin/sh
. "$(dirname "$0")/autils.sh"
music_dir="/sftp/Music"
notification_category="music_playing"
notification_timeout=2500
prog="$(basename "$0")"
current_song="$(mpc current -f "[[%artist% - ]%title%]|[%file%]")"
[ -z "$current_song" ] && { exit 1; }
current_path="$(mpc current -f "[%file%]")"
[ -z "$current_song" ] && { exit 1; }
file_path="$music_dir/$current_path"
file_dir="$(basename "$file_path")"

# $1 = song name
# $2 = icon path 
emitNotification() {
    case $# in
        1)
            # with no cover
            notify-send -c "$notification_category" \
                -t "$notification_timeout" "🎵$1"
            ;;
        2)
            notify-send -c "$notification_category" \
                -t "$notification_timeout" -i "$2" "🎵$1"
            ;;
    esac
}

# try extracting embedded cover
cover_tag="$(exiftool -q -P "$file_path" \
    | grep -i -s -m 1 ": (binary data .*, use -b option to extract)" \
    | sed -e "s/ *: (Binary data .*, use -b option to extract)//")"
if [ ! -z "$cover_tag" ]
then
    tmp_file="$(mktemp "/tmp/$prog.XXXXXX")"
    trap "rm $tmp_file" 0 2 3 15
    exiftool -q -P "$file_path" -"$cover_tag" -b > "$tmp_file" \
        && { emitNotification "$current_song" "$tmp_file"; exit 0; }
fi
# try using image files in the album directory
album_root="$(eldestChild "$file_path" "$music_dir")"
if [ $? -eq 0 ]
then
    image_files="$(find "$album_root" -type f -exec file -0 {} \+ \
        | grep -a 'image data' | cut -d '' -f1)"
    case "$(echo "$image_files" | wc -l)" in
        0)
            # emit with no cover
            echo ""
            emitNotification "$current_song"
            ;;
        1)
            # there is only one image file, so use it.
            emitNotification "$current_song" "$image_files"
            ;;
        *)
            # try to select the most appropriate image file
            guess="$(echo "$image_files" | grep -i -s -m 1 -e "cover" -e "folder" -e "image")"
            # using the album name
            # guess="$(echo "$image_files" | grep -i -s -m 1 -E \
            #     "cover|folder|image|$(echo "$album_root" | xargs -I '{}' \
            #     printf "%q" '{}' | sed "s/^'//;s/'$//;").*")"
            [ -z "$guess" ] || { emitNotification "$current_song" "$guess"; exit 0; }
            # album covers are usually square, try to use square images
            guess="$(echo "$image_files" | xargs -I '{}' -P 0 sh -c \
                "echo \"\$(echo \$(exiftool -s -P -\"ImageWidth\" \
                -\"ImageHeight\" -S \"{}\") | xargs -l \
                sh -c 'echo \"define abs(x) { if (x < 0) { return -x; } else \
                { return x; } } sqrt((1 - \$0 / \$1 )^2)\" | bc -l' )\" \
                    \"{}\"" | sort -g | sed 's/.* //;1q')"
            [ -z "$guess" ] || { emitNotification "$current_song" "$guess"; \
                exit 0; }
            # use the first entry in image files
            guess="$(echo "$image_files" | sed '1q')"
            emitNotification "$current_song" "$guess"
            ;;
    esac
else
    emitNotification "$current_song"
fi
exit 0