#!/usr/bin/env bash

options=(
  start
  status
  stop
  drop
  change
  rotate
  history
  help
  connect
  commit
)

complete -W "${options[*]}" tl
