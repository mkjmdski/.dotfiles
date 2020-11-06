if [[ $commands[jira] ]]; then
    eval "$(jira --completion-script-zsh)"
fi

if [[ $commands[kubectl] ]]; then
    alias kubectl="export SPACESHIP_KUBECTL_SHOW='true'; $(which kubectl)"
    alias ke="k exec"
    alias ket="ke -it"
    alias kgpf="kgp -o name | head -n 1"
    alias ketf='ket $(kgpf) -- /bin/sh'
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
    alias dcc="docker-compose"
fi

function gca {
    gcloud config configurations activate $(gcl | grep $1 | awk '{print $1}')
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

if [[ $commands[terraform] ]]; then
    function tplan {
        terraform plan | tee tfplan.ignore
        echo ">>> ADDRESSES <<<"
        echo ">>> created"
        for d in $(cat tfplan.ignore | grep 'created' | cut -d ' ' -f 4); do echo "'${d}'"; done
        echo
        echo ">>> destroyed"
        echo
        for d in $(cat tfplan.ignore | grep 'destroyed' | cut -d ' ' -f 4); do echo "'${d}'"; done
    }
fi

if [[ $commands[pydf] ]]; then
    alias df="pydf"
fi

if [[ $commands[apt-get] ]]; then
    alias apt-get="sudo apt-get"
    alias add-apt-repository="sudo add-apt-repository"
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

function chpwd {
    if [ -d ".git" ] || [ -f ".git" ]; then
        if [ ! -f ".git/index.lock" ]; then
            git pull &
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
