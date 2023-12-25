#!/bin/sh

. ./common.sh

if [ ! -f $stampfile ] || [ ! -s $stampfile ]; then
  echo "Error: currently not working on anything" >&2;
  return 1;
fi

message="$(cat $msgfile)"
starttime="$(cat $stampfile)"
curtime="$(date +%s)"
timediff="$(expr $curtime - $starttime)"
humantime="$(seconds_to_hm $timediff)"

conf=""
while [ -z "$conf" ]; do
  echo -n "Erase work on $message for $humantime? Y/N " >&2
  read conf
  if [ "$conf" = "N" ] || [ "$conf" = "n" ]; then
    echo "Ok. Rolling back" >&2
    return 1
  fi
done

rm $stampfile
rm $msgfile
echo "Erased." >&2

