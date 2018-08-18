#### ZPLUG LOAD
# Check if zplug is installed
[[ ! -d ~/.zplug ]] && git clone https://github.com/zplug/zplug ~/.zplug
export DOTFILES="$HOME/.dotfiles"
export ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
ZSH_CUSTOM_THEME="denysdovhan/spaceship-prompt"
# ZSH_THEME="dracula/zsh"
source ~/.zplug/init.zsh
zplug check || zplug install
zplug load

#### CUSTOM INSTALLS OUTSIDE OF PLUGINS
[[ ! $commands[glances] ]] && pip3 install netifaces py-cpuinfo glances

# [[ $commands[aws] ]] && {
#     aws_location="$(which aws)"
#     [[ -h $aws_location ]] && aws_location=$(readlink $aws_location)
#     source "$(dirname $aws_location)/aws_zsh_completer.sh"
# }

#### $PATH
# Add go binaries
if [ -d "$GOPATH" ]; then
    export PATH="$GOPATH/bin:$PATH"
elif [[ $commands[go] ]]; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# Add yarn global binaries
[[ $commands[yarn] ]] && export PATH="$(yarn global bin):$PATH"

# Add custom bin files
for bin_path in "$HOME/bin" "$HOME/.local/bin/"; do
  [ -d "$bin_path" ] && export PATH="$bin_path:$PATH"
done

#### ADDITIONAL KEY BINDINGS
[ "$(uname)" = "Darwin" ] && {
    bindkey "^[^[[C" forward-word
    bindkey "^[^[[D" backward-word
    bindkey "^[[H" beginning-of-line
    bindkey "^[[F" end-of-line
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