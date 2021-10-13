alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tf-docs='docker run --rm -it -v $(pwd):/workspace gcr.io/cloud-foundation-cicd/cft/developer-tools:0.13 /bin/bash -c "source /usr/local/bin/task_helper_functions.sh && generate_docs"'
if [[ $commands[kubectl] ]]; then
    alias kubectl="export SPACESHIP_KUBECTL_SHOW='true'; $(which kubectl)"
    alias ke="k exec"
    alias ket="ke -it"
    alias kgpf="kgp -o name | head -n 1"
    alias ketf='ket $(kgpf) -- /bin/sh'
    alias kg='k get'
    alias kgj='kg job'
    source <(kubectl completion zsh)
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

alias xD="echo 'xD'"
alias xd="echo 'xd'"

if [[ $commands[docker] ]] && [[ ! $commands[envy] ]]; then
    # export ENVY_VERSION=1.26.11
    alias envy='docker run --rm -it -e K8S_MANIFESTS_DIR=/manifests -v "$K8S_MANIFESTS_DIR:/manifests" -v "$HOME/.config/gcloud:/root/.config/gcloud" -v "$HOME/.kube:/root/.kube" eu.gcr.io/karhoo-common/envy:${ENVY_VERSION:-latest}'
fi

if [[ ! -z "$(which envy)" ]] && [[ -d "$HOME/repos/karhoo/k8s-manifests" ]]; then
    export K8S_MANIFESTS_DIR="$HOME/repos/karhoo/k8s-manifests"
fi

if [[ $commands[pydf] ]]; then
    alias df="pydf"
fi

if [[ $commands[apt-get] ]]; then
    alias apt-get="sudo apt-get"
    alias add-apt-repository="sudo add-apt-repository"
    alias apt="sudo apt"
fi

if [[ $commands[dpkg] ]]; then
    alias dpkg="sudo dpkg"
fi

if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi

if [[ $commands[helmsman] ]]; then
    alias helmsman='GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/application_default_credentials.json KUBE_CONTEXT=$(kubectl config current-context) helmsman'
fi

if [[ $commands[doctl] ]]; then
  source <(doctl completion zsh)
fi

alias git-cd='cd $(git root)'
alias history='fc -il 1'

if [[ $commands[barracudavpn] ]]; then
    alias barracudavpn='TERM=xterm barracudavpn'
fi

if [[ $commands[ddgr] ]]; then
    alias ddgr='BROWSER=w3m ddgr'
fi

function jcode { code "$(s $1)" }
function jexec { location=$1; shift; (j $location; eval "$@") }
function take { mkdir -p $@ && cd ${@:$#} }
