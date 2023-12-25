#!/bin/sh

. ./common.sh

if [ ! -f $stampfile ] || [ ! -s $stampfile ]; then
  echo "Error: currently not working on anything" >&2;
  return $ERR_NOT_WORKING;
fi

message="$(cat $msgfile)"
starttime="$(cat $stampfile)"
curtime="$(date +%s)"
timediff="$(expr $curtime - $starttime)"
humantime="$(seconds_to_hm $timediff)"

echo "You worked on $message for $humantime" >&2;
rm $stampfile
rm $msgfile

histentry="$starttime $curtime $message"
echo "$histentry" >> $histfile

