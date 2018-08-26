#!/usr/bin/env zsh
# this allows zplug to update itself on `zplug update`
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
function _install_ranger_deps {
    brew install highlight w3m
}

function _history_substring_search_bindings {
    bindkey '^[OA' history-substring-search-up
    bindkey '^[OB' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
}

#### AUTOCOMPLETIONS
function _gopass_autocomplete_load {
    source <(gopass completion zsh | tail -n +2 | sed \$d)
    compdef _gopass gopass
}

#### OH-MY-ZSH
HIST_STAMPS="dd.mm.yyyy"
omz_lib="clipboard,compfix,completion,correction,directories,functions,history,termsupport,theme-and-appearance"
zplug "robbyrussell/oh-my-zsh", use:"lib/{$omz_lib}.zsh"
zplug "plugins/extract", from:oh-my-zsh

#### ZSH MAGIC
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3, hook-load:"_history_substring_search_bindings"
zplug "plugins/colored-man-pages", from:oh-my-zsh

#### VIMODE FOR TYPING COMMANDS IN ZSH
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "b4b4r07/zsh-vimode-visual", defer:3

#### PARSING OUTPUTS
zplug "stedolan/jq", from:gh-r, as:command
zplug "peco/peco", from:gh-r, as:command

#### INTELIGENT PATH CHANGING
zplug "wting/autojump", as:command, hook-build:"_autojump_install 2> /dev/tty"

#### PASSWORD MANAGING IN GOPASS
zplug "gopasspw/gopass", from:gh-r, use:"$(_gopass_release)", as:command, hook-load:"_gopass_autocomplete_load 2> /dev/tty"

#### VIM LIKE FILE MANAGER
zplug "ranger/ranger", use:ranger.py, rename-to:ranger, as:command, hook-build:"_install_ranger_deps &> /dev/tty"

#### DIFF TOOL FOR GIT
zplug "jeffkaufman/icdiff", use:icdiff.py, rename-to:icdiff, as:command

#### AUTOCOMPLETIONS FROM ZSH
for plugin in docker-compose; do
    zplug "plugins/$plugin", from:oh-my-zsh, if:"(( $+commands[$plugin]))"
done

#### THEMES
if [ ! -z "$ZSH_THEME" ]; then
    zplug "$ZSH_THEME", as:theme, if:'[ ! -z "$ZSH_THEME" ]'
else
    zplug "denysdovhan/spaceship-prompt", as:theme, if:'[ -z "$ZSH_THEME" ]'
fi

#### OSX PLUGINS
if [ "$(uname)" = "Darwin" ]; then
    zplug "tysonwolker/iterm-tab-colors"
fi

#### CUSTOM PLUGINS
#### lib/plugins.sh
_install_custom_plugin "ag" "brew install the_silver_searcher"
_install_custom_plugin "glances" "curl -L https://bit.ly/glances | /bin/bash"
_install_custom_plugin "colorls" "sudo gem install colorls"
