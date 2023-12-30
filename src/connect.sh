#!/bin/sh

set -e
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_JIRA_SOURCED" || . ./lib/jira.sh

if lib_jira_connected; then
  old_email="$(lib_jira_get_email)"
  old_url="$(lib_jira_get_url)"

  lib_ask_confirm "Jira is connected already ($old_email). Reinstall?"
fi

lib_jira_connect \
  "$(lib_ask_word 'Base URL of your Jira instance?' "$old_url")" \
  "$(lib_ask_word 'Who are you? (email on Altassian)' "$old_email")" \
  "$(lib_ask_secret 'Your personal API token?')"

echo 'Jira connected successfully' >&2
