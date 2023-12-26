#!/bin/sh

. ./common.sh

if [ -f $stampfile ] && [ -s $stampfile ]; then
  subject="$(cat $subjfile)";
  starttime="$(cat $stampfile)";
  curtime="$(date +%s)";
  timediff="$(expr $curtime - $starttime)"

  echo "Working on $subject for $(seconds_to_hms $timediff)" >&2;  
else
  echo "Not working at the moment" >&2;
fi

