#!/bin/sh

# Complain if this library was sourced already
test -z "$LIB_JIRA_SOURCED" || echo "Duplication lib jira" >&2

# Import dependency libraries
test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh

_lib_jira_home="$(lib_tl_get_home_dir)/jira"
_lib_jira_url_file="$_lib_jira_home/url"
_lib_jira_email_file="$_lib_jira_home/email"
_lib_jira_apikey_file="$_lib_jira_home/apikey"
_lib_jira_worklog_file="$_lib_jira_home/worklogs"

lib_jira_is_connected() {
  test -s "$_lib_jira_email_file" -a \
    -s "$_lib_jira_url_file" -a \
    -s "$_lib_jira_apikey_file"
}

lib_jira_get_email() {
  cat "$_lib_jira_email_file"
}

lib_jira_get_url() {
  cat "$_lib_jira_url_file"
}

lib_jira_connect() (
  usage="lib_jira_connect <url> <email> <apikey>"
  url="$1"
  email="$2"
  apikey="$3"
  if [ -z "$url" ]; then
    echo "Missing url. Usage: $usage" >&2 && return 1
  fi
  if [ -z "$email" ]; then
    echo "Missing email. Usage: $usage" >&2 && return 1
  fi
  if [ -z "$apikey" ]; then
    echo "Missing apikey. Usage: $usage" >&2 && return 1
  fi

  if [ ! -d "$_lib_jira_home" ]; then mkdir "$_lib_jira_home"; fi
  echo "$url" >"$_lib_jira_url_file"
  echo "$email" >"$_lib_jira_email_file"
  echo "$apikey" >"$_lib_jira_apikey_file"
  touch "$_lib_jira_worklog_file"

  # We hide apikey from everyone except current user
  chmod 600 "$_lib_jira_apikey_file"
)

lib_jira_disconnect() {
  rm -rf "$_lib_jira_home"
}

# Check whether worklog of specified start time was sent to Jira
lib_jira_is_worklogged() {
  usage="lib_jira_is_worklogged <start time>"
  start_time="$1"
  if [ -z "$start_time" ]; then
    echo "Missing start time. Usage: $usage" >&2 && return 1
  fi

  grep "$start_time" "$_lib_jira_worklog_file" >/dev/null 2>/dev/null
}

# Send worklog to Jira
lib_jira_add_worklog() (
  usage="lib_jira_add_worklog <issue> <start time> <work seconds> <comment>"

  jira_issue="$1"
  start_time="$2"
  work_seconds="$3"
  work_comment="$4"
  if [ -z "$jira_issue" ]; then
    echo "Missing issue. Usage: $usage" >&2 && return 1
  fi
  if [ -z "$start_time" ]; then
    echo "Missing start time. Usage: $usage" >&2 && return 1
  fi
  if [ -z "$work_seconds" ]; then
    echo "Missing work time. Usage: $usage" >&2 && return 1
  fi

  # Jira does not accept worklogs shorter than one minute
  if [ "$work_seconds" -lt "60" ]; then
    work_seconds="60"
  fi

  if ! lib_jira_is_connected; then
    echo 'Jira not connected. Please run tl connect' >&2 && return 1
  fi
  if lib_jira_is_worklogged "$start_time"; then
    echo 'Worklog was already sent to Jira' >&2 && return 1
  fi
  if ! which curl >/dev/null 2>/dev/null; then
    echo 'Curl not installed. Please visit https://github.com/curl/curl' >&2 && return 1
  fi

  jira_url="$(cat "$_lib_jira_url_file")"
  jira_email="$(cat "$_lib_jira_email_file")"
  jira_apikey="$(cat "$_lib_jira_apikey_file")"
  jira_start_date="$(date +"%Y-%m-%dT%H:%M:%S.000%z" --date=@"$start_time")"

  if curl \
    --request POST \
    --fail \
    --silent \
    --url "${jira_url}/rest/api/2/issue/${jira_issue}/worklog" \
    --user "${jira_email}:${jira_apikey}" \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data "{
      \"comment\":\"${work_comment}\",
      \"started\":\"${jira_start_date}\",
      \"timeSpentSeconds\":${work_seconds}
    }" >/dev/null; then
    echo "$start_time" >>"$_lib_jira_worklog_file"
    return 0
  else
    return 1
  fi
)

LIB_JIRA_SOURCED="1"
