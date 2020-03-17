#!/usr/bin/env zsh
# this allows zplug to update itself on `zplug update`
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "robbyrussell/oh-my-zsh", use:"lib/{clipboard,completion,directories,history,termsupport,key-bindings}.zsh"
zplug "plugins/extract", from:oh-my-zsh

#### ZSH MAGIC
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

zplug "peterhurford/git-it-on.zsh"
#### AUTOCOMPLETIONS FROM ZSH
for plugin in docker docker-compose docker-machine; do
    zplug "plugins/$plugin", from:oh-my-zsh
done

zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

zplug "MichaelAquilina/zsh-auto-notify"
AUTO_NOTIFY_IGNORE+=("vim" "cat")
zplug "zpm-zsh/ssh"

return 0 # in case zplug adds plugs ignore them
