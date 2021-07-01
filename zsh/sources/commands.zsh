if [[ $commands[jira] ]]; then
    eval "$(jira --completion-script-zsh)"
fi

if [[ $commands[kubectl] ]]; then
    alias kubectl="export SPACESHIP_KUBECTL_SHOW='true'; $(which kubectl)"
    alias ke="k exec"
    alias ket="ke -it"
    alias kgpf="kgp -o name | head -n 1"
    alias ketf='ket $(kgpf) -- /bin/sh'
    alias kg='k get'
    source <(kubectl completion zsh)
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

if [[ $commands[docker] ]]; then
    alias dcc='if [ $(uname) = "Linux" ]; then DOCKER_HOST="host.docker.internal"; else DOCKER_HOST="docker.for.mac.host.internal"; fi; docker-compose'
fi

function gca {
    gcloud config configurations activate $(gcl | grep $1 | awk '{print $1}')
}

function jcode {
    code "$(s $1)"
}

function jexec {
    location=$1;
    shift
    (j $location; eval "$@")
}

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

if [[ $commands[fpp] ]]; then
    alias fpp="EDITOR='code --wait' fpp"
fi

if [[ $commands[tfenv] ]]; then
    tfenv_root=$(echo $(which tfenv) | rev | cut -d/ -f 3- | rev)
    tf_ver="${tfenv_root}/version"
    if [ -f "$tf_ver" ]; then
        tf_ver="${tfenv_root}/versions/$(cat $tf_ver)/terraform"
        complete -o nospace -C $tf_ver terraform
    fi
elif [[ $commands[terraform] ]]; then
    complete -o nospace -C $(which terraform) terraform
fi

alias xD="echo 'xD'"
alias xd="echo 'xd'"

if [[ $commands[docker] ]] && [[ ! $commands[envy] ]]; then
    export ENVY_VERSION=1.26.11
    alias envy='docker run --rm -it -e K8S_MANIFESTS_DIR=/manifests -v "$K8S_MANIFESTS_DIR:/manifests" -v "$HOME/.config/gcloud:/root/.config/gcloud" -v "$HOME/.kube:/root/.kube" eu.gcr.io/karhoo-common/envy:$ENVY_VERSION'
fi

if [[ ! -z "$(which envy)" ]] && [[ -d "$HOME/repos/karhoo/k8s-manifests" ]]; then
    export K8S_MANIFESTS_DIR="$HOME/repos/karhoo/k8s-manifests"
fi


if [[ $commands[terraform] ]]; then
    function tplan {
        terraform plan | tee tfplan.ignore
        echo ">>> ADDRESSES <<<"
        echo ">>> created"
        for d in $(cat tfplan.ignore | grep 'created' | cut -d ' ' -f 4); do echo "'${d}'"; done | tee plan.ignore
        echo
        echo ">>> destroyed"
        echo
        for d in $(cat tfplan.ignore | grep 'destroyed' | cut -d ' ' -f 4); do echo "'${d}'"; done | tee -a plan.ignore
    }
    function tsort {
        file="${1-plan.ignore}"
        final_file="${2-script.sh}"
        echo '#!/bin/bash' > $final_file
        resources=$(for line in $(cat $file); do
            line="$(echo $line | cut -d'.' -f 1)"
            echo "${line}"
        done | grep google | sort | uniq | sed "s|'||g")
        while IFS= read -r resource; do
            cat $file | grep $resource >> $final_file
        done <<< "$resources"
    }
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

if [[ $commands[broot] ]]; then
    function br {
        f=$(mktemp)
        (
            set +e
            broot --outcmd "$f" "$@"
            code=$?
            if [ "$code" != 0 ]; then
                /bin/rm -f "$f"
                exit "$code"
            fi
        )
        code=$?
        if [ "$code" != 0 ]; then
        return "$code"
        fi
        d=$(<"$f")
        /bin/rm -f "$f"
        eval "$d"
    }
fi

if [[ $commands[bump] ]]; then
    alias bump="bump --allow-dirty"
fi

# if [[ $commands[ns1] ]]; then
#     eval "$(_NS1_COMPLETE=source ns1)"
# fi

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
alias history='fc -il 1'

alias barracudavpn='TERM=xterm barracudavpn'
alias ddgr='BROWSER=w3m ddgr'

function dbase {
    echo $1 | base64 -d
}

function password {
    python3 <<EOF
import secrets
import string
alphabet = string.ascii_letters + string.digits
password = ''.join(secrets.choice(alphabet) for i in range(${1:-20}))
print(password)
EOF
}

function chpwd {
    if [ -d ".git" ] || [ -f ".git" ]; then
        if [ ! -f ".git/index.lock" ]; then
            git pull &
            # if [ -f '.gitmodules' ]; then
            #     git submodule update --recursive --remote --init &
            # fi
        fi
    fi
    if [ -f "docker-compose.yaml" ] || [ -f "docker-compose.yml" ]; then
        dcc pull &
    fi
    if [ -d "venv" ] && [ -z "$VIRTUAL_ENV" ]; then
        source venv/bin/activate
    fi
    if [ ! -d "venv" ] && [ ! -z "$VIRTUAL_ENV" ]; then
        deactivate
    fi
}

function settfe {
    export TFE_TOKEN="$(cat ~/.terraformrc | grep $1 -A 1 | tail -n 1 | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '"')"
}

alias vpn='sudo openvpn --config "$(pwd | rev | cut -d/ -f1 | rev).conf" --auth-user-pass /etc/openvpn/auth.txt'

function ssh-d {
    server="$1"
    container="$2"
    command="$3"
    ssh -t $server docker exec -it $(ssh $server docker ps | grep $container | awk '{print $1}' | head -n 1) "${command:-/bin/sh}"
}

function ssh-d-cp {
    server="$1"
    project="$2"
    src="$3"
    dest="$4"

    type="$(ssh-d $server $project env | grep -i backend | cut -d '=' -f 2)"
    tmp_backend="$(echo "/tmp/$project/$src" | sed 's|//|/|g')"

    echo ">> Making directory $tmp_backend"
    ssh $server mkdir -p "$tmp_backend"

    echo ">> Copy ${src} to $tmp_backend on $server"
    ssh -t $server docker cp "$(ssh $server docker ps | grep $project | awk '{print $1}' | head -n 1):/${src}" "$tmp_backend"

    if [ "$src" = "/app/backend" ]; then
        if [ "$type" = "WORDPRESS" ]; then
            for dir in "wp-content/uploads/"; do
                ssh $server "rm -rf $tmp_backend/backend/$dir/"
            done
        elif [ "$type" = "PRESTA" ]; then
            for dir in "img/" "var/" "/download"; do
                ssh $server "rm -rf $tmp_backend/backend/$dir/"
            done
        fi
    fi

    echo ">> Making tar archive from $tmp_backend on $server to $dest on local machine"
    ssh $server tar czf - "$tmp_backend" > "$dest"

    echo ">> Cleaning up $tmp_backend on $server"
    ssh $server rm -rf "$tmp_backend"
}


function project-copy {
    server="$1"
    project="$2"
    echo ">> Copying backend"
    ssh-d-cp $server $project /app/backend "./backend.tgz"
    mkdir tmp
    (
        cd tmp
        x ../backend.tgz
    )
    rm backend.tgz
    # take latest directory from backend/**/* and move it
    echo ">> Making dump by dumper"
    ssh-d $server $project "dumper --dump app"
    echo ">> Copying dump"
    ssh-d-cp $server $project /dump "./dump.tgz"
    (
        cd tmp
        x ../dump.tgz
    )
    rm dump.tgz
    echo ">> Cleanup dump"
    ssh-d $server $project "rm -rf /dump"
}

function socks {
    if [ "$1" = "--help" ]; then
        echo 'SETUP'
        echo '0. run: socks --init'
        echo '1. script will start firefox with Profile Manager by running: firefox --ProfileManager'
        echo '2. create manually a new profile named "socks" and keep "default" profile as default, exit firefox'
        echo '3. script will start firefox with the new profile by running: firefox -P socks'
        echo '4. configure manully socks proxy on port 1337 (script default) by running search for `proxy` word in settings tab'
        echo '5. exit firefox and use socks script'
        echo '6. USAGE: socks gatewayname [domain-url.com]'
        echo '7. SETTINGS (env variables): SOCKS_SESSION_DURATION to control session time (sleep command over ssh) and SOCKS_SESSION_PORT to change default port which is used by browser'
    elif [ "$1" = "--init" ]; then
        firefox --ProfileManager
        firefox -P socks
    else
        session_time=${SOCKS_SESSION_DURATION:-28800}
        echo "starting ssh session to '${1}' with duration $session_time seconds"
        ssh -D "${SOCKS_SESSION_PORT:-1337}" $1 /bin/bash -c "sleep $session_time"  </dev/null &>/dev/null & #start session for 8 hours
        session="$!"
        wait_time=5
        echo "waiting $wait_time seconds for ssh session to initialize (if you will see communicate: proxy server is refusing connections, just wait a little bit longer and refresh the browser)"
        sleep $wait_time
        echo "starting firefox"
        firefox --P socks $2
        echo "killing ssh session "
        kill -9 $session
    fi
}


function parse-uber {
    (
        take invoices
        find . -type f -exec rm {} \;
        mv ../invoice-* .
        for invoice in invoice-*; do
            pdftk "${invoice}" cat 1 output "tmp-${invoice}"
        done
        pdftk tmp-invoice-* cat output uber.pdf
    )
}

function tfopen {
    if [ ! -f 'versions.tf' ]; then
        echo 'there is no versions.tf file, search for `terraform {` block in workspace files and put all of them as one into versions.tf'
        exit 1
    fi
    host=$(cat versions.tf | grep backend -A 5 | grep hostname | cut -d '=' -f 2 | tr -d '"' | sed 's/^ *//g')
    workspace=$(cat versions.tf | grep workspaces -A 1 | grep name | cut -d '=' -f 2 | tr -d '"' | sed 's/^ *//g')
    org=$(cat versions.tf | grep backend -A 5 | grep organization | cut -d '=' -f 2 | tr -d '"' | sed 's/^ *//g')
    link="https://${host}/app/${org}/${workspace}"
    if which xdg-open &> /dev/null; then
        xdg-open $link
    elif which open &> /dev/null; then
        open $link
    else
        echo 'open this link in your browser'
        echo $link
    fi
}
