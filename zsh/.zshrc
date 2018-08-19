#### ZPLUG LOAD
# Check if zplug is installed
[[ ! -d ~/.zplug ]] && git clone https://github.com/zplug/zplug ~/.zplug
export DOTFILES="$HOME/.dotfiles"
export ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"

# Change this variable to change theme from denysdovhan/spaceship-prompt
# ZSH_THEME="dracula/zsh"

source ~/.zplug/init.zsh
zplug check || zplug install
zplug load

#### CUSTOM INSTALLS OUTSIDE OF PLUGINS
[[ ! $commands[glances] ]] && pip3 install netifaces py-cpuinfo glances

#### AUTOCOMPLETIONS
# [[ $commands[aws] ]] && {
#     aws_location="$(which aws)"
#     [[ -h $aws_location ]] && aws_location=$(readlink $aws_location)
#     source "$(dirname $aws_location)/aws_zsh_completer.sh"
# }

#### $PATH
# Add go binaries
[ -d "$GOPATH" ] && export PATH="$GOPATH/bin:$PATH" || [[ $commands[go] ]] && export PATH="$(go env GOPATH)/bin:$PATH"

# Add yarn global binaries
[[ $commands[yarn] ]] && export PATH="$(yarn global bin):$PATH"

# Add custom bin files
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

#### ADDITIONAL KEY BINDINGS
[ "$(uname)" = "Darwin" ] && {
    bindkey "^[^[[C" forward-word # alt + right arrow
    bindkey "^[^[[D" backward-word # alt + left arrow
    bindkey "^[[5~" end-of-line # fn + up arrow
    bindkey "^[[6~" beginning-of-line # fn + down arrow
    bindkey "^[OH" backward-kill-word # fn + left arrow
    bindkey "^[OF" kill-word # fn + right arrow
}

#### Use actual tty when prompting for GPG stuff
export GPG_TTY=$(tty)

#### Default language
export LANG=en_US.UTF-8

#### Node Virtual Machine Config
# export NVM_DIR="$HOME/.nvm"
# [ -d "$NVM_DIR" ] && {
#   \. "$NVM_DIR/nvm.sh"  # This loads nvm
#   \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# }

#### Google SDK
# [ -d "$HOME/google-cloud-sdk" ] && {
#     source "$HOME/google-cloud-sdk/path.zsh.inc"
#     source "$HOME/google-cloud-sdk/completion.zsh.inc"
# }