# Timelock - a shell-based time tracking utility


## Disclaimer

I'm just learning shell scripting, don't judge strictly :)
Use these scripts on your own risk.


## Installation

```shell
git clone https://github.com/roflganker/timelock.git
sh timelock/install.sh  # Run this as superuser
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

