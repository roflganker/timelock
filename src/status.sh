#!/bin/sh

test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -n "$LIB_DATE_SOURCED" || . ./lib/date.sh

show_help() {
  cat <<EOF
Usage: tl status [options...]
Get current work status

Possible options are
  -h  show help message on this command
  -u  print working time in format %dh %dm %ds to stdout
  -t  print working time, in seconds, to stdout
  -s  print work subject to stdout

Note: it fails with return code 1 if no work is in progress
Note: options -u may be used as interface between timelock
      and other automated tools
EOF
}

print_human_time="no"
print_seconds="no"
print_subject="no"
while getopts ':hus' opt; do
  case "$opt" in
    h) show_help && return 0 ;;
    u) print_human_time="yes" ;;
    t) print_seconds="yes" ;;
    s) print_subject="yes" ;;
    *) ;;
  esac
done

if ! lib_tl_get_is_working; then
  echo "Not working on anything" >&2
  return 1
fi

subject="$(lib_tl get subject)"
start_time="$(lib_tl get time)"
cur_time="$(date +%s)"
work_seconds=$((cur_time - start_time))
human_time="$(lib_date_sec_to_hms $work_seconds)"

echo "Working on $subject for $human_time" >&2
if [ "$print_human_time" = "yes" ]; then echo "$human_time"; fi
if [ "$print_seconds" = "yes" ]; then echo "$work_seconds"; fi
if [ "$print_subject" = "yes" ]; then echo "$subject"; fi
