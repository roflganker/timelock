#!/bin/sh

. ./common.sh

baseurl=""
email=""
apikey=""

while [ -z "$email" ]; do
  echo -n "Who are you? (email on Atlassian) " >&2;
  read email
done

while [ -z "$baseurl" ]; do
  echo -n "Enter base URL of your Jira instance: " >&2;
  read baseurl
done

while [ -z "$apikey" ]; do
  echo -n "Your personal API token? " >&2;
  oldstty="$(stty -g)"
  stty -echo
  read apikey
  stty $oldstty
done

# TODO persit things

