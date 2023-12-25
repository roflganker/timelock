#!/bin/sh

. ./common.sh

if [ -f $stampfile ] && [ -s $stampfile ]; then
  message="$(cat $msgfile)";
  starttime="$(cat $stampfile)";
  curtime="$(date +%s)";
  timediff="$(expr $curtime - $starttime)"

  echo "Working on $message for $(seconds_to_hm $timediff)" >&2;  
else
  echo "Not working at the moment" >&2;
fi

