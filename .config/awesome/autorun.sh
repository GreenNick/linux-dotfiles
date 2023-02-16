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

# Start up ssh-agent
ssh_init() {
  if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
}

run ssh_init
