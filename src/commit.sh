#!/bin/sh
# Todo: committing many entries
# As example: commit -t => today, commit -y => yesterday

. ./common.sh

history_file="$(tl_histfile)"
if [ ! -f "$history_file" ] || [ ! -s "$history_file" ]; then
  fail 'You dont have timelock history yet'
fi

IFS=' ' read -r hist_start hist_end hist_subject <<TL_COMMIT_EOL
  $(tail -n 1 "$history_file")
TL_COMMIT_EOL

echo "Committing $hist_start $hist_end $hist_subject" >&2

jira_dir="$(tl_homedir)/jira"
if [ ! -d "$jira_dir" ]; then
  fail 'Jira is not connected. Please run tl connect'
fi

jira_email="$(cat "$jira_dir/email")"
jira_baseurl="$(cat "$jira_dir/baseurl")"
jira_apikey="$(cat "$jira_dir/apikey")"

if grep "$hist_start" "$jira_dir/committed"; then
  fail 'This history entry was committed already'
fi

guessed_issue="${hist_subject%% *}"
guessed_comment="${hist_subject#* }"
jira_issue="$(ask_line 'Jira issue?' "$guessed_issue")"
jira_comment="$(ask_line 'Worklog comment?' "$guessed_comment")"
jira_seconds=$((hist_end - hist_start))
jira_start_date=$(date +"%Y-%m-%dT%H:%M:%S%z" --date=@"$hist_start")

echo "About to commit $(format_seconds $jira_seconds) ($jira_start_date)" >&2
ask_confirm "Is information correct?"

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
    \"comment\": \"${jira_comment}\",
    \"started\": \"${jira_start_date}\",
    \"timeSpentSeconds\": ${jira_seconds}
  }"

echo "$hist_start" >>"$jira_dir/committed"
echo "Successfully sent to jira" >&2
