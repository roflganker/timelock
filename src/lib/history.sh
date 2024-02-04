#!/bin/sh

# Complain if the library was sourced already
test -z "$LIB_HISTORY_SOURCED" || echo "Lib history duplication" >&2

# Source dependent libs if not sourced yet
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh

_lib_history_file="$(lib_tl_get_home_dir)/history"
_lib_history_links_file="$(lib_tl_get_home_dir)/links"

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
# Usage: lib_history_append <start> <end> <message> [link]
lib_history_append() (
  if [ -z "$1" ]; then echo "Missing start time" >&2 && return 1; fi
  if [ -z "$2" ]; then echo "Missing end time" >&2 && return 1; fi
  if [ -z "$3" ]; then echo "Missing message" >&2 && return 1; fi

  echo "$1" "$2" "$3" >>"$_lib_history_file"

  if [ -n "$4" ]; then
    echo "$1" "$4" >>"$_lib_history_links_file"
  fi
)

# Check whether history entry has URL
# Usage: lib_history_has_link <start timestamp>
# Note: returns code 1 if link is not present
lib_history_has_link() {
  entry_id="$1"
  if [ -z "$entry_id" ]; then
    echo "Missing entry ID (start timestamp)" >&2
    return 1
  fi

  # In this file, first column is exactly an entry id (entry start timestamp)
  cut -f 1 -d ' ' <"$_lib_history_links_file" | grep "$entry_id" >/dev/null 2>/dev/null
}

# Get link of a cpecified history entry
lib_history_get_link() {
  entry_id="$1"
  if [ -z "$entry_id" ]; then
    echo "Missing entry start timestamp" >&2
    return 1
  fi

  grep "$entry_id" <"$_lib_history_links_file" 2>/dev/null | cut -f 2 -d ' '
}

# List raw history entries
lib_history_read() {
  cat "$_lib_history_file"
}

lib_history_read_last() {
  tail -n 1 "$_lib_history_file"
}

LIB_HISTORY_SOURCED="1"
