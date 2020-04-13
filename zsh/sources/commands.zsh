if [[ $commands[jira] ]]; then
    eval "$(jira --completion-script-zsh)"
fi

if [[ $commands[kubectl] ]]; then
    alias kubectl="export SPACESHIP_KUBECTL_SHOW='true'; $(which kubectl)"
    alias ke="k exec"
    alias ket="ke -it"
    alias kgpf="kgp -o name | head -n 1"
    function ketf {
        ket $(kgpf) -- "${1-sh}"
    }
fi

if [[ $commands[colorls] ]]; then
    alias ls="colorls --almost-all --git-status --group-directories-first"
    alias l="ls -l"
    alias ldir="l --dirs"
    alias lf="l --files"
    alias cls="/bin/ls"
fi

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

if [[ $commands[eyaml] ]]; then
    alias eyaml="EDITOR='code --wait' eyaml"
fi

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

if [[ $commands[trash] ]]; then
    alias rm=trash
    alias "rm-ls"=trash-list
    alias "rm-undo"=trash-restore
    alias "rm-empty"=trash-empty
    alias crm="/bin/rm"
fi


if [[ $commands[gopass] ]]; then
    function gopass-clipboard {
        clipcopy <<< $(gopass show $1 | head -n 1)
    }
fi

if [[ $commands[yq] ]]; then
    function bump-yaml-version {
        local file="${1}"
        local address=".${2}[\"version\"]"
        local position="${3-3}"
        local actual_version=$(yq -r "${address}" "${file}")
        local new_version=$(increment_version "${actual_version}" "${position}")
        yq --yaml-roundtrip --in-place "${address}=${new_version}" "${file}"
    }
fi

if [[ $commands[fpp] ]]; then
    alias fpp="EDITOR='code --wait' fpp"
fi

if [[ $commands[tfschema] ]]; then
    complete -o nospace -C ~/bin/tfschema tfschema
fi

if [[ $commands[tfenv] ]]; then
    tf_ver="/home/mlodzikos/.tfenv/version"
    if [ -f "$tf_ver" ]; then
        tf_ver="${HOME}/.tfenv/versions/$(cat $tf_ver)/terraform"
        complete -o nospace -C $tf_ver terraform
    fi
elif [[ $commands[terraform] ]]; then
    complete -o nospace -C $(which terraform) terraform
fi

if [[ $commands[histdb] ]]; then
    alias history="histdb"
fi

if [[ $commands[pydf] ]]; then
    alias df="pydf"
fi

if [[ $commands[apt-get] ]]; then
    alias apt-get="sudo apt-get"
fi

function newest {
    /bin/ls -Art $1* | tail -n 1
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

alias git-cd='cd $(git root)'
alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
