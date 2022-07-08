#!/bin/sh

#
# Aidan Bird 2022
#
# setup ssh key
#

me="$(basename "$0")"
usage="usage: $me [user] [private key path]"
sshd_path="/etc/ssh"
sshd_config_file="$sshd_path/sshd_config"
sshd_authorized_keys_root="$sshd_path/users"

# check params
[ $# -lt 2 ] && { echo "$me: $usage" ; exit 1 ; }

# check root
[ "$(id -u)" -ne 0 ] && { echo "$me: run as root." ; exit 1 ; }

# check user
id "$1" >> /dev/null 2>&1
[ $? -ne 0 ] && { echo "$me: no such user."; exit 1 ; }

# make key folders
user_key_dir="$sshd_authorized_keys_root/$1"
if [ ! -e "$user_key_dir" ]
then
    echo "$me: creating $user_key_dir"
    mkdir "$user_key_dir"
    chmod 700 "$user_key_dir"
    chown "$1:$1" "$user_key_dir"
fi
authorized_keys_file="$user_key_dir/authorized_keys"
if [ ! -e "$authorized_keys_file" ]
then
    echo "$me: creating $authorized_keys_file"
    touch "$authorized_keys_file"
    chmod 644 "$authorized_keys_file"
    chown "$1:$1" "$authorized_keys_file"
fi

# make key
tmp_dir="$(mktemp -d)"
trap "rm -rf $tmp_dir" 0 2 3 15
ssh-keygen -t ed25519 -a 100 -f "$tmp_dir/key"
[ $? -ne 0 ] && { echo "$me: failed to generate key." ; exit 1 ; }

# copy over 
cat "$tmp_dir/key.pub" >> "$authorized_keys_file"
cp -f "$tmp_dir/key" "$2"
chmod 600 "$2"
chown "$1:$1" "$2"

# clean up
shred -zu $tmp_dir/key.pub $tmp_dir/key
exit 0
