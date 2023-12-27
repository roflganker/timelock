#!/bin/sh

. ./common.sh

if ! tl_is_working; then
  fail 'Not working at the moment'
fi

subject="$(cat "$(tl_subjfile)")"
starttime="$(cat "$(tl_stampfile)")"
curtime="$(date +%s)"

comfirm "Erase work on $subject for $(format_timediff "$starttime" "$curtime")?"

rm -f "$(tl_subjfile)" "$(tl_stampfile)"
echo "Done. Work entry has been erased" >&2

