#!/bin/sh

if ! which shfmt >/dev/null 2>/dev/null; then
  echo "Seems like shfmt not installed :(" >&2
  echo "Please visit https://github.com/mvdan/sh" >&2

  return 1
fi

shfmt -i 2 -ci -bn -l -w ./src
shfmt -i 2 -ci -bn -l -w ./install.sh

