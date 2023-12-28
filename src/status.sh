#!/bin/sh

. ./common.sh

if ! tl_is_working; then
  echo "Not working on anything"
  return 0
fi

subject="$(cat "$(tl_subjfile)")"
starttime="$(cat "$(tl_stampfile)")"
curtime="$(date +%s)"

echo "Working on $subject for $(format_timediff "$starttime" "$curtime")"
