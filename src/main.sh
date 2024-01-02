#!/bin/sh

show_help() {
  cat <<EOF
Usage: tl <command> [options...]
Run a command of Timelock CLI

Possible commands are
  start     start tracking time
  status    get work status
  change    change work (time-track) subject
  stop      stop tracking time
  history   show work history
  connect   connect Jira
  commit    send last tracked work to Jira worklogs

Note: use 'tl <command> -h' to get help on certain command
EOF
}

if [ -z "$1" ] \
  || [ "$1" = "-h" ] \
  || [ "$1" = "--help" ] \
  || [ "$1" = "main" ] \
  || [ "$1" = "help" ]; then
  show_help
  return 0
fi

subcommand="$1"
cd "$(dirname "$(readlink -f "$0")")" || return 1
script="./${subcommand}.sh"
if [ ! -f "$script" ]; then
  echo "Error: no such timelock command '$subcommand'" >&2
  return 1
fi

shift
$script "$@"
