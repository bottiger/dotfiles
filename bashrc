# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ssh-illumos='ssh -p 3022 bottiger@127.0.0.1'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
. "$HOME/.cargo/env"

eval "$(starship init bash)"

set_bg_color() {
    local color="$1"
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
  #local input=${1:-$HOSTNAME}
  local input=${1:-$(get_hardware_uuid)}

  echo input: $input

  # Check if md5sum is installed
  if command -v md5sum > /dev/null; then
    # Generate a number between 1 and 10 based on the input
    input_hash=$(echo -n "$input" | md5sum | awk '{print $1}')
    color_index=$((0x${input_hash:0:8} % 10 + 1))

    echo color_index: $color_index

    # Set terminal background color based on the hashed value
    case "$color_index" in
      1) echo -e "\033]11;#200000\007" ;;  # Dark Red
      2) echo -e "\033]11;#002000\007" ;;  # Dark Green
      3) echo -e "\033]11;#000020\007" ;;  # Dark Blue
      4) echo -e "\033]11;#202000\007" ;;  # Dark Olive
      5) echo -e "\033]11;#002020\007" ;;  # Dark Teal
      6) echo -e "\033]11;#200020\007" ;;  # Dark Purple
      7) echo -e "\033]11;#200800\007" ;;  # Dark Brown
      8) echo -e "\033]11;#A91B60\007" ;;  # Dark Pink
      9) echo -e "\033]11;#082008\007" ;;  # Forest Shadow Green
      10) echo -e "\033]11;#080820\007" ;; # Midnight Shadow Blue
      *)
        echo -e "\033]11;#000000\007" ;;   # Fallback to black
    esac
  else
    echo "md5sum is not installed; skipping background color setup."
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

# Store the original background color
store_current_bg_color

set_rnd_bg_color

trap 'set_bg_color "$ORIGINAL_BG_COLOR_HEX"' EXIT

export PATH="$PATH:~/scripts"

# suppress deprecation warnings from bash on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1


