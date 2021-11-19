zinit light zinit-zsh/z-a-as-monitor
zinit light zinit-zsh/z-a-bin-gem-node

for lib in clipboard directories termsupport key-bindings history; do
    zinit snippet OMZ::lib/$lib.zsh
done

for binary in fasd kubectl; do
    if [[ $commands[$binary] ]]; then
        zinit snippet OMZ::plugins/$binary/$binary.plugin.zsh
    fi
done

zinit ice from"gh-r" as"program"
zinit load junegunn/fzf
# zinit light bonnefoa/kubectl-fzf

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}


for plugin in extract command-not-found gpg-agent last-working-dir colored-man-pages copydir zsh-interactive-cd; do
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

zinit ice from"gh-r" as"program" mv"jira* -> jira"
zinit load go-jira/jira

zinit ice from"gh-r" as"program" mv"yaml2json* -> yaml2json"
zinit load wakeful/yaml2json

if uname | grep -iq linux; then
    zinit ice from"gh-r" as"program" bpick"*.deb" pick"usr/bin/interactive-rebase-tool"
    zinit load MitMaro/git-interactive-rebase-tool
fi

if uname | grep -iq darwin; then
    zinit ice from"gh-r" as"program" mv"macos-interactive-rebase-tool -> interactive-rebase-tool" bpick"macos-interactive-rebase-tool"
    zinit load MitMaro/git-interactive-rebase-tool
fi

zinit ice from"gh-r" as"program" mv"jq* -> jq"
zinit load stedolan/jq

function _ls-aliases() {
    alias ls="colorls --almost-all --git-status --group-directories-first"
    alias l="ls -l"
    alias ldir="l --dirs"
    alias lf="l --files"
    alias cls="/bin/ls"
}

zinit ice gem'!colorls' atload"_ls-aliases" id-as'colorls'
zinit load zdharma/null

zinit ice from"gh-r" as"program" mv"peco* -> peco" pick"peco/peco"
zinit load peco/peco

zinit ice from"gh-r" as"program" bpick"*.tar.gz" mv"gopass* -> gopass" pick"gopass/gopass"
zinit load gopasspw/gopass

zinit ice from"gh-r" as"program"
zinit load dduan/tre

zinit ice from"gh-r" as"program" bpick"*.tar.gz" mv"bat* -> bat" pick"bat/bat"
zinit load sharkdp/bat

zinit ice from"gh-r" as"program" bpick"*.tar.gz" mv"fd* -> fd" pick"fd/fd"
zinit load sharkdp/fd

zinit ice from"gh-r" as"program" bpick"*.tar.gz" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit load BurntSushi/ripgrep

zinit ice from"gh-r" as"program" mv"stern* -> stern"
zinit load wercker/stern
