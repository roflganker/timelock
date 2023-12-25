#!/bin/sh

usage="tl <option>";

option="$1";
if [ -z "$option" ]; then
  echo "Missing option. Usage: $usage" >&2
  return 1
fi

if [ "$option" = "common" ] || [ "$option" = "tl" ]; then
  echo "Invalid option. Usage: $usage" >&2
  return 1
fi

cd $(dirname $(readlink -f $0))
script="./${option}.sh"
if [ ! -f "$script" ]; then
  echo "No such $0 option: $option" >&2
  return 1;
fi

if [ ! -s "$script" ] || [ ! -x "$script" ]; then
  echo "Installation error. Please, reinstall the utility" >&2
  return 1;
fi

$script

