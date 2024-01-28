#!/bin/sh

# Duplicate sourcing guard
if [ -n "$LIB_FILTER_SOURCED" ]; then
  echo "Duplicate sourcing of filter library!" >&2
  return 1
fi

# Infer filter from its short variant
lib_filter_infer() {
  case "$1" in
    a | all) echo "all" ;;
    w | week) echo "week" ;;
    t | td | today) echo "today" ;;
    y | yd | yesterday) echo "yesterday" ;;
    *) echo "Bad filter '$1'." >&2 && return 1 ;;
  esac
}

# Describe possible filters
lib_filter_describe() {
  cat <<EOF
    a, all       show all history (equivalent of no filter)
    w, week      show history from week start only
    t, today     show today history
    y, esterday  show yesterday history
EOF
}

# Filter history entries from stdin
lib_filter_apply() (
  usage="lib_filter_apply <all|today|yesterday|week>"

  cur_time="$(date +%s)"
  cur_hour="$(date +%_H --date=@"$cur_time")"
  cur_min="$(date +%_H --date=@"$cur_time")"
  cur_sec="$(date +%_H --date=@"$cur_time")"
  cur_dow="$(date +%u --date=@"$cur_time")"
  day_start=$((cur_time - cur_hour * 3600 - cur_min * 60 - cur_sec))
  week_start=$((day_start - cur_dow * 86400 + 86400))

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
    work_time="${line%% *}"
    if [ "$work_time" -gt "$min_time" ] && [ "$work_time" -lt "$max_time" ]; then
      echo "$line"
    fi
  done
)

LIB_FILTER_SOURCED="1"
