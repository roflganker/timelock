#!/bin/sh

. ./common.sh

filter=""
while getopts ':f:' opt; do
  case "$opt" in
    f)
      case "$OPTARG" in
        w | week) filter="week" ;;
        t | td | today) filter="today" ;;
        y | yd | yestrtday) filter="yesterday" ;;
        *) fail "Invalid filter '$OPTARG'. Usage: -f t|y|w" ;;
      esac
      ;;
    ?)
      fail "Invalid option: -${OPTARG}"
      ;;
  esac
done

filter_history() (
  curtime="$(date +%s)"
  daystart=$((curtime - $(date +%_H) * 3600 - $(date +%_M) * 60 - $(date +%_S)))
  weekstart=$((daystart - $(date +%u) * 86400 + 86400))

  mintime="0"
  maxtime="$curtime"
  case "$filter" in
    week) mintime="$weekstart" ;;
    today) mintime="$daystart" ;;
    yesterday)
      mintime=$((daystart - 86400))
      maxtime="$daystart"
      ;;
  esac

  while IFS=' ' read -r line; do
    starttime="${line%% *}"
    if [ "$starttime" -gt "$mintime" ] && [ "$starttime" -lt "$maxtime" ]; then
      echo "$line"
    fi
  done
)

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

filter_history <"$histfile" | display_history
