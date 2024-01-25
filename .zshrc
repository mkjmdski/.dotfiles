export DOTFILES="$HOME/.dotfiles"
sources="$DOTFILES/zsh/sources"

source $sources/path.zsh
source $sources/spaceship.zsh

source ~/.zinit/bin/zinit.zsh

while read -r file; do
  . $file
done< <(find $DOTFILES/zsh/bash -type f)

# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

source $sources/zinit.zsh
source $sources/commands.zsh

if [[ -f "$HOME/repos/agmar/toolkitz/programs/.rc" ]]; then
    source "$HOME/repos/agmar/toolkitz/programs/.rc"
fi

# auto change directory
setopt auto_cd
# use brace
setopt brace_ccl
# compacked complete list display
setopt list_packed

setopt auto_remove_slash

# resolve symlinks
setopt chase_links

autoload -U add-zsh-hook

# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"

#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(/bin/cat "${nvmrc_path}")")

#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }

# what to do when change location
standard-chpwd() {
    if [ -d ".git" ] || [ -f ".git" ]; then
        if [ ! -f ".git/index.lock" ]; then
            git pull &
        fi
    fi
    if [ -d "venv" ] && [ -z "$VIRTUAL_ENV" ]; then
        source venv/bin/activate
    fi
    if [ -f "ansible-vault.txt" ]; then
      export ANSIBLE_VAULT_PASSWORD_FILE="$PWD/ansible-vault.txt"
    fi
}

if [[ $commands[nvm] ]]; then
  add-zsh-hook chpwd load-nvmrc
fi

add-zsh-hook chpwd standard-chpwd
# load-nvmrc
