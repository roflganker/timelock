#!/bin/sh

. ./common.sh

if [ -f $stampfile ] && [ -s $stampfile ]; then
  oldsubj="$(cat $subjfile)";
  oldstamp="$(cat $stampfile)";
  olddate="$(date --date=@$oldstamp)"
  
  echo "Error: already working on $oldsubj since $olddate" >&2;
  return 1;
fi

subject=""
while [ -z "$subject" ]; do
  echo -n "What are you working on? " >&2;
  read subject;
done

timestamp="$(date +%s)"
echo $timestamp > $stampfile
echo $subject > $subjfile
echo "You started working on $subject" >&2;

