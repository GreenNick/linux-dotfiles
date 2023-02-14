#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

# Run picom compositor
run picom

# Remap caps lock to ctrl
run setxkbmap -option caps:ctrl_modifier
