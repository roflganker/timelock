#!/bin/sh
# Todo: committing many entries
# As example: commit -t => today, commit -y => yesterday

set -e
test -n "$LIB_ASK_SOURCED" || . ./lib/ask.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh
test -n "$LIB_JIRA_SOURCED" || . ./lib/jira.sh
test -n "$LIB_HISTORY_SOURCED" || . ./lib/history.sh

show_help() {
  cat <<EOF
Usage: tl commit [options...]
Send last history entry to Jira worklogs

Possible options are
  -y  skip confirmation
  -i  specify Jira issue
  -c  specify Jira comment
  -h  show this help message

Note: Jira must be connected with Timelock. Run 'tl connect' first.
Note: For non-interactive environments, -yic options are super useful
EOF
}

do_ask_confirm="yes"
while getopts ':yi:c:h' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    y) do_ask_confirm="no" ;;
    c) comment="$OPTARG" ;;
    i) issue="$OPTARG" ;;
    *) ;;
  esac
done

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

if [ -z "$issue" ]; then
  guessed_issue="${work_subject%% *}"
  issue="$(lib_ask_word 'Jira issue?' "$guessed_issue")"
fi

if [ -z "$comment" ]; then
  guessed_comment="${work_subject#* }"
  comment="$(lib_ask_line 'Worklog comment?' "$guessed_comment")"
fi

work_seconds=$((work_end - work_start))
work_humantime="$(lib_date_sec_to_hms "$work_seconds")"

if [ "$do_ask_confirm" = "yes" ]; then
  lib_ask_confirm "Track $work_humantime for $issue?"
fi

if lib_jira_add_worklog "$issue" "$work_start" "$work_seconds" "$comment"; then
  echo "Successfully sent to Jira" >&2
else
  echo "Sometning went wrong" >&2
  return 1
fi
