#!/bin/sh

. ./lib/tl.sh
. ./lib/history.sh
. ./lib/ask.sh

show_help() {
  cat <<EOF
Usage: tl start
Start recording working time

Possible options are
  -h  show help message on this command
  -c  continue working on previous entry 
      note: makes another work entry

Note: make sure you have GNU date in your machine
EOF
}

should_continue=false
while getopts ':hc' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    c) should_continue=true ;;
    *) ;;
  esac
done

if lib_tl_get_is_working; then
  subject="$(lib_tl get subject)"
  starttime="$(lib_tl get time)"
  startdate="$(date --date=@"$starttime")"

  echo "Already working on $subject since $startdate" >&2
  return 1
fi

start_time="$(date +%s)"

if [ "$should_continue" = true ]; then
  if ! lib_history_has_history; then
    echo "Nothing to continue: you have no work yet" >&2
    return 1
  fi

  last_work="$(lib_history_read_last)"
  last_work="${last_work#* }"
  subject="${last_work#* }"
else
  subject="$(lib_ask_line 'What are you working on?')"
fi

lib_tl write time "$start_time"
lib_tl write subject "$subject"
echo "You started working on $subject" >&2
