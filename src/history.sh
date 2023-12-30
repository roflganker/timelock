#!/bin/sh

set -e
test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh

usage="tl history [-f a|w|t|y]"
selector="all"
while getopts ':f:' opt; do
  case "$opt" in
    f)
      case "$OPTARG" in
        a | all) selector="all" ;;
        w | week) selector="week" ;;
        t | today) selector="today" ;;
        y | yesterday) selector="yesterday" ;;
        *) echo "Bad filter '$OPTARG'. Usage: $usage" >&2 && return 1 ;;
      esac
      ;;
    *) ;;
  esac
done

if ! lib_history_has_history; then
  echo "You have no history yet" >&2
  return 1
fi

lib_history_read | lib_history_filter "$selector" | lib_history_display
