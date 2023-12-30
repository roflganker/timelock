#!/bin/sh

test -z "$LIB_DATE_SOURCED" || echo "Lib date suplication" >&2

# Convert seconds to [h [m]] s
lib_date_sec_to_hms() (
  usage="lib_date_sec_to_hms <seconds>"

  seconds="$1"
  if [ -z "$seconds" ]; then
    echo "Usage: $usage" >&2
    return 1
  fi

  if [ -z "${seconds##*[!0-9]*}" ]; then
    echo "Argument must be an integer" >&2
    return 1
  fi

  hours=$((seconds / 3600))
  seconds=$((seconds % 3600))
  minutes=$((seconds / 60))
  seconds=$((seconds % 60))

  if [ $hours != "0" ]; then
    echo "${hours}h ${minutes}m ${seconds}s"
  elif [ $minutes != "0" ]; then
    echo "${minutes}m ${seconds}s"
  else
    echo "${seconds}s"
  fi
)

# Convert UNIX timestamp to human representation
lib_date_unix_to_human() {
  echo 'Not implemented' >&2
  return 1
}

# Convert UNIX timestamp to ISO date
lib_date_unix_to_iso() {
  echo 'Not implemented' >&2
  return 1
}

LIB_DATE_SOURCED="1"
