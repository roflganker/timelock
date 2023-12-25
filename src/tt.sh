#!/bin/sh

usage="$0 <option>";

option="$1";
if [ -z "$option" ]; then
  echo "Usage: $usage" >&2
  return 1
fi

cd $(dirname $(readlink -f $0))
script="./${option}.sh"
if [ ! -f "$script" ] || [ ! -x "$script"  ]; then
  echo "No such $0 option: $option" >&2;
  return 1;
fi

$script

