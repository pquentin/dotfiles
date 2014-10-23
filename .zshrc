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

# git prompt preparations
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git cvs svn
precmd () { dollar="∮"; vcs_info }
setopt prompt_subst
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%c %b|%a%m'
zstyle ':vcs_info:*' formats       '%c %b%m'

# http://eseth.org/2010/git-in-zsh.html#hooks
zstyle ':vcs_info:git*+set-message:*' hooks git-status git-ref git-stash

# Show modifications
function +vi-git-status() {
    local changed
    changed=$(git status -s | grep '^ M')

    if [[ -n ${changed} ]]; then
        dollar="%{$fg[yellow]%}∮%{$reset_color%}"
    else
        dollar="∮"
    fi
}

# Show remote ref name
function +vi-git-ref() {
    local remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        hook_com[branch]="%{$fg[blue]%}${remote}%{$reset_color%}"
    else
        hook_com[branch]="%{$fg[blue]%}${hook_com[branch]}%{$reset_color%}"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s $(git rev-parse --git-dir)/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+="|%{$fg[red]%}${stashes}%{$reset_color%}"
    fi
}

# prompt
PROMPT='%{$fg[cyan]%}%m%{$reset_color%}:%~$dollar '
RPROMPT='${vcs_info_msg_0_} %T'

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

#ack
export ACK_PAGER='less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
alias ack='ack --color-match=yellow'

source ~/.zshrc_local
