#!/bin/sh

. ./common.sh

if tl_is_working; then
  subject="$(cat "$(tl_subjfile)")"
  starttime="$(cat "$(tl_stampfile)")"
  startdate="$(date --date=@"$starttime")"

  fail "Already working on $subject since $startdate"
fi

timestamp="$(date +%s)"
subject="$(ask_line 'What are you working on?')"

echo "$timestamp" >"$(tl_stampfile)"
echo "$subject" >"$(tl_subjfile)"
echo "You started working on $subject" >&2
