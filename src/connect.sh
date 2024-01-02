#!/bin/sh

set -e
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_JIRA_SOURCED" || . ./lib/jira.sh

show_help() {
  cat <<EOF
Usage: tl connect [options...]
Connect Jira Cloud with Timelock

Possible options are
  -y  force reinstall, if connected already
  -h  show help message on this command
EOF
}

should_confirm_reinstall="yes"
while getopts ':hy' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    y) should_confirm_reinstall="no" ;;
    *) ;;
  esac
done

if lib_jira_is_connected; then
  old_email="$(lib_jira_get_email)"
  old_url="$(lib_jira_get_url)"

  if [ "$should_confirm_reinstall" = "yes" ]; then
    lib_ask_confirm "Jira is connected already ($old_email). Reinstall?"
  fi
fi

lib_jira_connect \
  "$(lib_ask_word 'Base URL of your Jira instance?' "$old_url")" \
  "$(lib_ask_word 'Who are you? (email on Altassian)' "$old_email")" \
  "$(lib_ask_secret 'Your personal API token?')"

echo 'Jira connected successfully' >&2
