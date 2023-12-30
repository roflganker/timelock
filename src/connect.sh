#!/bin/sh

set -e
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh

jira_dir="$(lib_tl_homedir)/jira"
email_file="$jira_dir/email"
url_file="$jira_dir/baseurl"
apikey_file="$jira_dir/apikey"

if [ -d "$jira_dir" ]; then
  old_email="$(cat "$email_file" 2>/dev/null || true)"
  old_url="$(cat "$url_file" 2>/dev/null || true)"

  lib_ask_confirm "Jira is connected already (${old_email:-'no email'}). Reinstall?"
fi

email="$(lib_ask_word 'Who are you? (email on Altassian)' "$old_email")"
baseurl="$(lib_ask_word 'Base URL of your Jira instance?' "$old_url")"
apikey="$(lib_ask_secret 'Your personal API token?')"

[ -d "$jira_dir" ] || mkdir "$jira_dir"
echo "$email" >"$email_file"
echo "$baseurl" >"$url_file"
echo "$apikey" >"$apikey_file"

chmod 600 "$jira_dir/apikey"

echo 'Jira connected successfully' >&2
