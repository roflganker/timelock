#!/bin/sh

test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh

show_help() {
  cat <<EOF
Usage: tl link [...options]
Assign a URL to current work entry

Possible options are:
  -l <link>  specify URL non-interactively
  -d         delete a link instead of setting it
  -h         show this help message

Note: These URLs are used to compose Jira worklog comments
Note: options -l and -d don't work together
EOF
}

do_delete=false
work_link=""
while getopts ':hdl:' opt; do
  case "$opt" in
    h) show_help && return 1 ;;
    d) do_delete=true ;;
    l) work_link="$OPTARG" ;;
    *) ;;
  esac
done

if ! lib_tl_get_is_working; then
  echo "Error: not working at the moment. Type 'tl start'" >&2
  return 1
fi

if [ "$do_delete" = true ]; then
  if lib_tl drop link; then
    echo "Unlinked successfully" >&2
    return 0
  else
    echo "Failed to unlink" >&2
    return 1
  fi
fi

if [ -z "$work_link" ]; then
  old_link="$(lib_tl get link)"
  work_link="$(lib_ask_word 'Which URL is to link with this work?' "$old_link")"
fi

if lib_tl set link "$work_link"; then
  echo "Nice." >&2
else
  echo "Failed to assign a link" >&2
  return 1
fi
