# Timelock - a shell-based time tracking utility


## Disclaimer

I'm learning shell scripting and this is my pet project.
Don't judge strictly :) Use these scripts on your own risk.


# Rationale

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
tl start  # Start working
tl status  # Get currect work status  
tl stop  # Stop working and track time
tl drop  # Erase current work unit
tl rotate  # Track time and switch to another task
tl history  # Get all history
tl history -f week|today|yesterday|w|t|y  # Get filtered history
```


## TODO

- Unit/e2e test coverage
- Compatibility tests for `bash`, `ash`, `zsh`, etc...
- Integration with Jira
- Use Makefile for linting and installation

### Involved dev tools

- 🏗️ Code analyzer -> [shellcheck](https://github.com/koalaman/shellcheck)
- 👗 Formatting utility -> [shfmt](https://github.com/mvdan/sh)

