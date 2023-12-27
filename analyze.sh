#!/bin/sh

if ! which shellcheck >/dev/null 2>/dev/null; then
  echo "Seems like shellcheck is not installed" >&2
  echo "Please visit https://github.com/koalaman/shellcheck" >&2

  exit 1
fi

shellcheck ./src/*.sh

