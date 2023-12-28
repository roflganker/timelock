#!/bin/sh

. ./common.sh

tl_is_working || fail 'Not working at the moment, nothing to change'

oldsubject="$(cat "$(tl_subjfile)")"
newsubject="$(ask_line 'What are you working on?' "$oldsubject")"
[ "$newsubject" != "$oldsubject" ] || fail 'Nothing changed'

echo "$newsubject" >"$(tl_subjfile)"
echo "Ok, now working on $newsubject" >&2
