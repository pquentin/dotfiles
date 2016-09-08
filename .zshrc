# Large history
setopt histignorealldups
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
setopt appendhistory  # append to history before closing terminal
setopt extendedhistory # store times in history file
setopt histignorespace  # forget commands starting with space

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt extendedglob notify
unsetopt beep

autoload -Uz compinit
compinit
autoload -U colors && colors

# Use emacs keybindings even if our EDITOR is set to vi
export EDITOR=vim
bindkey -e
# Shift-TAB
bindkey '^[[Z' reverse-menu-complete

# Platform test
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi

if [[ $platform == 'linux' ]]; then
   alias ls='ls --color=auto'
elif [[ $platform == 'darwin' ]]; then
   alias ls='ls -G'
fi

alias grep='grep --color'

# git prompt preparations
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git cvs svn hg bzr
precmd () { dollar="∮"; vcs_info }
setopt prompt_subst
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%b|%a%m'
zstyle ':vcs_info:*' formats       '%b%m'

# http://eseth.org/2010/git-in-zsh.html#hooks
zstyle ':vcs_info:git*+set-message:*' hooks git-status git-ref git-stash

# Show modifications
function +vi-git-status() {
    local changed
    modified=$(git status -s | egrep '^.[^ ]')
    indexed=$(git status -s | grep '^[^ ].')

    if [[ -n ${modified} ]]; then
        dollar="%{$fg[yellow]%}∮%{$reset_color%}"
    elif [[ -n ${indexed} ]]; then
        dollar="%{$fg[green]%}∮%{$reset_color%}"
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
        stashes=$(echo $(git stash list 2>/dev/null | wc -l) | sed 's/ //g')
        hook_com[misc]+="|%{$fg[red]%}${stashes}%{$reset_color%}"
    fi
}

# prompt
PROMPT='%{$fg[cyan]%}%m%{$reset_color%}:%~$dollar '
RPROMPT='${vcs_info_msg_0_} %T'

# Adapted from https://gist.github.com/euphoris/3405460
export PROJECTS_HOME="$HOME/Projects"

function u() {
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        test -z "$(git --git-dir=$p/.git --work-tree=$p status --porcelain 2> /dev/null | grep '^??')" || echo untracked $(basename $p)
    done
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        test -z "$(git --git-dir=$p/.git --work-tree=$p diff-index --name-only HEAD -- 2> /dev/null)" || echo change $(basename $p)
    done
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        test -e "$p/.git/refs/stash" && echo stashed $(basename $p)
    done
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        developed.py $(basename $p) && echo developed in $(basename $p)
    done
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        test -z "$(git --git-dir=$p/.git --work-tree=$p rev-list HEAD@{upstream}..HEAD 2> /dev/null)" || echo commit $(basename $p)
    done
}

function glogday() {
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        git --git-dir=$p/.git --work-tree=$p --no-pager log --date=local --since=$1T00:00:00 --before=$1T23:59:59 --author='Quentin Pradet' 2> /dev/null
    done
}

function glogprecise() {
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        git --git-dir=$p/.git --work-tree=$p --no-pager log --date=local --since=$1 --before=$1 --author='Quentin Pradet' 2> /dev/null
    done
}

function gp() {
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        cd $p; pwd; git branch; git pull --rebase; cd - > /dev/null; echo
    done
}

function checkoutbranch() {
    for p in `find $PROJECTS_HOME -type d -depth 1`; do
        cd $p; pwd; git checkout $1; cd - > /dev/null; echo
    done
}

alias fixvenv3='deactivate; rmvirtualenv $(basename $(pwd)); mkvirtualenv $(basename $(pwd)) && pip install -r requirements-dev.txt || pip install -r requirements.txt'
alias showauthors='git log | grep Author | sort | uniq -c | sort -rn'

function chpwd() {
    emulate -L zsh
    if [[ ${PWD##$PROJECTS_HOME} != $PWD ]]; then
        venvname=$(echo "${PWD##$PROJECTS_HOME}" | cut -d'/' -f2)
        cur_env=$(echo "${VIRTUAL_ENV##$WORKON_HOME}/" | cut -d'/' -f2)
        if [[ $venvname != "" ]] && [[ -d "$WORKON_HOME/$venvname" ]]; then
            if [[ ${cur_env} != $venvname ]]; then
                workon "$venvname"
            fi
        else
            if [[ $VIRTUAL_ENV != "" ]]; then
                deactivate
            fi
        fi
    else
        if [[ $VIRTUAL_ENV != "" ]]; then
            deactivate
        fi
    fi
}

# sudo autocompletion
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# don't eat spaces before pipes when tab-completing
# http://superuser.com/questions/613685/how-stop-zsh-from-eating-space-before-pipe-symbol
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# Report time for longer commands
export REPORTTIME=1 # doesn't count IO, and one second of pure computation is already a lot.

# tarsnap
alias storepass='tarsnap --fsck && cd ~ && tarsnap -d -f passes && tarsnap -c -f passes .local/share/pasaffe/pasaffe.psafe3'
alias getpass='tarsnap --fsck && cd ~ && tarsnap -x -f passes .local/share/pasaffe/pasaffe.psafe3 '
alias storepieces='tarsnap --fsck && cd ~/Documents; tarsnap -d -f pieces && tarsnap -c -f pieces Pièces\ administratives; cd -'
alias getpieces='tarsnap --fsck && cd ~/Documents; tarsnap -x -f pieces; cd -'

# virtualenvwrapper
export WORKON_HOME=~/.virtualenvs

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

# brew
export PATH="/usr/local/sbin:$PATH"

# CVS
export CVS_RSH=ssh

#ack
export ACK_PAGER='less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
alias ack='ack --color-match=yellow'

# Python REPL history
export PYTHONSTARTUP=$HOME/.pythonrc

# pipsi
export PATH=$HOME/.local/bin:$PATH

# dotfiles
export PATH=$PROJECTS_HOME/dotfiles/bin:$PATH

# xrandr for talks
alias normal='xrandr --output LVDS --auto --pos 0x0 --output VGA-0 --auto --right-of LVDS'
alias mirror='xrandr --fb 1280x1024 --output VGA-0 --mode 1280x1024 --pos 0x0'

# In order for gpg to find gpg-agent, gpg-agent must be running, and there must be an env
# variable pointing GPG to the gpg-agent socket. This little script, which must be sourced
# in your shell's init script (ie, .bash_profile, .zshrc, whatever), will either start
# gpg-agent or set up the GPG_AGENT_INFO variable if it's already running.

# Add the following to your shell init to set up gpg-agent automatically for every shell
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi

# iTerm2 shell integration
source ~/.iterm2_shell_integration.zsh

source ~/.zshrc_local
