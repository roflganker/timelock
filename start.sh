#!/bin/sh

. ./common.sh

if [ -f $stampfile ] && [ -s $stampfile ]; then
  oldmsg="$(cat $msgfile)";
  oldstamp="$(cat $stampfile)";
  olddate="$(date --date=@$oldstamp)"
  
  echo "Error: already working on $oldmsg since $olddate" >&2;
  return $ERR_ALREADY_RUNNING;
fi

message=""
while [ -z "$message" ]; do
  echo -n "What are you working on? " >&2;
  read message;
done

timestamp="$(date +%s)"
echo $timestamp > $stampfile
echo $message > $msgfile
echo "You started working on $message" >&2;

