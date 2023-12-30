#!/bin/sh

test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh

if ! lib_tl_get_is_working; then
  echo "Not working on anything"
  return 1
fi

subject="$(lib_tl get subject)"
start_time="$(lib_tl get time)"
cur_time="$(date +%s)"
human_time="$(lib_date_sec_to_hms $((cur_time - start_time)))"

echo "Working on $subject for $human_time"
