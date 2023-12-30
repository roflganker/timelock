#!/bin/sh

test -z "$LIB_TL_SOURCED" || { echo 'Duplication lib tl' >&2; return 1 }
test -n "$HOME" || { echo 'No $HOME var' >&2; return 1; }
test -d "$HOME" || { echo 'Missing $HOME dir' >&2; return 1; }
test -d "$HOME/.timelock" || mkdir "$HOME/.timelock" || return 1

# Get home directory of Timelock
lib_tl_home_dir() {
  echo "$HOME/.timelock"
}

# Get timestamp file of Timelock
lib_tl_time_file() {
  echo "$HOME/.timelock/time"
}

# Get subject file of Timelock
lib_tl_subj_file() {
  echo "$HOME/.timelock/subj"
}

# Check whether work is in progress
lib_tl_is_working() (
  timefile="$(lib_tl_time_file)"
  test -f "$timefile" && test -s "$timefile"
)

LIB_TL_SOURCED="1"

