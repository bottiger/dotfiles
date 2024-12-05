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
)

configfolders=(
	dotconfig/fish
)

for f in "${dotfiles[@]}"; do
	[[ -d ~/.$f && ! -L ~/.$f ]] && rm -r ~/."$f"
	symlink "$PWD/$f" ~/."$f"
done

# Symlink folders in configfolders
for folder in "${configfolders[@]}"; do
    folder_name=$(basename "$folder") # Extract folder name (e.g., fish)
    target=~/.config/"$folder_name"  # Target in ~/.config
    source="$PWD/$folder"           # Source in $PWD/dotconfig

    [[ -d "$target" && ! -L "$target" ]] && rm -r "$target"
    symlink "$source" "$target"
done

# neovim
symlink ~/.vim ~/.config/nvim
