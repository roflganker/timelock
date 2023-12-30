#!/bin/sh

test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh

selector=""
while getopts ':f:' opt; do
  case "$opt" in
    f)
      case "$OPTARG" in
        a | all) selector="all" ;;
        w | week) selector="week" ;;
        t | today) selector="today" ;;
        y | yestrtday) selector="yesterday" ;;
        *) fail "Invalid selector '$OPTARG'. Possible values: a, w, t, y" ;;
      esac
      ;;
    ?)
      fail "Invalid option: -${OPTARG}"
      ;;
  esac
done

if ! lib_history_has_history; then
  echo "You have no history yet" >&2
  return 1
fi

cat "$(lib_history_file)" \
  | lib_history_filter "$selector" \
  | lib_history_display

