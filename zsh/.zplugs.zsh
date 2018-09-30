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
for plugin in docker docker-compose; do
    zplug "plugins/$plugin", from:oh-my-zsh, if:"(( $+commands[$plugin]))"
done

#### THEME
## ZSH_THEME="eendroroy/alien"
if [ ! -z "$ZSH_THEME" ]; then
    zplug "$ZSH_THEME", as:theme, if:'[ ! -z "$ZSH_THEME" ]'

    #### VIMODE FOR TYPING COMMANDS IN ZSH
    zplug "plugins/vi-mode", from:oh-my-zsh
    zplug "b4b4r07/zsh-vimode-visual", defer:3
else
    zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme, hook-load:"_configure_spaceship 2> /dev/tty", if:'[ -z "$ZSH_THEME" ]'
fi

function _configure_spaceship {
    SPACESHIP_TIME_SHOW="true"
    SPACESHIP_BATTERY_THRESHOLD="95"
    spaceship_vi_mode_enable
}

#### LOAD AUTOJUMP
if [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then
    source $HOME/.autojump/etc/profile.d/autojump.sh;
fi

return 0 # in case zplug adds plugs ignore them
