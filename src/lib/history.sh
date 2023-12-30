#!/bin/sh

test -z "$LIB_HISTORY_SOURCED" || echo "Lib history duplication" >&2

# Source dependent libs if not sourced yet
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh

_lib_history_file="$(lib_tl_get_home_dir)/history"
# Get file with timelock history
lib_history_file() {
  echo "$_lib_history_file"
}

# Check whether Timelock has history
lib_history_has_history() {
  test -f "$_lib_history_file" -a -s "$_lib_history_file"
}

# Pretty print history entries from stdin
lib_history_display() (
  while IFS=' ' read -r starttime endtime subject; do
    startdate="$(date --date=@"$starttime")"
    humantime="$(lib_date_sec_to_hms $((endtime - starttime)))"

    echo "$startdate: $subject ($humantime)"
  done
)

# Append a history entry
lib_history_append() (
  if [ -z "$1" ]; then echo "Missing start time" >&2 && return 1; fi
  if [ -z "$2" ]; then echo "Missing end time" >&2 && return 1; fi
  if [ -z "$3" ]; then echo "Missing message" >&2 && return 1; fi

  echo "$1" "$2" "$3" >>"$_lib_history_file"
)

# List raw history entries
lib_history_read() {
  cat "$_lib_history_file"
}

# Filter history entries from stdin
lib_history_filter() (
  usage="lib_history_filter <all|today|yesterday|week>"

  cur_time="$(date +%s)"
  cur_hour="$(date +%_H --date=@"$cur_time")"
  cur_min="$(date +%_H --date=@"$cur_time")"
  cur_sec="$(date +%_H --date=@"$cur_time")"
  cur_dom="$(date +%u --date=@"$cur_time")"
  day_start=$((cur_time - cur_hour * 3600 - cur_min * 60 - cur_sec))
  week_start=$((day_start - cur_dom * 86400 + 86400))

  min_time="0"
  max_time="$cur_time"
  case "$1" in
    all) ;;
    week) min_time="$week_start" ;;
    today) min_time="$day_start" ;;
    yesterday) min_time=$((day_start - 86400)) && max_time="$day_start" ;;
    *) echo "Unknown selector '$1'. Usage: $usage" >&2 && return 1 ;;
  esac

  while IFS=' ' read -r line; do
    start_time="${line%% *}"
    if [ -n "$start_time" ] \
      && [ "$start_time" -gt "$min_time" ] \
      && [ "$start_time" -lt "$max_time" ]; then
      echo "$line"
    fi
  done
)

LIB_HISTORY_SOURCED="1"
