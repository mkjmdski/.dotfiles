#!/usr/bin/env zsh
# this allows zplug to update itself on `zplug update`
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "robbyrussell/oh-my-zsh", use:"lib/{clipboard,completion,directories,history,termsupport,key-bindings}.zsh"

#### ZSH MAGIC
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

zplug "peterhurford/git-it-on.zsh"

for plugin in docker docker-compose docker-machine autojump extract command-not-found emoji fd gcloud doctl git-auto-fetch gpg-agent helm kubectl ubuntu web-search
do
    zplug "plugins/$plugin", from:oh-my-zsh
done
export GIT_AUTO_FETCH_INTERVAL=300
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

zplug "MichaelAquilina/zsh-auto-notify"
AUTO_NOTIFY_IGNORE+=("vim" "cat")

zplug "MichaelAquilina/zsh-you-should-use"
export YSU_HARDCORE=1

zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
export AUTOSWITCH_VIRTUAL_ENV_DIR="venv"

# Gist Commands
zplug "MichaelAquilina/git-commands", \
    as:command, \
    use:git-clean-branches

return 0 # in case zplug adds plugs ignore them
