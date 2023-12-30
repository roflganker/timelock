#!/bin/sh

set -e
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date/sh

if ! lib_tl_is_working; then
  echo 'Not working at the moment' >&2
  return 1
fi

subject="$(cat "$(lib_tl_subject_file)")"
start_time="$(cat "$(lib_tl_time_file)")"
human_time="$(lib_date_range_to_hms "$start_time" "$(date +%s)")"

lib_ask_confirm "Drop work entry on $subject for $human_time?" 

rm -f "$(lib_tl_subject_file)" "$(lib_tl_time_file)"
echo "Done. Work entry has been dropped" >&2
