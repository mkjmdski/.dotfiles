alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tf-docs='docker run --rm -it -v $(pwd):/workspace gcr.io/cloud-foundation-cicd/cft/developer-tools:0.13 /bin/bash -c "source /usr/local/bin/task_helper_functions.sh && generate_docs"'

if [[ $commands[kubectl] ]]; then
    if [[ $commands[kubecolor] ]]; then
        alias kubectl=kubecolor
        alias k=kubecolor
    fi

    # omz kubectl plugin copy-pasted to work with kubie
    # Execute a kubectl command against all namespaces
    alias kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'

    # Apply a YML file
    alias kaf='kubectl apply -f'

    # Drop into an interactive terminal on a container
    alias keti='kubectl exec -t -i'

    # Manage configuration quickly to switch contexts between local, dev ad staging.
    alias kcuc='kubectl config use-context'
    alias kcsc='kubectl config set-context'
    alias kcdc='kubectl config delete-context'
    alias kccc='kubectl config current-context'

    # List all contexts
    alias kcgc='kubectl config get-contexts'

    # General aliases
    alias kdel='kubectl delete'
    alias kdelf='kubectl delete -f'

    # Pod management.
    alias kgp='kubectl get pods'
    alias kgpa='kubectl get pods --all-namespaces'
    alias kgpw='kgp --watch'
    alias kgpwide='kgp -o wide'
    alias kep='kubectl edit pods'
    alias kdp='kubectl describe pods'
    alias kdelp='kubectl delete pods'
    alias kgpall='kubectl get pods --all-namespaces -o wide'

    # get pod by label: kgpl "app=myapp" -n myns
    alias kgpl='kgp -l'

    # get pod by namespace: kgpn kube-system"
    alias kgpn='kgp -n'

    # Service management.
    alias kgs='kubectl get svc'
    alias kgsa='kubectl get svc --all-namespaces'
    alias kgsw='kgs --watch'
    alias kgswide='kgs -o wide'
    alias kes='kubectl edit svc'
    alias kds='kubectl describe svc'
    alias kdels='kubectl delete svc'

    # Ingress management
    alias kgi='kubectl get ingress'
    alias kgia='kubectl get ingress --all-namespaces'
    alias kei='kubectl edit ingress'
    alias kdi='kubectl describe ingress'
    alias kdeli='kubectl delete ingress'

    # Namespace management
    alias kgns='kubectl get namespaces'
    alias kens='kubectl edit namespace'
    alias kdns='kubectl describe namespace'
    alias kdelns='kubectl delete namespace'
    alias kcn='kubectl config set-context --current --namespace'

    # ConfigMap management
    alias kgcm='kubectl get configmaps'
    alias kgcma='kubectl get configmaps --all-namespaces'
    alias kecm='kubectl edit configmap'
    alias kdcm='kubectl describe configmap'
    alias kdelcm='kubectl delete configmap'

    # Secret management
    alias kgsec='kubectl get secret'
    alias kgseca='kubectl get secret --all-namespaces'
    alias kdsec='kubectl describe secret'
    alias kdelsec='kubectl delete secret'

    # Deployment management.
    alias kgd='kubectl get deployment'
    alias kgda='kubectl get deployment --all-namespaces'
    alias kgdw='kgd --watch'
    alias kgdwide='kgd -o wide'
    alias ked='kubectl edit deployment'
    alias kdd='kubectl describe deployment'
    alias kdeld='kubectl delete deployment'
    alias ksd='kubectl scale deployment'
    alias krsd='kubectl rollout status deployment'

    function kres(){
    kubectl set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
    }

    # Rollout management.
    alias kgrs='kubectl get replicaset'
    alias kdrs='kubectl describe replicaset'
    alias kers='kubectl edit replicaset'
    alias krh='kubectl rollout history'
    alias kru='kubectl rollout undo'

    # Statefulset management.
    alias kgss='kubectl get statefulset'
    alias kgssa='kubectl get statefulset --all-namespaces'
    alias kgssw='kgss --watch'
    alias kgsswide='kgss -o wide'
    alias kess='kubectl edit statefulset'
    alias kdss='kubectl describe statefulset'
    alias kdelss='kubectl delete statefulset'
    alias ksss='kubectl scale statefulset'
    alias krsss='kubectl rollout status statefulset'

    # Port forwarding
    alias kpf="kubectl port-forward"

    # Tools for accessing all information
    alias kga='kubectl get all'
    alias kgaa='kubectl get all --all-namespaces'

    # Logs
    alias kl='kubectl logs'
    alias kl1h='kubectl logs --since 1h'
    alias kl1m='kubectl logs --since 1m'
    alias kl1s='kubectl logs --since 1s'
    alias klf='kubectl logs -f'
    alias klf1h='kubectl logs --since 1h -f'
    alias klf1m='kubectl logs --since 1m -f'
    alias klf1s='kubectl logs --since 1s -f'

    # File copy
    alias kcp='kubectl cp'

    # Node Management
    alias kgno='kubectl get nodes'
    alias keno='kubectl edit node'
    alias kdno='kubectl describe node'
    alias kdelno='kubectl delete node'

    # PVC management.
    alias kgpvc='kubectl get pvc'
    alias kgpvca='kubectl get pvc --all-namespaces'
    alias kgpvcw='kgpvc --watch'
    alias kepvc='kubectl edit pvc'
    alias kdpvc='kubectl describe pvc'
    alias kdelpvc='kubectl delete pvc'

    # Service account management.
    alias kdsa="kubectl describe sa"
    alias kdelsa="kubectl delete sa"

    # DaemonSet management.
    alias kgds='kubectl get daemonset'
    alias kgdsa='kubectl get daemonset --all-namespaces'
    alias kgdsw='kgds --watch'
    alias keds='kubectl edit daemonset'
    alias kdds='kubectl describe daemonset'
    alias kdelds='kubectl delete daemonset'

    # CronJob management.
    alias kgcj='kubectl get cronjob'
    alias kecj='kubectl edit cronjob'
    alias kdcj='kubectl describe cronjob'
    alias kdelcj='kubectl delete cronjob'

    # Job management.
    alias kgj='kubectl get job'
    alias kej='kubectl edit job'
    alias kdj='kubectl describe job'
    alias kdelj='kubectl delete job'
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

    kgp-node() {
        kgp $1 -o json | jq -r '.spec | .nodeName'
    }

    k-list() {
        kubectl get $1 | tail -n +2 | awk '{print $1}'
    }

    source <(kubectl completion zsh)
    source <(kubectl completion zsh | sed 's|kubectl|kubecolor|g')
fi

if [[ $commands[ansible-playbook] ]]; then
    ap() {
        if [ -z "$ANSIBLE_USER" ]; then
            ANSIBLE_USER=miko
        fi
        /usr/bin/env ansible-playbook --user $ANSIBLE_USER "$@" | sed 's/\\n/\n/g'
    }

    ap-check() {
        ap --check --diff "$@"
    }
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
        tf_ver="${tfenv_root}/versions/$(/bin/cat $tf_ver)/terraform"
        complete -o nospace -C $tf_ver terraform
    elif [[ $commands[terraform] ]]; then
        complete -o nospace -C $(which terraform) terraform
    fi
fi

if [[ $commands[terragrunt] ]]; then
    glab_token=$(/bin/cat ~/.config/glab-cli/config-2.yml | yq -r '.token')
    # glab_token=$(/bin/cat ~/.config/glab-cli/config.yml | yq -r '.hosts["gitlab.com"].token')
    alias tg="export GITLAB_USER=mkjmdski-covantis; export GITLAB_ACCESS_TOKEN=$glab_token; terragrunt"
fi

if [[ $commands[code] ]]; then
    alias code="code --disable-gpu"
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

alias code.='code .'
alias c="code ."

function jcode { code "$(s $1)" }
function jexec { location=$1; shift; (j $location; eval "$@") }
function take { mkdir -p $@ && cd ${@:$#} }


# https://github.com/arzzen/calc.plugin.zsh# Put these in your .zshrc (No need to install a plugin)
calc() { python3 -c "from math import *; print($*);" }
alias calc='noglob calc'
# You can use `calc` just like `=` from above. All functions from the math module of Python are available for use.


if [[ $commands[glab] ]]; then
    glab-mr () {
        local body=""
        local title=""
        local args=""
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
        glab mr create --push --remove-source-branch --squash-before-merge --title="$title" --yes --no-editor --description="$body"
    }
    alias glab-repo='glab repo view --web --branch $(git current-branch)'
fi

if [[ $commands[gh] ]]; then
    gh-pr () {
        local args=""
        local reviewer=""
        if pwd | grep -q vega; then
            reviewer="vegaprotocol/ops"
        fi
        local title=""
        local body=""
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
    alias gh-repo='gh repo view --web --branch $(git current-branch)'
fi

# az cli autocomplete
if [ "$DOTFILES_CONF_azure" = "true" ]; then
    _python_argcomplete() {
        local IFS=$'\013'
        local SUPPRESS_SPACE=0
        if compopt +o nospace 2> /dev/null; then
            SUPPRESS_SPACE=1
        fi
        COMPREPLY=( $(IFS="$IFS" \
                    COMP_LINE="$COMP_LINE" \
                    COMP_POINT="$COMP_POINT" \
                    COMP_TYPE="$COMP_TYPE" \
                    _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                    _ARGCOMPLETE=1 \
                    _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                    "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
        if [[ $? != 0 ]]; then
            unset COMPREPLY
        elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "$COMPREPLY" =~ [=/:]$ ]]; then
            compopt -o nospace
        fi
    }
    complete -o nospace -o default -o bashdefault -F _python_argcomplete "az"
fi
