export PATH="$HOME/dev/flutter/bin:$PATH"
. "$HOME/.cargo/env"

eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
