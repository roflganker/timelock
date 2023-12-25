# Timelock - a shell-based time tracking utility


## Disclaimer

I'm just learning shell scripting, don't judge strictly :)
Use these scripts on your own risk.


# Rationale

This tool needed to track working hours without signing in with Google,
X, or smth.. It also don't require Internet and frees you from ineracting
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
tl rotate  # Track time and switch to another task
tl history  # Get history (for now, use grep for filtering)
```


## TODO

- History filters
- Unit/e2e test coverage
- Compatibility tests for `bash`, `ash`, `zsh`, etc...
- Integration with team services: Jira, Redmine... (maybe)

