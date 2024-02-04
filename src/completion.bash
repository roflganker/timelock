#!/usr/bin/env bash

options=(
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
