# My shell "libraries"

These files are libraries, providing reusable functionality for Timelock.
Each library "exports" functionality via shell functions.


## Disclaimer

I know that _shell isn't a developer language_ and it should not have such
mechanisms. I'm just experimenting and having fun ;)


## Usage

In order to get library functionality in your script, just source library file

```shell
# POSIX variant
. ./lib/date.sh

# Bash variant
source ./lib/date.bash
```

To avoid duplicate sourcing, use following guards

```shell
test -n "LIB_DATE_IMPORTED" || . ./lib/date.sh
```

This approach is inspired by C's [include guards](https://en.wikipedia.org/wiki/Include_guard),
but implemented slightly different manner..


## Conventions

My own conventions on shell "libraries":
- Exported function names start with `lib_<libname>`
- Libraries export `LIB_<libname>_SOURCED="1"`
  in order to ogranise anti-duplication guards
- Variales inside functions considered private,
  var names start with `_lib_<libname>`

