#!/bin/zsh

## git
alias s="git s"
alias cdg="cd-gitroot"

## Color ls
if [[ $commands[colorls] ]]; then
    alias ls="colorls"
fi
alias l="ls -lA"
unalias la ll lsa

## tree
if [[ $commands[exa] ]]; then
    alias tree="exa --tree"
fi
alias t="tree"


## cat
if [[ $commands[thefuck] ]]; then
    eval $(thefuck --alias)
fi

## thefuck
if [[ $commands[ccat] ]]; then
    alias cat="ccat --bg='dark'"
fi