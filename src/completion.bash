#!/usr/bin/env bash

options=(
  start
  status
  stop
  change
  history
  connect
  commit
)

complete -W "${options[*]}" tl
