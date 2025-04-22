#!/bin/env bash

init_ssh_config() {
  # Define the unique marker string
  marker="# Global SSH settings for automatic color changing"
  start_marker="# BEGIN SSH CONFIG BLOCK"
  end_marker="# END SSH CONFIG BLOCK"

  # Create or append to SSH config
  mkdir -p ~/.ssh
  touch ~/.ssh/config

  # Capture original permissions
  perms=$(stat -c %a ~/.ssh/config 2>/dev/null || stat -f %Lp ~/.ssh/config)

  # Remove existing block if it exists
  if grep -q "$start_marker" ~/.ssh/config; then
    tmpfile=$(mktemp)
    sed "/$start_marker/,/$end_marker/d" ~/.ssh/config > "$tmpfile"
    mv "$tmpfile" ~/.ssh/config
    chmod "$perms" ~/.ssh/config
  fi

  # Append the new block
  cat >> ~/.ssh/config <<EOF

$start_marker
$marker
Host *
    # RemoteCommand echo "hi" && test -f ~/.bashrc.d/remote-command.sh && ~/.bashrc.d/remote-command.sh; bash
    RequestTTY yes
$end_marker
EOF
}

init_ssh_config