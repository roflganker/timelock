#!/bin/sh

. ./common.sh

if ! tl_is_working; then
  fail 'Not working at the moment';
fi

subject="$(cat "$(tl_subjfile)")"
starttime="$(cat "$(tl_stampfile)")"
curtime="$(date +%s)"
timediff="$(( curtime - starttime ))"
humantime="$(format_seconds "$timediff")"

rm -f "$(tl_subjfile)" "$(tl_stampfile)"
echo "$starttime $curtime $subject" >> "$(tl_histfile)"
echo "You worked on $subject for $humantime" >&2

