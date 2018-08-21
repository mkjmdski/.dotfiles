#!/usr/bin/env zsh
#### ZPLUG AUTOUPDATE
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

#### HELPERS
function _exa_release {
    [ "$(uname)" = "Darwin" ] && echo '*macos*' || echo '*linux*'
}
function _gopass_release {
    [ "$(uname)" = "Linux" ] && echo '*linux*amd64*tar.gz' || echo '*darwin*'
}
function _autojump_install {
    ./install.py
}
function _autojump_load {
    [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
    autoload -U compinit && compinit -u
}
function _ssh_connect_load {
    source $ZPLUG_HOME/repos/gko/ssh-connect/ssh-connect.sh
}

#### AUTOCOMPLETIONS
function _gopass_autocomplete_load {
    source <(gopass completion zsh | tail -n +2 | sed \$d)
    compdef _gopass gopass
}

#### ALIASES
function _exa_aliases_load {
    alias l='exa -lah'
    alias ls='exa -G'
    alias ll='exa -lh'
    alias lsa='exa -lah'
    alias la='ls -al'
}
function _oh_my_zsh_aliases {
    alias clc='clipcopy'
    alias clp='clippaste'
}

#### OH-MY-ZSH
# The following line sets command execution time stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"
zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh", hook-load:"_oh_my_zsh_aliases 2> /dev/tty"
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh

#### ZSH Syntax
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

#### Using vim in terminal
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "b4b4r07/zsh-vimode-visual", defer:3

#### BINARIES
zplug "stedolan/jq", from:gh-r, as:command
zplug "AlDanial/cloc", as:command
zplug "peco/peco", as:command, from:gh-r
zplug "gko/ssh-connect", as:command
zplug "ogham/exa", from:gh-r, as:command, use:"$(_exa_release)", hook-load:"_exa_aliases_load 2> /dev/tty"
zplug "gopasspw/gopass", from:gh-r, as:command, use:"$(_gopass_release)", hook-load:"_gopass_autocomplete_load 2> /dev/tty"
zplug "wting/autojump", as:command, hook-build:"_autojump_install 2> /dev/tty"

#### AUTOCOMPLETIONS
zplug "plugins/docker", from:oh-my-zsh, if:'[[ $commands[docker] ]]'
zplug "plugins/docker-compose", from:oh-my-zsh, if:'[[ $commands[docker-compose] ]]'
zplug "plugins/terraform", from:oh-my-zsh, if:'[[ $commands[terraform] ]]'
# zplug "plugins/docker-machine", from:oh-my-zsh, if:'[[ $commands[docker-machine] ]]'
# zplug "plugins/helm", from:oh-my-zsh, if:'[[ $commands[helm] ]]'
# zplug "plugins/kubectl", from:oh-my-zsh, if:'[[ $commands[kubectl] ]]'
# zplug "plugins/minikube", from:oh-my-zsh, if:'[[ $commands[minikube] ]]'
# zplug "plugins/tmux", from:oh-my-zsh, if:'[[ $commands[tmux] ]]'
# zplug "plugins/yarn", from:oh-my-zsh, if:'[[ $commands[yarn] ]]'
# zplug "plugins/vault", from:oh-my-zsh, if:'[[ $commands[vault] ]]'

#### THEMES
# Uncomment this variable to change theme from denysdovhan/spaceship-prompt
# ZSH_THEME="dracula/zsh"
if [ ! -z "$ZSH_THEME" ]; then
    zplug "$ZSH_THEME", as:theme, if:'[ ! -z "$ZSH_THEME" ]'
else
    zplug "denysdovhan/spaceship-prompt", as:theme, if:'[ -z "$ZSH_THEME" ]'
fi


#### OSX PLUGINS
if [ "$(uname)" = "Darwin" ]; then
    zplug "tysonwolker/iterm-tab-colors"
fi
