#!/bin/sh

usage="$0 <service>";

service="$1"
if [ -z "$service" ]; then
  echo "Missing service. Usage: $usage" >&2;
  return 1;
fi

scriptdir="./svc/$service"
script="$scriptdir/install.sh"
if [ ! -d $scriptdir ] || [ ! -f $script ]; then
  echo "Connection with $service is not implemented" >&2;
  return 1;
fi

$script;

