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


## thefuck
if [[ $commands[thefuck] ]]; then
    eval $(thefuck --alias)
    alias f="fuck --yes"
fi

## cat
if [[ $commands[ccat] ]]; then
    alias cat="ccat --bg='dark'"
fi

## git
alias pull="git pull"
alias checkout="git checkout"
alias push="git push"
alias merge="git merge"
alias describe="git describe"
alias mark="git mark"