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

echo "You worked on $subject for $humantime" >&2;
rm $stampfile
rm $subjfile

histentry="$starttime $curtime $subject"
echo "$histentry" >> $histfile

