#!/bin/sh

. ./common.sh

jiradir=$homedir/jira
if [ -d $jiradir ]; then
  reinstall="n"
  while [ "$reinstall" != "y" ]; do
    echo -n "Jira is connected already. Reinstall? y/n "
    read reinstall;
    if [ "$reinstall" = "n" ]; then
      echo "Ok. Aborting" >&2
      return 1
    fi
  done
  rm -rf $jiradir
  echo "Old Jira connection was erased" >&2
fi

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

mkdir $jiradir
echo $baseurl > $jiradir/baseurl
echo $email > $jiradir/email
echo $apikey > $jiradir/apikey

chmod 600 $jiradir/apikey

echo "Jira connected successfully" >&2

