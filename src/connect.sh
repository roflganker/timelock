#!/bin/sh

. ./common.sh

jiradir="$(tl_homedir)/jira"
if [ -d "$jiradir" ]; then
  if [ -f "$jiradir/email" ] && [ -r "$jiradir/email" ]; then
    email="$(cat "$jiradir/email")"
  else
    email='no email'
  fi

  confirm "Jira is connected already ($email). Reinstall?"
  rm -rf "$jiradir"
fi

mkdir "$jiradir"
ask_line 'Who are you? (email on Altassian)' > "$jiradir/email"
ask_line 'Base URL of your Jira instance?' > "$jiradir/baseurl"
ask_secret 'Your personal API token?' > "$jiradir/apikey"
chmod 600 "$jiradir/apikey"

echo 'Jira connected successfully' >&2

