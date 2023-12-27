#!/bin/sh

set -e

test -n "$HOME"
test -d "$HOME"
homedir="$HOME/.timelock"
[ ! -d "$homedir" ] && mkdir "$homedir"

tl_homedir() { echo "$homedir"; }
tl_stampfile() { echo "$homedir/time"; }
tl_subjfile() { echo "$homedir/subj"; }
tl_histfile() { echo "$homedir/history"; }

tl_is_working() {
  test -f "$(tl_stampfile)"
  test -s "$(tl_stampfile)"
}

fail() {
  echo "$1" >&2
  return 1
}

# Ask confirmation from user
confirm() (
  prompt="$1"
  if [ -z "$prompt" ]; then prompt='Are you sure?'; fi

  answer="n"
  while [ "$answer" != "y" ]; do
    printf "%s y/n " "$prompt" >&2
    read -r answer
    if [ "$answer" = "n" ]
      then fail 'You refused it'
    fi
  done 
)

ask_line() (
  usage="ask_line <prompt>"

  prompt="$1"
  if [ -z "$prompt" ]; then fail "Missing prompt. Usage: $usage"; fi
  
  result=""
  while [ -z "$result" ]; do
    printf "%s " "$prompt" >&2
    read -r result
  done
  echo "$result"
)

ask_secret() (
  usage="ask_secret <prompt>"

  prompt="$1"
  test -z "$prompt" && complain "Missing prompt. Usage: $usage"
  
  while [ -z "$secret" ]; do
    printf "%s " "$prompt" >&2
    oldstty="$(stty -g)"
    stty -echo
    read -r secret
    stty "$oldstty"
  done
  echo "$secret"
)

format_seconds() (
  usage="format_seconds <seconds>"

  seconds="$1"
  if [ -z "$seconds" ]; then
    echo "Usage: $usage" >&2
    return 1
  fi

  if [ -z "${seconds##*[!0-9]*}" ]; then
    echo "Argument must be an integer" >&2
    return 1
  fi

  hours=$(( seconds / 3600))
  seconds=$(( seconds % 3600 ))
  minutes=$(( seconds / 60))
  seconds=$(( seconds % 60 ))
  
  if [ $hours != "0" ]; then
    echo "${hours}h ${minutes}m ${seconds}s"
  elif [ $minutes != "0" ]; then
    echo "${minutes}m ${seconds}s"
  else
    echo "${seconds}s"
  fi
)

format_timediff() (
  usage="format_timediff <start> <end>"
  starttime="$1"
  endtime="$2"
  
  if [ -z "$starttime" ]; then fail "Missing start. Usage: $usage"; fi
  if [ -z "$endtime" ]; then fail "Missing end. Usage: $usage"; fi
  if [ "$starttime" -gt "$endtime" ]; then fail 'Invalid timespan'; fi
  
  format_seconds $(( endtime - starttime ))
)

