#!/bin/sh

#
# aidan bird 2021
#
# open the browser with the basic profile
#

. "$(dirname "$0")/autils.sh"
browser_name="waterfox-current"
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
        $BROWSER -P "$profile_name" --new-tab "$url"
    else
        echo "opening new window"
        $BROWSER -P "$profile_name" --new-window "$url"
    fi
else
    echo "opening new instance"
    $BROWSER --new-instance -P "$profile_name" "$url" &
    disown
fi
exit 0
