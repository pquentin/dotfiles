# Set up the prompt
autoload -Uz promptinit
promptinit
export PROMPT='%~$ '
export RPROMPT='%T'

setopt histignorealldups

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

export EDITOR=vim
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

alias ls='ls --color'

# tarsnap
alias storepass='tarsnap --fsck && cd ~ && tarsnap -d -f passes && tarsnap -c -f passes .local/share/pasaffe/pasaffe.psafe3'
alias getpass='tarsnap --fsck && cd ~ && tarsnap -x -f passes .local/share/pasaffe/pasaffe.psafe3 '

source ~/.zshrc_local
