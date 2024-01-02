#!/bin/sh

set -e
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh
test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh

show_help() {
  cat <<EOF
Usage: tl stop [options...]
Stop current work

Possible options are
  -h  show this help message 
  -f  forget work entry (default behavior is writing history) 
  -y  skip confirmation on forgetting work entry

Note: this command uses GNU date for tracking time. Other implementations
      of date may cause poor results or even errors.
EOF
}

do_write_history="yes"
do_confirm_forgetting="yes"
while getopts ':hfy' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    f) do_write_history="no" ;;
    y) do_confirm_forgetting="no" ;;
    *) ;;
  esac
done

if ! lib_tl_get_is_working; then
  echo 'Not working at the moment' >&2
  return 1
fi

subject="$(lib_tl get subject)"
start_time="$(lib_tl get time)"
cur_time="$(date +%s)"
human_time="$(lib_date_sec_to_hms $((cur_time - start_time)))"
echo "You worked on $subject for $human_time" >&2

if [ "$do_write_history" = "yes" ]; then
  lib_history_append "$start_time" "$cur_time" "$subject"
else
  if [ "$do_confirm_forgetting" = "yes" ]; then
    lib_ask_confirm "Are you sure to erase your work?"
  fi
fi

lib_tl drop time
lib_tl drop subject
