#!/bin/sh

usage="$0 <option>";

option="$1";
if [ -z "$option" ]; then
  echo "Usage: $usage" >&2;
  return 1;
fi

executable="${option}.sh"
if [ ! -f "$executable" ] || [ ! -x "$executable"  ]; then
  echo "No such $0 option: $option" >&2;
  return 1;
fi

./${option}.sh
