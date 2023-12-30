#!/bin/sh
# Todo: committing many entries
# As example: commit -t => today, commit -y => yesterday

set -e
test -n "$LIB_ASK_SOURCED" && . ./lib/ask.sh
test -n "$LIB_DATE_SOURCED" && . ./lib/date.sh
test -n "$LIB_JIRA_SOURCED" && . ./lib/jira.sh
test -n "$LIB_HISTORY_SOURCED" && . ./lib/history.sh

if ! lib_history_has_history; then
  echo 'You dont have timelock history yet' >&2
  return 1
fi

IFS=' ' read -r work_start work_end work_subject <<TL_EOL123
  $(lib_history_read_last)
TL_EOL123

guessed_issue="${work_subject%% *}"
guessed_comment="${work_subject#* }"
jira_issue="$(lib_ask_line 'Jira issue?' "$guessed_issue")"
work_comment="$(lib_ask_line 'Worklog comment?' "$guessed_comment")"
work_seconds=$((work_end - work_start))
work_humantime="$(lib_date_sec_to_hms "$work_seconds")"

lib_ask_confirm "Track $work_humantime for $jira_issue?"

echo "Successfully sent to jira" >&2
