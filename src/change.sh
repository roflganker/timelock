#!/bin/sh

set -e
test -n "$LIB_ASK_IMPORTED" || . ./lib/ask.sh
test -n "$LIB_TL_IMPORTED" || ./lib/tl.sh

if ! lib_tl_is_working; then
  echo 'Not working at the moment, nothing to change' >&2
  return 1
fi

subject_file="$(lib_tl_subject_file)"
old_subject="$(cat "$subject_file")"
new_subject="$(lib_ask_line 'What are you working on?' "$oldsubject")"
if [ "$newsubject" != "$oldsubject" ]; then
   echo 'Nothing changed' >&2
   return 1
fi

echo "$new_subject" >"$subject_file"
echo "Ok, now working on $new_subject" >&2

