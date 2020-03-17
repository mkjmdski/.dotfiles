#!/bin/zsh

if [[ $commands[colorls] ]]; then
    alias ls="colorls"
    alias l="ls -lA"
fi

## thefuck
if [[ $commands[thefuck] ]]; then
    eval $(thefuck --alias)
    alias f="fuck --yes"
fi

if [[ $commands[jq] ]]; then
    alias jq="jq -C"
fi

if [[ $commands[nvim] ]]; then
    alias vim="nvim"
    alias vi="nvim"
fi

if [[ $commands[bat] ]]; then
    alias cat="PAGER=less bat -p"
fi

## git
alias cls="/bin/ls"
alias crm="/bin/rm"
alias dc="docker"
alias dcc="docker-compose"

alias hp="history | peco"
alias history="fc -li 1"
hpc () {
    history | peco --query="$@"
}

alias rm=trash
alias rmls=trash-list
alias unrm=trash-restore
alias rmrf=trash-empty

function git-cd {
    local root
    root=$(git rev-parse --show-toplevel)
    eval $root
}

function gopass-clipboard {
    local secret
    secret=$(gopass show $1 | head -n 1)
    clipcopy <<< $secret
}

function take {
  mkdir -p $@ && cd ${@:$#}
}

function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

if [ -d "${HOME}/google-cloud-sdk" ]; then
    . $HOME/google-cloud-sdk/completion.zsh.inc
    . $HOME/google-cloud-sdk/path.zsh.inc
elif [ -d "/opt/google-cloud-sdk" ]; then
    . /opt/google-cloud-sdk/completion.zsh.inc
    . /opt/google-cloud-sdk/path.zsh.inc
fi

#### LOAD AUTOJUMP
if [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then
    source $HOME/.autojump/etc/profile.d/autojump.sh;
fi
if [[ -f /usr/share/autojump/autojump.sh ]]; then
    . /usr/share/autojump/autojump.sh
fi
if [[ -f  /etc/profile.d/autojump.zsh ]]; then
    source /etc/profile.d/autojump.zsh
fi
if [[ -f /usr/local/share/autojump/autojump.zsh ]]; then
    source /usr/local/share/autojump/autojump.zsh
fi

if [[ ! -d  "$HOME/.terraform-plugins" ]]
then
mkdir  "$HOME/.terraform-plugins"
fi