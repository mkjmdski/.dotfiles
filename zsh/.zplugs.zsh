#!/usr/bin/env zsh
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

#### OH-MY-ZSH
# The following line sets command execution time stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"
zplug "lib/*", from:oh-my-zsh


#### BINARIES
function _task_install {
    echo "$fg[green]Installing task warrior, please wait, it can take some time ...$reset_color"
    cmake -DCMAKE_BUILD_TYPE=release .
    make
    make install
}
function _exa_release {
    [ "$(uname)" = "Darwin" ] && echo 'macos' || echo 'linux'
}
zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
zplug "AlDanial/cloc", as:command
zplug "peco/peco", as:command, from:gh-r
zplug "mollifier/cd-gitroot", as:command
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/jump", from:oh-my-zsh
zplug "GothenburgBitFactory/taskwarrior", at:2.6.0, hook-build:"_task_install"
zplug "ogham/exa", from:gh-r, as:command, use:"*$(_exa_release)*", hook-load:"_exa_aliases_load"
zplug "gopasspw/gopass", from:gh-r, as:command, hook-load:"_gopass_autocomplete_load"




#### AUTOCOMPLETIONS
# zplug "plugins/docker-machine", from:oh-my-zsh, if:'[[ $commands[docker-machine] ]]'
# zplug "plugins/helm", from:oh-my-zsh, if:'[[ $commands[helm] ]]'
# zplug "plugins/kubectl", from:oh-my-zsh, if:'[[ $commands[kubectl] ]]'
# zplug "plugins/minikube", from:oh-my-zsh, if:'[[ $commands[minikube] ]]'
# zplug "plugins/tmux", from:oh-my-zsh, if:'[[ $commands[tmux] ]]'
# zplug "plugins/yarn", from:oh-my-zsh, if:'[[ $commands[yarn] ]]'
# zplug "plugins/vault", from:oh-my-zsh, if:'[[ $commands[vault] ]]'
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "plugins/docker", from:oh-my-zsh, if:'[[ $commands[docker] ]]'
zplug "plugins/docker-compose", from:oh-my-zsh, if:'[[ $commands[docker-compose] ]]'
zplug "plugins/terraform", from:oh-my-zsh, if:'[[ $commands[terraform] ]]'

#### THEMES
# use custom theme if loading is custom, otherwise use ZSH_THEME
if [ ! -z "$ZSH_CUSTOM_THEME" ]; then
  # https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md
  # https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/API.md
  zplug "denysdovhan/spaceship-prompt", \
    use:spaceship.zsh, from:github, \
    as:theme, if:'[ "$ZSH_CUSTOM_THEME" = "denysdovhan/spaceship-prompt" ]'

  # https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt
  zplug "bhilburn/powerlevel9k", \
    use:powerlevel9k.zsh-theme, if:'[ "$ZSH_CUSTOM_THEME" = "bhilburn/powerlevel9k" ]'
elif [ ! -z "$ZSH_THEME" ]; then
  zplug "$ZSH_THEME", as:theme, if:'[ ! -z "$ZSH_THEME" ]'
fi