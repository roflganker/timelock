#!/usr/bin/env bash

options=(
  project
  start
  status
  stop
  change
  history
  connect
  commit
  sync
)

complete -W "${options[*]}" tl
