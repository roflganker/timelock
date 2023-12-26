#!/bin/sh

. ./common.sh

if [ ! -f $stampfile ] || [ ! -s $stampfile ]; then
  echo "Error: currently not working on anything" >&2;
  return 1;
fi

subject="$(cat $subjfile)"
starttime="$(cat $stampfile)"
curtime="$(date +%s)"
timediff="$(expr $curtime - $starttime)"
humantime="$(seconds_to_hms $timediff)"

conf=""
while [ -z "$conf" ]; do
  echo -n "Erase work on $subject for $humantime? Y/N " >&2
  read conf
  if [ "$conf" = "N" ] || [ "$conf" = "n" ]; then
    echo "Ok. Rolling back" >&2
    return 1
  fi
done

rm $stampfile
rm $subjfile
echo "Erased." >&2

