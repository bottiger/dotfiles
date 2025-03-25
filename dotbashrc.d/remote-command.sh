#!/usr/bin/env bash

# Set a random background color for the terminal when connecting to a remote host
ssh() {
    local remote_host="$1"
    
    if [[ -n "$remote_host" ]]; then
        set_rnd_bg_color "$remote_host"
    fi

    command ssh "$@"

    if [ -t 1 ]; then
        set_rnd_bg_color
    fi
}