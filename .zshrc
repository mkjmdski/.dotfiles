export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory

fpath=($fpath $DOTFILES/zsh/fpath)

if [ ! "$PATH_LOADED" = "true" ]; then
    # We want to extend path once
    export EDITOR="$(which vim)"
    # export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
    export LANG=en_US.UTF-8 # Default language
    export LC_ALL=en_US.UTF-8
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    export PATH="$DOTFILES/bin:$PATH"
    eval "$(goenv init -)"

    export PATH="$GOROOT/bin:$PATH"
    export PATH="$PATH:$GOPATH/bin"

    if [[ $commands[javac] ]]; then
        export JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))"
    fi
    # Add yarn global binaries
    if [[ $commands[yarn] ]]; then export PATH="$(yarn global bin):$PATH"; fi

    # Add ruby gems
    if [[ $commands[ruby] ]]; then export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"; fi

    # Add custom bin files
    if [ -d "$HOME/bin" ]; then export PATH="$HOME/bin:$PATH"; fi
    if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi
    export PATH="$HOME/.tfenv/bin:$PATH"
    export TF_PLUGIN_CACHE_DIR="$HOME/.terraform-plugins"
    export ZPLUG_LOADFILE="$DOTFILES/.zplugs.zsh"
    export PATH_LOADED="true"
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

alias kubectl="export SPACESHIP_KUBECTL_SHOW='true'; $(which kubectl)"
source $DOTFILES/zsh/sources/spaceship.zsh
SPACESHIP_PROMPT_ORDER=(time user dir host git git_last_commit golang docker venv gcloud kubectl exec_time line_sep battery vi_mode jobs exit_code char)

compinit
source ~/.zplug/init.zsh
zplug load

source $DOTFILES/zsh/sources/git-extra-completions.zsh
source $DOTFILES/zsh/sources/bash-completions.bash

eval "$(jira --completion-script-zsh)"

if [[ $commands[colorls] ]]; then
    alias ls="colorls --almost-all --git-status --group-directories-first"
    alias l="ls -l"
    alias ldir="l --dirs"
    alias lf="l --files"
    alias cls="/bin/ls"
fi

## thefuck
# if [[ $commands[thefuck] ]]; then
#     eval $(thefuck --alias)
#     alias f="fuck --yes"
# fi

if [[ $commands[jq] ]]; then
    alias json-minify="$(which jq) -Mrc . <"
    alias jq="jq -C"
fi

if [[ $commands[nvim] ]]; then
    alias vim="nvim"
    alias vi="nvim"
fi

if [[ $commands[bat] ]]; then
    alias cat="PAGER=less bat -p"
fi

alias eyaml="EDITOR='code --wait' eyaml"

if [[ $commands[docker] ]]; then
    alias dcc="docker-compose"
fi

if [[ $commands[gcloud] ]]; then
    alias gcl="gcloud config configurations list"
    function gca {
        gcloud config configurations activate $(gcl | grep $1 | awk '{print $1}')
    }
    alias gcloud="export SPACESHIP_GCLOUD_SHOW='true'; $(which gcloud)"
fi

alias history="fc -li 1"

alias ke="k exec"
alias ket="ke -it"
function kgpf {
    kgp -n $1 -o name | head -n 1
}
function ketf {
    ket -n $1 $(kgpf $1) -- "${2-sh}"
}

if [[ $commands[trash] ]]; then
    alias rm=trash
    alias "rm-ls"=trash-list
    alias "rm-undo"=trash-restore
    alias "rm-empty"=trash-empty
    alias crm="/bin/rm"
fi

alias git-cd='cd $(git root)'

function newest {
    cls -Art $1* | tail -n 1
}

function gopass-clipboard {
    clipcopy <<< $(gopass show $1 | head -n 1)
}

function take {
  mkdir -p $@ && cd ${@:$#}
}

function swap {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function trail {
    grep "\S" | awk '{$1=$1};1'
}

function to-single-quote {
    sed "s/\"/'/g"
}

function to-double-quote {
    sed "s/'/\"/g"
}

function bump-yaml-version {
    local file="${1}"
    local address=".${2}[\"version\"]"
    local position="${3-3}"
    local actual_version=$(yq -r "${address}" "${file}")
    local new_version=$(increment_version "${actual_version}" "${position}")
    yq --yaml-roundtrip --in-place "${address}=${new_version}" "${file}"
}

alias fpp="EDITOR='code --wait' fpp"
alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
# auto menu complete
setopt auto_menu

# auto change directory
setopt auto_cd

#### HISTORY SEARCH
autoload history-search-end
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=cyan,fg=white,bold"
HIST_STAMPS="dd.mm.yyyy" ## OH-MY-ZSH
setopt append_history share_history histignorealldups
# use brace
setopt brace_ccl

# compacked complete list display
setopt list_packed

# multi redirect (e.x. echo "hello" > hoge1.txt > hoge2.txt)
setopt multios

setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks

complete -o nospace -C ~/bin/tfschema tfschema
tf_ver="/home/mlodzikos/.tfenv/version"
if [ -f "$tf_ver" ]; then
    tf_ver="${HOME}/.tfenv/versions/$(cat $tf_ver)/terraform"
    complete -o nospace -C $tf_ver terraform
fi

# let the cow say something smart
# quote | cowsay | lolcat
