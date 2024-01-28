#!/bin/sh

# Duplicate sourcing guard
if [ -n "$LIB_EXAMPLE_SOURCED" ]; then
  echo "Duplicate sourcing of example library!" >&2
  return 1
fi

lib_example_get_hello() {
  echo "Hello from example lib"
}

LIB_EXAMPLE_SOURCED="1"
