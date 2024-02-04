#!/bin/sh

set -e
test -z "$LIB_HISTORY_SOURCED" && . ./lib/history.sh
test -z "$LIB_FILTER_SOURCED" && . ./lib/filter.sh
test -z "$LIB_DATE_SOURCED" && . ./lib/date.sh

show_help() {
  cat <<EOF
Usage: tl commit [options]
Synchronize work entries with Jira

Possible options are
  -h            show this help message (help)
  -f <filter>   filter work entries to synchronize
$(lib_filter_describe)
  -g <grouper>  use grouping for summary
  -g day        group by day
  -g dom        group by day of month
  -g sub        group by first word of subject 

Note: when no filter is specified, syncing today history
EOF
}

selector="today"
grouper="day"
while getopts ':hf:g:' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    f) selector="$(lib_filter_infer "$OPTARG")" ;;
    g) grouper="$OPTARG" ;;
    *) ;;
  esac
done

if ! lib_history_has_history; then
  echo 'You dont have timelock history yet' >&2
  return 1
fi

echo "Well you synchronize $selector history now..."

# Infer group from work entry
infer_group() {
  
}

# Infer day from work entry
infer_group_day() {

}

# Infer day-of-month group from work entry
infer_group_dom() {

}

# Infer subject group from work entry
infer_group_sub() {

}

# Summarize time by groups
summarize() {

}

lib_history_read | lib_filter_apply "$selector" | {
  # Assign group to work entries and associate with work time
  while IFS=' ' read -r work_start work_end work_subject; do
    work_group="$(infer_group $work_start $work_end $work_subject)"
    work_seconds=$((work_end - work_start))
    echo "$entry_group $work_seconds"
  done
} | {
  # Summarize time associated with the group
  group_hashes=""
  while IFS=' ' read -r work_group work_seconds; do
    group_hash="$(echo "$work_group" | sha1sum | cut -f 1 -d ' ')";
    name_var="group_$group_hash"
    time_var="time_$group_hash"
    if ! echo "$group_hashes" | grep "$group_hash"; then
      group_hashes="$group_hashes\n$group_hash"
      exec "\$$name_var='$work_group'":q

    fi
    
  done
} | {
  # Pretty print the result
  while IFS=' ' read -r work_group work_time; do
    
  done
}

# Done
