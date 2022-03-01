#!/bin/sh

#
# aidan bird 2021
#
# open the browser with the basic profile
#

. "$(dirname "$0")/autils.sh"
browser_name="librewolf"
profile_name="basic"
url="about:blank"
[ ! -z "$1" ] && { url="$1"; }
ps -u "$(whoami)" -f | sed "/.*grep.*/d" \
    | grep -m 1 -i "$browser_name.*$profile_name.*"
if [ $? == 0 ]
then
    ps -f "$(getFocusedWindowPID)" | sed "/.*grep.*/d" \
        | grep -m 1 -i "$browser_name.*$profile_name.*"
    if [ $? == 0 ]
    then
        echo "opening new tab"
        $browser_name -P "$profile_name" --new-tab "$url"
    else
        echo "opening new window"
        $browser_name -P "$profile_name" --new-window "$url"
    fi
else
    echo "opening new instance"
    $browser_name --new-instance -P "$profile_name" "$url" &
    disown
fi
exit 0
