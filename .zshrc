export DOTFILES="$HOME/.dotfiles"
sources="$DOTFILES/zsh/sources"

source $sources/path.zsh
source $sources/spaceship.zsh

source ~/.zinit/bin/zinit.zsh
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

for lib in clipboard directories termsupport key-bindings history; do
    zinit snippet OMZ::lib/$lib.zsh
done

for binary in fasd kubectl; do
    if [[ $commands[$binary] ]]; then
        zinit snippet OMZ::plugins/$binary/$binary.plugin.zsh
    fi
done

for plugin in extract command-not-found git-auto-fetch gpg-agent last-working-dir colored-man-pages copydir gcloud
do
    zinit snippet OMZ::plugins/$plugin/$plugin.plugin.zsh
done
GIT_AUTO_FETCH_INTERVAL=1800
HIST_STAMPS="yyyy-mm-dd"

zinit ice as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX"
zinit light tj/git-extras

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light zdharma/history-search-multi-word
zinit light zsh-users/zsh-history-substring-search

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=cyan,fg=white,bold"
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

zinit light peterhurford/git-it-on.zsh

zinit light denysdovhan/spaceship-prompt

zinit light MichaelAquilina/zsh-you-should-use
YSU_HARDCORE=1

zinit light hlissner/zsh-autopair

zinit light Tarrasch/zsh-bd
zinit light brymck/print-alias

zinit ice wait'1' lucid
zinit light laggardkernel/zsh-thefuck

zinit ice as"program" pick"git-hooks"
zinit load icefox/git-hooks

zinit ice from"gh-r" as"program" mv"jira* -> jira"
zinit load go-jira/jira

zinit ice from"gh-r" as"program" mv"yaml2json* -> yaml2json"
zinit load wakeful/yaml2json

if [ "$(uname | tolower)" = "linux" ]; then
    zinit ice from"gh-r" as"program" pick"build/x86_64-linux/broot"
    zinit load Canop/broot
    br_program="$HOME/.config/broot/launcher/bash/br"
    if [ ! "-f" "${br_program}" ]; then
        broot --install
    else
        source $br_program
    fi
fi

if [ "$(uname | tolower)" = "darwin" ]; then
    zinit ice from"gh-r" as"program" mv"macos-interactive-rebase-tool -> git-interactive-rebase-tool" bpick"macos-interactive-rebase-tool"
    zinit load MitMaro/git-interactive-rebase-tool
fi

source $sources/bash-completions.bash
source $sources/commands.zsh

# auto change directory
setopt auto_cd
# use brace
setopt brace_ccl
# compacked complete list display
setopt list_packed

setopt auto_remove_slash

# resolve symlinks
setopt chase_links