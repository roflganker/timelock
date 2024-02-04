#!/usr/bin/env bash

options=(
  start
  link
  status
  stop
  change
  history
  connect
  commit
  sync
)

complete -W "${options[*]}" tl
