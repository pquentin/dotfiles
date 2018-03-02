homebrew requirements:

 * tmux
 * vim
 * zsh
 * fzf
 * purs
 * cmake (required by a purs dep)
 * pyenv

Remap Caps Lock to Escape: https://stackoverflow.com/a/40254864

To install purs:

 * Install rustup: https://www.rustup.rs/
 * git clone git@github.com:xcambar/purs.git
 * cd purs
 * rustup override set nightly
 * cargo build --release
 * cp target/release/purs $PROJECTS_HOME/dotfiles/bin/
