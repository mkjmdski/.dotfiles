alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tf-docs='docker run --rm -it -v $(pwd):/workspace gcr.io/cloud-foundation-cicd/cft/developer-tools:0.13 /bin/bash -c "source /usr/local/bin/task_helper_functions.sh && generate_docs"'

if [[ $commands[kubectl] ]]; then
    if [[ $commands[kubecolor] ]]; then
        alias kubectl=kubecolor
        alias k=kubecolor
    fi
    alias ke="k exec"
    alias ket="ke -it"
    alias kgpf="kgp -o name | head -n 1"
    alias ketf='ket $(kgpf) -- /bin/sh'
    alias kg='k get'
    alias kgj='kg job'
    alias kns='command kubectl ns'
    alias kctx='command kubectl ctx'
    alias kd='k describe'
    # completion for kubecolor instead of kubectl

# dynamically switch cluster / namespace
knss() {
    k ns $(kns | grep $1 | head -n 1)
}

kctxx() {
    k ctx $(kctx | grep $1 | head -n 1)
}

ap() {
    if [ -z "$ANSIBLE_USER" ]; then
        ANSIBLE_USER=miko
    fi
    /usr/bin/env ansible-playbook --user $ANSIBLE_USER "$@" | sed 's/\\n/\n/g'
}

ap-check() {
    ap --check --diff "$@"
}
    source <(kubectl completion zsh)
    source <(kubectl completion zsh | sed 's|kubectl|kubecolor|g')
fi

if [[ $commands[jq] ]]; then
    alias json-minify="jq -Mrc . <"
fi

if [[ $commands[nvim] ]]; then
    alias vim="nvim"
    alias vi="nvim"
fi

if [[ $commands[bat] ]]; then
    alias cat="PAGER=less bat -p"
fi

if [[ $commands[trash] ]]; then
    alias rm=trash
    alias "rm-ls"=trash-list
    alias "rm-undo"=trash-restore
    alias "rm-empty"=trash-empty
    alias crm="/bin/rm"
fi

if [[ $commands[tfenv] ]]; then
    tfenv_root=$(echo $(which tfenv) | rev | cut -d/ -f 3- | rev)
    tf_ver="${tfenv_root}/version"
    if [ -f "$tf_ver" ]; then
        tf_ver="${tfenv_root}/versions/$(cat $tf_ver)/terraform"
        complete -o nospace -C $tf_ver terraform
    elif [[ $commands[terraform] ]]; then
        complete -o nospace -C $(which terraform) terraform
    fi
fi

if [[ $commands[pydf] ]]; then
    alias df="pydf"
fi

if [[ $commands[apt-get] ]]; then
    alias apt-get="sudo apt-get"
    alias add-apt-repository="sudo add-apt-repository"
    alias apt="sudo apt"
    alias dpkg="sudo dpkg"
fi

if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi

if [[ $commands[doctl] ]]; then
  source <(doctl completion zsh)
fi

alias git-cd='cd $(git root)'
alias history='fc -il 1'

if [[ $commands[ddgr] ]]; then
    alias ddgr='BROWSER=w3m ddgr'
fi

alias tf=terraform

function jcode { code "$(s $1)" }
function jexec { location=$1; shift; (j $location; eval "$@") }
function take { mkdir -p $@ && cd ${@:$#} }


# https://github.com/arzzen/calc.plugin.zsh# Put these in your .zshrc (No need to install a plugin)
calc() python3 -c "from math import *; print($*);"
alias calc='noglob calc'
# You can use `calc` just like `=` from above. All functions from the math module of Python are available for use.


if [[ $commands[glab] ]]; then
    glab-mr () {
        body=""
        while [[ $# -gt 0 ]]; do
            key="$1"
            case $key in
            -t | --title)
                title="$2"
                shift
                shift
                ;;
            -b | --body)
                body="$2"
                shift
                shift
                ;;
            *)
                args="$args $1"
                shift
                ;;
            esac
        done
        if [ -z "$title" ]; then
            title="$(git log -1 --pretty=%B)"
        fi
        glab mr create --push --remove-source-branch --title="$title" --yes --no-editor --description="$body"
    }
fi

if [[ $commands[gh] ]]; then
    gh-pr () {
        args=""
        reviewer=""
        if pwd | grep -q vega; then
            reviewer="vegaprotocol/ops"
        fi
        title=""
        body=""
        while [[ $# -gt 0 ]]; do
            key="$1"
            case $key in
            -t | --title)
                title="$2"
                shift
                shift
                ;;
            -b | --body)
                body="$2"
                shift
                shift
                ;;
            *)
                args="$args $1"
                shift
                ;;
            esac
        done
        if [ -z "$title" ]; then
            title="$(git log -1 --pretty=%B)"
        fi
        eval "gh pr create $args --title='$title' --body='$body' --reviewer='$reviewer'"
    }
fi