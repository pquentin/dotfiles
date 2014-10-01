# Large history
setopt histignorealldups
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt appendhistory

setopt extendedglob notify
unsetopt beep

autoload -Uz compinit
compinit
autoload -U colors && colors

# Use emacs keybindings even if our EDITOR is set to vi
export EDITOR=vim
bindkey -e

alias ls='ls --color'

# Prompt
autoload -Uz promptinit
promptinit
PROMPT="%{$fg[cyan]%}%m%{$reset_color%}:%~∮ "
RPROMPT='%T'

# sudo autocompletion
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Report time for longer commands
export REPORTTIME=1 # doesn't count IO, and one second of pure computation is already a lot.

# tarsnap
alias storepass='tarsnap --fsck && cd ~ && tarsnap -d -f passes && tarsnap -c -f passes .local/share/pasaffe/pasaffe.psafe3'
alias getpass='tarsnap --fsck && cd ~ && tarsnap -x -f passes .local/share/pasaffe/pasaffe.psafe3 '

# virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
export PIP_DOWNLOAD_CACHE=~/.pip/cache

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

# CVS
export CVS_RSH=ssh

source ~/.zshrc_local
