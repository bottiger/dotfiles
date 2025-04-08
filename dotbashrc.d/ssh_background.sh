set_bg_color() {
    local color="$1"
    export SHELL_BG_COLOR="$color"
    printf "\033]11;%s\007" "$color" > /dev/tty
}

get_hardware_uuid() {
  local uuid

  # macOS: Use ioreg to get the UUID
  if [[ "$(uname)" == "Darwin" ]]; then
    uuid=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')
  fi

  # Linux: Use /etc/machine-id or other available sources
  if [[ "$(uname)" == "Linux" ]]; then
    if [[ -f /etc/machine-id ]]; then
      uuid=$(cat /etc/machine-id)
    elif command -v dmidecode > /dev/null 2>&1; then
      uuid=$(dmidecode -s system-uuid 2>/dev/null)
    else
      uuid=$(hostname)
    fi
  fi

  # Fallback if no UUID is found
  if [[ -z "$uuid" ]]; then
    uuid="fallback-uuid"
  fi

  echo "$uuid"
}

set_rnd_bg_color() {
  local input

  # If an argument is provided, use it and set the environment variable
  if [[ -n "$1" ]]; then
    input="$1"
    #export SHELL_BG_COLOR="$1"
    set_bg_color "$1"
    # If the environment variable is set, use it
    return
  elif [[ -n "$SHELL_BG_COLOR" ]]; then
    input="$SHELL_BG_COLOR"
    set_bg_color "$SHELL_BG_COLOR"
    return 
  else
    # Otherwise, default to the hardware UUID
    input=$(get_hardware_uuid)
  fi

  # Check if md5sum is installed
  if command -v md5sum > /dev/null; then
    # Generate a number between 1 and 10 based on the input
    input_hash=$(echo -n "$input" | md5sum | awk '{print $1}')
    color_index=$((0x${input_hash:0:8} % 10 + 1))

    # Set terminal background color based on the hashed value
    case "$color_index" in
      1) set_bg_color "#200000" ;;  # Dark Red
      2) set_bg_color "#002000" ;;  # Dark Green
      3) set_bg_color "#000020" ;;  # Dark Blue
      4) set_bg_color "#202000" ;;  # Dark Olive
      5) set_bg_color "#002020" ;;  # Dark Teal
      6) set_bg_color "#200020" ;;  # Dark Purple
      7) set_bg_color "#200800" ;;  # Dark Brown
      8) set_bg_color "#A91B60" ;;  # Dark Pink
      9) set_bg_color "#082008" ;;  # Forest Shadow Green
      10) set_bg_color "#080820" ;; # Midnight Shadow Blue
      *)
        set_bg_color "#000000" ;;   # Fallback to black
    esac
  else
    echo "md5sum is not installed; skipping background color setup." >&2
  fi
}

store_current_bg_color() {
  # Temporarily disable terminal echoing to suppress visible output
  stty -echo

  # Query terminal for current background color
  printf "\033]11;?\007" > /dev/tty

  # Use a custom method to silently capture the terminal's response
  exec 3<> /dev/tty  # Open the terminal for reading/writing
  IFS=';' read -r -d $'\007' -u 3 -t 1 -a color_response
  exec 3<&-  # Close file descriptor

  # Re-enable terminal echoing
  stty echo

  # Extract the current color (format is usually "rgb:xxxx/xxxx/xxxx")
  export ORIGINAL_BG_COLOR="${color_response[1]}"

  # Convert the color to a format that can be used to set the background color again
  if [[ $ORIGINAL_BG_COLOR =~ rgb:([0-9a-fA-F]{4})/([0-9a-fA-F]{4})/([0-9a-fA-F]{4}) ]]; then
    r=${BASH_REMATCH[1]:0:2}
    g=${BASH_REMATCH[2]:0:2}
    b=${BASH_REMATCH[3]:0:2}
    export ORIGINAL_BG_COLOR_HEX="#$r$g$b"
  fi
}

validate_bg_color_hex() {
  # Print the value of the variable with contrasting text color
  if [ -n "$ORIGINAL_BG_COLOR_HEX" ]; then
    # Set the text color to white for visibility
    printf "\033[97mThe original background color (hex): %s\033[0m\n" "$ORIGINAL_BG_COLOR_HEX"
  else
    echo "ORIGINAL_BG_COLOR_HEX is empty or not set."
  fi
}

change_color_on_remote() {
  # Check if the SSH_CLIENT variable is set
  if [ -n "$SSH_CLIENT" ]; then
    # Set the background color on the remote machine
    set_bg_color "$1"
  else
    echo "Not connected via SSH; skipping background color change on remote machine."
  fi
}

# Store the original background color
store_current_bg_color

set_rnd_bg_color

trap 'set_bg_color "$ORIGINAL_BG_COLOR_HEX"' EXIT