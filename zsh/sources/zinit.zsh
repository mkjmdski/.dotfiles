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
zinit load junegunn/fzf-bin

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

    zinit ice from"gh-r" as"program" bpick"*.deb" pick"usr/bin/interactive-rebase-tool"
    zinit load MitMaro/git-interactive-rebase-tool
fi

if [ "$(uname | tolower)" = "darwin" ]; then
    zinit ice from"gh-r" as"program" mv"macos-interactive-rebase-tool -> interactive-rebase-tool" bpick"macos-interactive-rebase-tool"
    zinit load MitMaro/git-interactive-rebase-tool
fi

zinit ice from"gh-r" as"program" mv"docker* -> docker-compose"
zinit load docker/compose

function helm-plugins-install() {
    if ! helm plugin list | grep -q diff; then
        helm plugin install https://github.com/databus23/helm-diff --version master
    fi
    if ! helm plugin list | grep -vq diff; then
        helm plugin install https://github.com/futuresimple/helm-secrets
    fi
    if ! helm plugin list | grep -q gcs; then
        helm plugin install https://github.com/hayorov/helm-gcs
    fi
}

zinit id-as=helm as='monitor|program' extract \
    dlink="https://get.helm.sh/helm-%VERSION%-$(uname | tolower)-amd64.tar.gz" \
    pick"$(uname | tolower)-amd64/helm" \
    atload"helm-plugins-install" \
    is-snippet for https://github.com/helm/helm/releases/

zplugin id-as'sentinel' as'monitor|program' extract \
    dlink0'/sentinel/%VERSION%/' \
    dlink="/sentinel/%VERSION%/sentinel_%VERSION%_$(uname | tolower)_amd64.zip" \
    mv"sentinel* -> sentinel" \
    pick"sentinel/sentinel" for \
        http://releases.hashicorp.com/sentinel/

zinit ice from"gh-r" as"program" mv"helmsman* -> helmsman"
zinit load Praqma/helmsman

function terraformer-install() {
    GO111MODULE=on go mod vendor
    go run build/main.go google
    go run build/main.go cloudflare
    echo 'provider "google" {}' >init.tf
    echo 'provider "cloudflare" {}' >>init.tf
    terraform init
}

zinit ice as"program" atclone"terraformer-install" atpull'%atclone' pick"terraformer-{google,cloudflare}"
zinit load GoogleCloudPlatform/terraformer

zinit ice from"gh-r" as"program" mv"jq* -> jq"
zinit load stedolan/jq

zinit ice from"gh-r" as"program" mv"jiq* -> jiq"
zinit load fiatjaf/jiq

function _ls-aliases() {
    alias ls="colorls --almost-all --git-status --group-directories-first"
    alias l="ls -l"
    alias ldir="l --dirs"
    alias lf="l --files"
    alias cls="/bin/ls"
}

zinit ice gem'!colorls' atload"_ls-aliases" id-as'colorls'
zinit load zdharma/null

function _eyaml-alias() {
    alias eyaml="EDITOR='code --wait' eyaml"
}

zinit ice gem'!hiera-eyaml' atload"ls-aliases" atload'_eyaml-alias' id-as'eyaml'
zinit load zdharma/null

zinit ice from"gh-r" as"program" mv"shfmt* -> shfmt"
zinit load mvdan/sh

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
