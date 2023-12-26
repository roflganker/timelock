#!/bin/sh

if [ -z "$HOME" ] || [ ! -d "$HOME" ]; then
  echo "You're homeless :)" >&2;
  return 1;
fi;

homedir="$HOME/.timelock"
[ ! -d "$homedir" ] && mkdir "$homedir";

stampfile="$homedir/time"
msgfile="$homedir/msg"
histfile="$homedir/history"

seconds_to_hms() {
  local usage="seconds_to_hms <seconds>";

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
  seconds="$(expr $seconds % 3600 )"
  local minutes="$(expr $seconds / 60)"
  seconds="$(expr $seconds % 60 )"
  
  if [ $hours != "0" ]; then
    echo "${hours}h ${minutes}m ${seconds}s"
  elif [ $minutes != "0" ]; then
    echo "${minutes}m ${seconds}s"
  else
    echo "${seconds}s"
  fi
}

