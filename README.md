# tt.sh - a shell-based time tracking utility


## Disclaimer

I'm just learning shell scripting, don't judge strictly :)
Use these scripts on your own risk.


## Installation

```shell
git clone https://github.com/roflganker/timetrack.sh.git
cd timetrack.sh
chmod +x ./install.sh

# Switch to superuser here, or run with sudo
./install.sh
```


## Usage

```shell
tt start  # Start working
tt status  # Get currect work status  
tt stop  # Stop working and track time
tt rotate  # Track time and switch to another task
tt history  # Get history (for now, use grep for filtering)
```


## TODO

- History filters
- Unit/e2e test coverage
- Compatibility tests for `bash`, `ash`, `zsh`, etc...
- Integration with team services: Jira, Redmine... (maybe)

