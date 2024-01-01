#!/bin/sh
# Todo: committing many entries
# As example: commit -t => today, commit -y => yesterday

set -e
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh
test -n "$LIB_JIRA_SOURCED" || . ./lib/jira.sh
test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh

if ! lib_jira_is_connected; then
  echo 'You havent connected jira. Please run tl connect' >&2
  return 1
fi

if ! lib_history_has_history; then
  echo 'You dont have timelock history yet' >&2
  return 1
fi

IFS=' ' read -r work_start work_end work_subject <<EOL123
  $(lib_history_read_last)
EOL123

if lib_jira_is_worklogged "$work_start"; then
  echo "Work was already sent to Jira" >&2
  return 1
fi

guessed_issue="${work_subject%% *}"
guessed_comment="${work_subject#* }"
issue="$(lib_ask_word 'Jira issue?' "$guessed_issue")"
comment="$(lib_ask_line 'Worklog comment?' "$guessed_comment")"
work_seconds=$((work_end - work_start))
work_humantime="$(lib_date_sec_to_hms "$work_seconds")"

lib_ask_confirm "Track $work_humantime for $issue?"
if lib_jira_add_worklog "$issue" "$work_start" "$work_seconds" "$comment"; then
  echo "Successfully sent to Jira" >&2
else
  echo "Sometning went wrong" >&2
  return 1
fi
