#!/bin/sh

test -n "$LIB_TL_SOURCED" || . ./lib/tl.sh
test -z "$LIB_JIRA_SOURCED" || echo "Duplication lib jira" >&2

_lib_jira_home="$(lib_tl_get_home_dir)/jira"
_lib_jira_url_file="$_lib_jira_home/url"
_lib_jira_email_file="$_lib_jira_home/email"
_lib_jira_apikey_file="$_lib_jira_home/apikey"

fail() {
  echo "$1" >&2
  return 1
}

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
  if [ -z "$url" ]; then fail "Missing url. Usage: $usage"; fi
  if [ -z "$email" ]; then fail "Missing email. Usage: $usage"; fi
  if [ -z "$apikey" ]; then fail "Missing apikey. Usage: $usage"; fi

  if [ ! -d "$_lib_jira_home" ]; then mkdir "$_lib_jira_home"; fi
  echo "$url" >"$_lib_jira_url_file"
  echo "$email" >"$_lib_jira_email_file"
  echo "$apikey" >"$_lib_jira_apikey_file"

  # We hide apikey from everyone except current user
  chmod 600 "$_lib_jira_apikey_file"
)

lib_jira_disconnect() {
  rm -rf "$_lib_jira_home"
}

lib_jira_add_worklog() (
  usage="lib_jira_add_worklog <issue> <start time> <work seconds> <comment>"

  set -e
  jira_issue="$1"
  start_time="$2"
  work_seconds="$3"
  work_comment="$4"
  if [ -z "$jira_issue" ]; then fail "Missing issue. Usage: $usage"; fi
  if [ -z "$start_time" ]; then fail "Missing start time. Usage: $usage"; fi
  if [ -z "$work_seconds" ]; then fail "Missing work time. Usage: $usage"; fi
  if [ "$work_seconds" -lt "60" ]; then work_seconds="60"; fi

  if ! lib_jira_is_connected; then fail "Jira not connected"; fi
  jira_url="$(cat "$_lib_jira_url_file")"
  jira_email="$(cat "$_lib_jira_email_file")"
  jira_apikey="$(cat "$_lib_jira_apikey_file")"
  jira_start_date="$(date +"%Y-%m-%dT%H:%M:%S.000%z" --date=@"$start_time")"

  if ! which curl >/dev/null 2>/dev/null; then
    fail 'Curl is not installed. Please visit https://github.com/curl/curl'
  fi

  curl \
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
    }" >/dev/null
)

LIB_JIRA_SOURCED="1"
