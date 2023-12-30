#!/bin/sh

test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh

if lib_tl_get_is_working; then
  subject="$(lib_tl get subject)"
  starttime="$(lib_tl get time)"
  startdate="$(date --date=@"$starttime")"

  echo "Already working on $subject since $startdate" >&2
  return 1
fi

start_time="$(date +%s)"
subject="$(lib_ask_line 'What are you working on?')"

lib_tl write time "$start_time"
lib_tl write subject "$subject"
echo "You started working on $subject" >&2
