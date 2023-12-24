#!/bin/sh

. ./common.sh

if [ ! -f $stampfile ] || [ ! -s $stampfile ]; then
  echo "Error: currently not working on anything" >&2;
  return $ERR_NOT_WORKING;
fi

oldmsg="$(cat $msgfile)";
oldstamp="$(cat $stampfile)";
curstamp="$(date +%s)";
timediff="$(expr $curstamp - $oldstamp)"

echo "You worked on $oldmsg for $(seconds_to_hm $timediff)" >&2;
rm $stampfile
rm $msgfile

