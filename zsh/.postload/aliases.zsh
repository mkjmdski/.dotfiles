#!/bin/zsh

if [[ $commands[colorls] ]]; then
    alias ls="colorls"
    alias l="ls -lA"
    unalias la ll lsa
fi

## tree
if [[ $commands[alder] ]]; then
    alias tree="alder"
fi
alias t="tree"


## thefuck
if [[ $commands[thefuck] ]]; then
    eval $(thefuck --alias)
    alias f="fuck --yes"
fi

## git
alias gcd="cd-gitroot"
alias g="git"

## use man with most
alias man="PAGER=most man"