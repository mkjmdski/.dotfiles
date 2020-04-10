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
fi

SPACESHIP_TIME_SHOW="true"
SPACESHIP_BATTERY_THRESHOLD="80"
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_EXIT_CODE_SYMBOL="✘ "

SPACESHIP_GIT_LAST_COMMIT_SHOW="${SPACESHIP_GIT_LAST_COMMIT_SHOW=true}"
SPACESHIP_GIT_LAST_COMMIT_SYMBOL="${SPACESHIP_GIT_LAST_COMMIT_SYMBOL=""}"
SPACESHIP_GIT_LAST_COMMIT_PREFIX="${SPACESHIP_GIT_LAST_COMMIT_PREFIX="("}"
SPACESHIP_GIT_LAST_COMMIT_SUFFIX="${SPACESHIP_GIT_LAST_COMMIT_SUFFIX=") "}"
SPACESHIP_GIT_LAST_COMMIT_COLOR="${SPACESHIP_GIT_LAST_COMMIT_COLOR="magenta"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show git_last_commit status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_git_last_commit() {
  # If SPACESHIP_GIT_LAST_COMMIT_SHOW is false, don't show git_last_commit section
  [[ $SPACESHIP_GIT_LAST_COMMIT_SHOW == false ]] && return

  spaceship::is_git || return

  local 'git_last_commit_status'
  # last commit in all repository
#   git_last_commit_status=$(git log --pretty='format:%s|%cr' "HEAD^..HEAD" 2>/dev/null | head -n 1)
  # last commit in the current direcotry
  git_last_commit_status=$(git show --pretty='format:%s|%cr' $(git rev-list -1 HEAD -- .) 2>/dev/null | head -n 1)

  # Exit section if variable is empty
  [[ -z $git_last_commit_status ]] && return

  # Display git_last_commit section
  spaceship::section \
    "$SPACESHIP_GIT_LAST_COMMIT_COLOR" \
    "$SPACESHIP_GIT_LAST_COMMIT_PREFIX" \
    "$SPACESHIP_GIT_LAST_COMMIT_SYMBOL$git_last_commit_status" \
    "$SPACESHIP_GIT_LAST_COMMIT_SUFFIX"

}

#
# Google Cloud Platform (gcloud)
#
# gcloud is a tool that provides the primary command-line interface to Google Cloud Platform.
# Link: https://cloud.google.com/sdk/gcloud/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GCLOUD_SHOW="${SPACESHIP_GCLOUD_SHOW=true}"
SPACESHIP_GCLOUD_PREFIX="${SPACESHIP_GCLOUD_PREFIX="using "}"
SPACESHIP_GCLOUD_SUFFIX="${SPACESHIP_GCLOUD_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_GCLOUD_SYMBOL="${SPACESHIP_GCLOUD_SYMBOL="☁️"}"
SPACESHIP_GCLOUD_COLOR="${SPACESHIP_GCLOUD_COLOR="26"}"


# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Shows active gcloud configuration.
spaceship_gcloud() {
  [[ $SPACESHIP_GCLOUD_SHOW == false ]] && return

  # Check if the glcoud-cli is installed
  spaceship::exists gcloud || return

  # Check if there is an active config
  [[ -f ~/.config/gcloud/active_config ]] || return

  # Reads the current config from the file
  local GCLOUD_CONFIG=${$(head -n1 ~/.config/gcloud/active_config)}
  # Get active project
  local GCLOUD_ACTIVE_PROJECT=$(cat ~/.config/gcloud/configurations/config_$GCLOUD_CONFIG | grep project | cut -d '=' -f 2)
  [[ -z $GCLOUD_ACTIVE_PROJECT ]] && return
  spaceship::section \
    "$SPACESHIP_GCLOUD_COLOR" \
    "$SPACESHIP_GCLOUD_PREFIX" \
    "${SPACESHIP_GCLOUD_SYMBOL}$GCLOUD_ACTIVE_PROJECT " \
    "$SPACESHIP_GCLOUD_SUFFIX"
}
SPACESHIP_KUBECTL_SHOW='true'
SPACESHIP_PROMPT_ORDER=(time user dir host git git_last_commit golang docker venv gcloud kubectl exec_time line_sep battery vi_mode jobs exit_code char)


source ~/.zplug/init.zsh
zplug load


if [[ $commands[colorls] ]]; then
    alias ls="colorls --almost-all --git-status --group-directories-first"
    alias l="ls -l"
    alias ldir="l --dirs"
    alias lf="l --files"
    alias cls="/bin/ls"
fi

## thefuck
if [[ $commands[thefuck] ]]; then
    eval $(thefuck --alias)
    alias f="fuck --yes"
fi

if [[ $commands[jq] ]]; then
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
fi

alias history="fc -li 1"
alias hp="history | peco"
alias minify-json="jq -Mrc . <"

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

alias git-cd='cd $(git rev-parse --show-toplevel)'

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

# autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C ~/bin/tfschema tfschema
tf_ver="/home/mlodzikos/.tfenv/version"
if [ -f "$tf_ver" ]; then
    tf_ver="${HOME}/.tfenv/versions/$(cat $tf_ver)/terraform"
    complete -o nospace -C $tf_ver terraform
fi
