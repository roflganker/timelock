# Timelock - a shell-based time tracking utility


## Disclaimer

I'm learning shell scripting and this is my pet project.
Don't judge strictly :) Use these scripts on your own risk.


## Rationale

This tool needed to track working hours without signing in with Google,
X, or smth.. It also don't require Internet and frees you from interacting
with poorly organized GUI.


## Installation

```shell
git clone https://github.com/roflganker/timelock.git
sh timelock/install.sh  # Run this as superuser (sudo)
rm -rf timelock  # Remove source code (optionally)
```


## Usage

```shell
# Recording time
tl start  # Start working
tl status  # Get currect work status  
tl change  # Change current work subject
tl stop  # Stop working and track time

# History
tl history  # Get all history
tl history -f all|week|today|yesterday  # Get filtered history

# Jira worklogs
tl connect  # Connect with Jira
tl commit  # Send last worklog to Jira
```


## TODO

- Unit/e2e test coverage
- Compatibility tests for `bash`, `ash`, `zsh`, etc...
- Use Makefile for linting and installation
- Print current time inside PS1
- Batch commit (today, yesterday, week)
- Enhanced completion (include options)


### Involved dev tools

- 🏗️ Code analyzer -> [shellcheck](https://github.com/koalaman/shellcheck)
- 👗 Formatting utility -> [shfmt](https://github.com/mvdan/sh)

