#!/usr/bin/env bash
#
# install all files to ~ by symlinking them,
# this way, updating them is as simple as git pull
#
# Author: Dave Eddy <dave@daveeddy.com>
# Date: May 25, 2012
# License: MIT

# makes "defaults" command print to screen
defaults() {
	echo defaults "$@"
	command defaults "$@"
}

# verbose ln, because `ln -v` is not portable
symlink() {
	printf '%55s -> %s\n' "${1/#$HOME/\~}" "${2/#$HOME/\~}"
	ln -nsf "$@"
}

git submodule init
git submodule update

# Link dotfiles
dotfiles=(
	bash_completion
	bash_profile
	bashrc
	gitconfig
	htoprc
	screenrc
	tmux.conf
	vimrc
	vim
	envvars
)

configfolders=(
	dotconfig/fish
	dotbashrc.d
)

for f in "${dotfiles[@]}"; do
	[[ -d ~/.$f && ! -L ~/.$f ]] && rm -r ~/."$f"
	symlink "$PWD/$f" ~/."$f"
done

# Symlink folders in configfolders with dot prefix replacement
for folder in "${configfolders[@]}"; do
    source="$PWD/$folder"
    target="$HOME/.${folder#dot}"  # Remove first 'dot' and prepend '.'
    
    # Remove existing directory if it's not a symlink
    [[ -d "$target" && ! -L "$target" ]] && rm -r "$target"
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    #ln -sf "$source" "$target"
	symlink "$source" "$target"
done

# neovim
symlink ~/.vim ~/.config/nvim

source ~/.bashrc.d/init_ssh_config.sh
