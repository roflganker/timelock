#!/bin/sh

option="$1"
fallback="help"
if [ -z "$option" ]; then
  echo "Error: missing option" >&2
  option=$fallback
fi

if [ "$option" = "common" ] || [ "$option" = "tl" ]; then
  echo "Error: invalid option '$option'" >&2
  option=$fallback
fi

cd $(dirname $(readlink -f $0))
script="./${option}.sh"
if [ ! -f "$script" ]; then
  echo "Error: no such option '$option'" >&2
  option=$fallback
  script="./${option}.sh"
fi

if [ ! -s "$script" ] || [ ! -x "$script" ]; then
  echo "Installation error. Please, reinstall the utility" >&2
  return 1;
fi

$script

