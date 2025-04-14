# Dotfiles

This repository contains configuration files (dotfiles) for setting up and customizing my personal environment. These files help streamline workflows and ensure consistency across systems.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/bottiger/dotfiles.git
    ```
2. Navigate to the directory:
    ```bash
    cd dotfiles
    ```
3. Run the setup script (if available) or manually copy the files to your home directory:
    ```bash
    ./install.sh
    ```

## Implementation

The install script will symlink all existing dotfiles to the source files inside the checked out git repo.

```
❯ ./install.sh
                         ~/dev/dotfiles/bash_completion -> ~/.bash_completion
                            ~/dev/dotfiles/bash_profile -> ~/.bash_profile
                                  ~/dev/dotfiles/bashrc -> ~/.bashrc
                               ~/dev/dotfiles/gitconfig -> ~/.gitconfig
                                  ~/dev/dotfiles/htoprc -> ~/.htoprc
                                ~/dev/dotfiles/screenrc -> ~/.screenrc
                               ~/dev/dotfiles/tmux.conf -> ~/.tmux.conf
                                   ~/dev/dotfiles/vimrc -> ~/.vimrc
                                     ~/dev/dotfiles/vim -> ~/.vim
                                 ~/dev/dotfiles/envvars -> ~/.envvars
                          ~/dev/dotfiles/dotconfig/fish -> ~/.config/fish
                             ~/dev/dotfiles/dotbashrc.d -> ~/.bashrc.d
                                                 ~/.vim -> ~/.config/nvim
```

## Contributing

Feel free to submit issues or pull requests to improve these configurations.

## License

This project is licensed under the GPL v3 License.