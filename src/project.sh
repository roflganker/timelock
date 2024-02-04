#!/bin/sh

show_help() {
  cat <<EOF
Usage: tl project ...options
Timelock allows to keep several workspaces(projects); each with its own
status, history, and Jira integrations.
This command performs Timelock project management

Possible options are:
  -s        show current project only
  -n        create a new project
  -c        change/checkout to other project
  -d        delete existing project
  -i <id>   specify project id
  -h        show this help message

Note: -s yields project id to stdout. Other human messages go to stderr 
Note: If -n and -c specified, new project is created and you switched to it
Note: The same trick wouldn't work for project removal
EOF
}

while getopts ':sncdi:h' opt; do
  case "$opt" in
    *) ;;
  esac
done

