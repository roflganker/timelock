# My shell "libraries"

These files are libraries, providing reusable functionality for Timelock.
Each library "exports" functionality via shell functions.


## Disclaimer

I know that _shell isn't a developer language_ and it should not have such
mechanisms. I'm just experimenting.


## Usage

In order to get library functionality in your script, just source library file

```shell
. ./lib/date.sh
```

To avoid duplicate sourcing, use following guards

```shell
test -n "LIB_DATE_IMPORTED" || . ./lib/date.sh
```

This approach is inspired by C's [include guards](https://en.wikipedia.org/wiki/Include_guard), but in
slightly different manner

