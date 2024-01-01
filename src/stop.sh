#!/bin/sh

set -e
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh
test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh

if ! lib_tl_get_is_working; then
  echo 'Not working at the moment' >&2
  return 1
fi

subject="$(lib_tl get subject)"
start_time="$(lib_tl get time)"
cur_time="$(date +%s)"
human_time="$(lib_date_sec_to_hms $((cur_time - start_time)))"
echo "You worked on $subject for $human_time" >&2

lib_tl drop time
lib_tl drop subject
lib_history_append "$start_time" "$cur_time" "$subject"

