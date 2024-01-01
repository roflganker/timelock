#!/usr/bin/env bash

options=(
  start
  status
  stop
  drop
  change
  history
  help
  connect
  commit
)

complete -W "${options[*]}" tl
