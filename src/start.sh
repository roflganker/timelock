#!/bin/sh

test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh

if tl_is_working; then
  subject="$(cat "$(lib_tl_subject_file)")"
  starttime="$(cat "$(lib_tl_time_file)")"
  startdate="$(date --date=@"$starttime")"

  fail "Already working on $subject since $startdate"
fi

timestamp="$(date +%s)"
subject="$(ask_line 'What are you working on?')"

echo "$timestamp" >"$(tl_stampfile)"
echo "$subject" >"$(tl_subjfile)"
echo "You started working on $subject" >&2
