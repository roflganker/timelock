#!/bin/sh

set -e
test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh
test -n "$LIB_FILTER_SOURCED" || . ./lib/filter.sh

show_help() {
  cat <<EOF
Usage: tl history [options...]
Show work tracked via timelock

Possible options are 
  -h             show help on this command

  -f <filter>    show filtered history, using following filters
$(lib_filter_describe)

Note: it fails with code 1 if there are no history at all, but
      yields 0 with no output if there are no filtered history
EOF
}

selector="all"
while getopts ':f:h' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    f) selector="$(lib_filter_infer "$OPTARG")" ;;
    *) ;;
  esac
done

if ! lib_history_has_history; then
  echo "You have no history yet" >&2
  return 1
fi

lib_history_read | lib_filter_apply "$selector" | lib_history_display
