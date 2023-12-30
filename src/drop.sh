#!/bin/sh

set -e
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh

if ! lib_tl_get_is_working; then
  echo 'Not working at the moment' >&2
  return 1
fi

subject="$(lib_tl get subject)"
start_time="$(lib_tl get time)"
cur_time="$(date +%s)"
human_time="$(lib_date_sec_to_hms $((cur_time - start_time)))"

lib_ask_confirm "Drop work entry on $subject for $human_time?"

if lib_tl drop time && lib_tl drop subject; then
  echo "Done. Work entry has been dropped" >&2
else
  echo "Something went wrong" >&2
  return 1
fi
