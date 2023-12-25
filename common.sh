#!/bin/sh

if [ -z "$HOME" ]; then
  echo "You're homeless :)" >&2;
  return 1;
fi;

homedir="$HOME/.timetrack"
[ ! -d "$homedir" ] && mkdir "$homedir";

stampfile="$homedir/time"
msgfile="$homedir/msg"
histfile="$homedir/history"

seconds_to_hm() {
  local usage="seconds_to_hm <seconds>";

  local seconds="$1";
  if [ -z "$seconds" ]; then
    echo "Usage: $usage" >&2;
    return 1;
  fi

  if [ -z "${seconds##*[!0-9]*}" ]; then
    echo "Argument must be an integer" >&2;
    return 1;
  fi

  local hours="$(expr $seconds / 3600)"
  local minutes="$(expr \( $seconds % 3600 \) / 60)"

  echo "${hours}h ${minutes}m";
}

