homebrew requirements:

 * tmux
 * vim (Then install vim-plug then run :PlugInstall)
 * zsh
 * fzf (Then /usr/local/opt/fzf/install --no-bash --key-bindings --completion --no-update-rc)
 * purs (see below)
 * pyenv
 * gpg
 * git
 * ripgrep
 * jq
 * httpie
 * moreutils (for sponge)

Casks:

 * firefox
 * amethyst
 * slack
 * gpg-suite (for pinentry which handles my GPG passphrase)
 * docker
 * skype

Remap Caps Lock to Escape: https://stackoverflow.com/a/40254864

To install purs:

 * Install rustup: https://www.rustup.rs/
 * Installe cmake via homebrew (required by a purs dep)
 * git clone git@github.com:pquentin/purs.git
 * cd purs
 * cargo build --release
 * cp target/release/purs $PROJECTS_HOME/dotfiles/bin/
