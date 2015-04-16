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

# git prompt preparations
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git cvs svn
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
    modified=$(git status -s | egrep '^ M')
    newfile=$(git status -s | grep '^??')
    deleted=$(git status -s | grep '^D ')

    if [[ -n ${modified} || -n ${newfile} || -n ${deleted} ]]; then
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
        test -z "$(git --git-dir=$p/.git --work-tree=$p diff-index --name-only HEAD -- 2> /dev/null)" || echo $(basename $p)
    done
}

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

# CVS
export CVS_RSH=ssh

#ack
export ACK_PAGER='less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
alias ack='ack --color-match=yellow'

source ~/.zshrc_local

alias normal='xrandr --output LVDS --auto --pos 0x0 --output VGA-0 --auto --right-of LVDS
'
alias mirror='xrandr --fb 1280x1024 --output VGA-0 --mode 1280x1024 --pos 0x0'
