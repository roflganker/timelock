#!/bin/sh

test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh

show_help() {
  cat <<EOF
Usage: tl change
Change subject of current work entry (message shown in status and history)
EOF
}

while getopts ':h' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    *) ;;
  esac
done

if ! lib_tl_get_is_working; then
  echo 'Not working at the moment, nothing to change' >&2
  return 1
fi

old_subject="$(lib_tl get subject)"
new_subject="$(lib_ask_line 'What are you working on?' "$old_subject")"
if [ "$new_subject" = "$old_subject" ]; then
  echo 'Nothing changed' >&2
  return 1
fi

if lib_tl write subject "$new_subject"; then
  echo "Ok, now working on $new_subject" >&2
else
  echo "Failed to change" >&2
  return 1
fi
