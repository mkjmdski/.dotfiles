#### EXPORTS
function _get_editor { echo $(which vim) || echo $(which vi) }
export EDITOR="$(_get_editor)"
export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
export LANG=en_US.UTF-8 # Default language

# Uncomment this export line to change theme from denysdovhan/spaceship-prompt
# export ZSH_THEME="dracula/zsh"

#### ZPLUG LOAD
export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory
# Install zplug if not installed
[[ ! -d ~/.zplug ]] && git clone --depth=1 https://github.com/zplug/zplug ~/.zplug
# Show where are located plugins definitions
ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
source ~/.zplug/init.zsh
if ! zplug check --verbose; then
    printf "Install? [y/N]: " # Prompt about installing plugins
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

#### LOADING PLUGINS FROM ZPLUG WHICH DON'T WORK ON HOOKS
_autojump_load

#### AUTOCOMPLETIONS
# [[ $commands[aws] ]] && {
#     aws_location="$(which aws)"
#     [[ -h $aws_location ]] && aws_location=$(readlink $aws_location)
#     source "$(dirname $aws_location)/aws_zsh_completer.sh"
# }

#### $PATH
# Add go binaries
if [ -d "$GOPATH" ]; then export PATH="$GOPATH/bin:$PATH"
elif [[ $commands[go] ]]; then export PATH="$(go env GOPATH)/bin:$PATH"
fi
# Add yarn global binaries
if [[ $commands[yarn] ]]; then export PATH="$(yarn global bin):$PATH"; fi
# Add custom bin files
if [ -d "$HOME/bin" ]; then export PATH="$HOME/bin:$PATH"; fi
if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi


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

#### FUNCTIONS

function cd-gitroot {
    local root
    root=$(git rev-parse --show-toplevel)
    root
}

function gopass-clipboard {
    local secret
    secret=$(gopass show $1 | head -n 1)
    clc <<< $secret
}

#### ALIASES

## GIT
alias s="git s"
alias cdg="cd-gitroot"
