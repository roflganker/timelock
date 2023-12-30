#!/bin/sh

# Complain and abort if already sourced
test -z "$LIB_HISTORY_SOURCED" || { echo 'Dupl lib history' >&2; return 1; }

# Source dependent libs if not sourced yet
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh

# Get file with timelock history
lib_history_file() {
  echo "$(lib_tl_homedir)/history"
}

# Check whether Timelock has history
lib_history_has_history() (
  histfile="$(lib_history_file)"
  test -f "$histfile" && test -s "$histfile"
)

# Pretty print history entries from stdin
lib_history_display() (
  while IFS=' ' read -r starttime endtime subject; do
    startdate="$(date --date=@"$starttime")"
    humantime="$(lib_date_sec_to_hms $((endtime - starttime)))"

    echo "$startdate: $subject ($humantime)"
  done
)

# Filter history entries from stdin
lib_history_filter() (
  usage="lib_history_filter <all|today|yesterday|week>"

  cur_time="$(date +%s)"
  cur_hour="$(date +%_H --date=@"$cur_time")"
  cur_min="$(date +%_H --date=@"$cur_time")"
  cur_sec="$(date +%_H --date=@"$cur_time")"
  cur_dom="$(date +%u --date=@"$cur_time")"
  day_start=$((curtime - cur_hour * 3600 - cur_min * 60 - cur_sec))
  week_start=$((day_start - cur_dom * 86400 + 86400))

  min_time="0"
  max_time="$cur_time"
  case "$filter" in
    all) ;;
    week) mintime="$week_start" ;;
    today) mintime="$day_start" ;;
    yesterday)
      mintime=$((daystart - 86400))
      maxtime="$daystart"
      ;;
    *)
      echo "Unknown selector. Usage: $usage" >&2
      return 1
      ;;
  esac

  while IFS=' ' read -r line; do
    start_time="${line%% *}"
    if [ -n "$start_time" ]
      && [ "$start_time" -gt "$min_time" ]
      && [ "$start_time" -lt "$max_time" ]
    then
      echo "$line"
    fi
  done
)

LIB_HISTORY_SOURCED="1"

