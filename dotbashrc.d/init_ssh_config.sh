#!/bin/env bash

init_ssh_config() {
  # Define the unique marker string
  marker="# Global SSH settings for automatic color changing"

  # Create or append to SSH config
  mkdir -p ~/.ssh
  touch ~/.ssh/config

  # Check if the block already exists
  if ! grep -Fxq "$marker" ~/.ssh/config; then
    cat >> ~/.ssh/config <<EOF

$marker
Host *
    RemoteCommand ~/.bashrc.d/remote-command.sh
    RequestTTY yes
EOF
  fi
}

init_ssh_config