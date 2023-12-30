#!/bin/sh

test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh

_lib_jira_home="$(lib_tl_get_home_dir)/jira"
_lib_jira_url_file="$_lib_jira_home/baseurl"
_lib_jira_email_file="$_lib_jira_home/email"
_lib_jira_apikey_file="$_lib_jira_home/apikey"

fail() {
  echo "$1" >&2
  return 1
}

lib_jira_is_connected() {
  test -s "$_lib_jira_email_file" \
    && test -s "$_lib_jira_url_file" \
    && test -s "$_lib_jira_apikey_file"
}

lib_jira_get_email() {
  cat "$_lib_jira_email_file"
}

lib_jira_get_baseurl() {
  cat "$_lib_jira_url_file"
}

lib_jira_connect() (
  usage="lib_jira_connect <baseurl> <email> <apikey>"
  baseurl="$1"
  email="$2"
  apikey="$3"
  if [ -z "$baseurl" ]; then fail "Missing baseurl. Usage: $usage"; fi
  if [ -z "$email" ]; then fail "Missing email. Usage: $usage"; fi
  if [ -z "$apikey" ]; then fail "Missing apikey. Usage: $usage"; fi

  if [ ! -d "$_lib_jira_home" ]; then mkdir "$_lib_jira_home"; fi
  echo "$baseurl" >"$_lib_jira_url_file"
  echo "$email" >"$_lib_jira_email_file"
  echo "$apikey" >"$_lib_jira_apikey_file"

  # We hide apikey from everyone except current user
  chmod 600 "$_lib_jira_apikey_file"
)

lib_jira_disconnect() {
  rm -rf "$_lib_jira_home"
}

lib_jira_add_worklog() {
  usage="lib_jira_add_worklog <issue> <start time> <work seconds> <comment>"
  jira_issue="$1"
  start_time="$2"
  work_seconds="$3"
  work_comment="$4"
  if [ -z "$issue" ]; then fail "Missing issue. Usage: $usage"; fi
  if [ -z "$start_time" ]; then fail "Missing start time. Usage: $usage"; fi
  if [ -z "$work_seconds" ]; then fail "Missing work time. Usage: $usage"; fi

  if ! lib_jira_is_connected; then fail "Jira not connected"; fi
  jira_baseurl="$(cat "$_lib_jira_url_file")"
  jira_email="$(cat "$_lib_jira_email_file")"
  jira_apikey="$(cat "$_lib_jira_apikey_file")"
  jira_start_date="$(date +"%Y-%m-%dT%H:%M:%S.000%z" --date=@"$start_time")"

  if ! which curl >/dev/null 2>/dev/null; then
    fail 'Curl is not installed. Please visit https://github.com/curl/curl'
  fi

  curl \
    --request POST \
    --url "${jira_baseurl}/rest/api/2/issue/${jira_issue}/worklog" \
    --user "${jira_email}:${jira_apikey}" \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data "{
      \"comment\": \"${work_comment}\",
      \"started\": \"${jira_start_date}\",
      \"timeSpentSeconds\": ${work_seconds}
    }"
}
