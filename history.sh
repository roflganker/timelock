#!/bin/sh

. ./common.sh

humanize_history() {
  local starttime;
  local endtime;
  local message;

  while IFS=' ' read starttime endtime message; do
    startdate="$(date --date=@$starttime)";
    timediff="$(expr $endtime - $starttime)";
    humantime="$(seconds_to_hm $timediff)";
    
    echo "$startdate: $message ($humantime)"
  done
}

if [ ! -f $histfile ] || [ ! -r $histfile ] || [ ! -s $histfile ]; then
  echo "You have no history yet" >&2;
  return 1;
fi

humanize_history < $histfile

