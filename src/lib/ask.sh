#!/bin/sh

# Duplicate sourcing guard
test -z "$LIB_ASK_SOURCED" || {
  echo "Duplication lib ask" >&2
  return 1
}

# Interactively ask confirmation (y/n) from user
lib_ask_confirm() (
  prompt="$1"
  if [ -z "$prompt" ]; then prompt='Are you sure?'; fi

  answer="n"
  while [ "$answer" != "y" ]; do
    printf "%s y/n " "$prompt" >&2
    read -r answer
    if [ "$answer" = "n" ]; then

      echo 'You refused it' >&2
      return 1
    fi
  done
)

# Interactively ask a single line from user
lib_ask_line() (
  usage="lib_ask_line <prompt>"

  prompt="$1"
  default="$2"
  if [ -z "$prompt" ]; then
    echo "Missing prompt. Usage: $usage" >&2
    return 1
  fi

  result=""
  while [ -z "$result" ]; do
    if [ -n "$default" ]; then
      printf "%s (%s) " "$prompt" "$default" >&2
    else
      printf "%s " "$prompt" >&2
    fi
    read -r result
    if [ -z "$result" ] && [ -n "$default" ]; then
      result="$default"
    fi
  done
  echo "$result"
)

# Interactively ask a single word from user
lib_ask_word() {
  line="$(ask_line "$@")"
  word="${line%% *}"
  echo "$word"
}

# Interactively ask secret from a user
lib_ask_secret() (
  usage="lib_ask_secret <prompt>"

  prompt="$1"
  test -n "$prompt" || echo "Missing prompt. Usage: $usage" >&2 && return 1

  while [ -z "$secret" ]; do
    printf "%s " "$prompt" >&2
    oldstty="$(stty -g)"
    stty -echo
    read -r secret
    stty "$oldstty"
    echo >&2
  done
  echo "$secret"
)

LIB_ASK_SOURCED="1"
