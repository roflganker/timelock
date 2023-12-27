#!/bin/sh

. ./common.sh

display_history() (
  while IFS=' ' read -r starttime endtime subject; do
    startdate="$(date --date=@"$starttime")"
    humantime="$(format_timediff "$starttime" "$endtime")"

    echo "$startdate: $subject ($humantime)"
  done
)

histfile="$(tl_histfile)"
if [ ! -f "$histfile" ] || [ ! -r "$histfile" ] || [ ! -s "$histfile" ]; then
  fail 'You have no history yet'
fi

display_history <"$histfile"
