#!/usr/bin/env zsh
# this allows zplug to update itself on `zplug update`
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "robbyrussell/oh-my-zsh", use:"lib/{clipboard,completion,directories,history,termsupport,key-bindings}.zsh"
zplug "plugins/extract", from:oh-my-zsh

#### ZSH MAGIC
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

#### AUTOCOMPLETIONS FROM ZSH
for plugin in docker docker-compose docker-machine; do
    zplug "plugins/$plugin", from:oh-my-zsh
done

zplug "plugins/vi-mode", from:oh-my-zsh
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
SPACESHIP_TIME_SHOW="true"
SPACESHIP_BATTERY_THRESHOLD="80"
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_EXIT_CODE_SYMBOL="✘ "

return 0 # in case zplug adds plugs ignore them
