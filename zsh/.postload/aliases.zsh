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
alias gcd="cd-gitroot"

alias cls="/bin/ls"

alias dc="docker"
alias dcc="docker-compose"

alias hp="history | peco"

hpc () {
    history | peco --query="$@"
}
