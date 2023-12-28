#!/bin/sh

. ./common.sh

jiradir="$(tl_homedir)/jira"
emailfile="$jiradir/email"
urlfile="$jiradir/baseurl"
apikeyfile="$jiradir/apikey"

if [ -d "$jiradir" ]; then
  oldemail="$(cat "$emailfile" 2>/dev/null || true)"
  oldurl="$(cat "$urlfile" 2>/dev/null || true)"

  confirm "Jira is connected already (${oldemail:-'no email'}). Reinstall?"
fi

email="$(ask_word 'Who are you? (email on Altassian)' "$oldemail")"
baseurl="$(ask_word 'Base URL of your Jira instance?' "$oldurl")"
apikey="$(ask_secret 'Your personal API token?')"

[ -d "$jiradir" ] || mkdir "$jiradir"
echo "$email" >"$emailfile"
echo "$baseurl" >"$urlfile"
echo "$apikey" >"$apikeyfile"

chmod 600 "$jiradir/apikey"

echo 'Jira connected successfully' >&2
