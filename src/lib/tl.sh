#!/bin/sh

test -z "$LIB_TL_SOURCED" || echo "Tl lib duplication" >&2
test -n "$HOME" || { echo "No \$HOME var" >&2 && return 1; }
test -d "$HOME" || { echo "Missing directory $HOME" >&2 && return 1; }

_lib_tl_home="$HOME/.timelock"
test -d "$_lib_tl_home" || mkdir "$_lib_tl_home" || return 1

lib_tl_get_home_dir() {
  echo "$_lib_tl_home"
}

# Chech whether work is in progress
lib_tl_get_is_working() (
  time_file="$_lib_tl_home/time"
  test -f "$time_file" -a -s "$time_file"
)

# Interact with timelock state
lib_tl() (
  usage="lib_tl <get|set|drop|has> <time|subject> [content]"

  case "$2" in
    t | time) item_file="$_lib_tl_home/time" ;;
    s | subj | subject) item_file="$_lib_tl_home/subj" ;;
    *) echo "Invalid item '$2'. Usage: $usage" && return 1 ;;
  esac

  case "$1" in
    g | get | cat | read) cat "$item_file" ;;
    s | set | write) echo "$3" >"$item_file" ;;
    d | drop | rm) rm -f "$item_file" ;;
    h | has)
      test -f "$item_file" -a -s "$item_file"
      return "$?"
      ;;
    *) echo "Invalid action '$1'. Usage: $usage" && return 1 ;;
  esac
)

LIB_TL_SOURCED="1"
