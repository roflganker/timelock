#!/bin/sh

set -e
test -z "$LIB_HISTORY_SOURCED" && . ./lib/history.sh
test -z "$LIB_FILTER_SOURCED" && . ./lib/filter.sh
test -z "$LIB_JIRA_SOURCED" && . ./lib/jira.sh
test -z "$LIB_DATE_SOURCED" && . ./lib/date.sh
test -z "$LIB_ASK_SOURCED" && . ./lib/ask.sh

show_help() {
  cat <<EOF
Usage: tl commit [options]
Synchronize work entries with Jira

Possible options are
  -h          show this help message (help)
  -y          skip any confirmations (yes)
  -f <filter> filter work entries to synchronize
$(lib_filter_describe)

Note: when no filter is specified, syncing today history
EOF
}

do_ask_confirm=true
selector="today"
while getopts ':hf:y' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    f) selector="$(lib_filter_infer "$OPTARG")" ;;
    y) do_ask_confirm=false ;;
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

echo "Well you synchronize $selector history now..."

lib_history_read | lib_filter_apply "$selector" | {
  # Accept uncommitted entries only
  while read -r work_entry; do
    work_start="${work_entry%% *}"
    if ! lib_jira_is_worklogged "${work_entry%% *}"; then
      echo "$work_entry"
    fi
  done
} | {
  while IFS=' ' read -r work_start work_end work_subject; do
    work_seconds=$((work_end - work_start))
    work_humantime="$(lib_date_sec_to_hms "$work_seconds")"
    work_start_date="$(date --date=@"$work_start")"
    echo "$work_start_date: $work_subject ($work_humantime)" >&2

    guessed_issue="${work_subject%% *}"
    issue="$(lib_ask_word 'Jira issue?' "$guessed_issue")"

    guessed_comment="${work_subject#* }"
    comment="$(lib_ask_line 'Worklog comment?' "$guessed_comment")"

    if [ "$do_ask_confirm" = true ]; then 
      lib_ask_confirm "Track $work_humantime for $issue?"
    fi

    echo "Tracked :)" >&2
  done
}

# Done
