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


if [[ -z "${CLOUDSDK_HOME}" ]]; then
  search_locations=(
    "$HOME/google-cloud-sdk"
    "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/usr/share/google-cloud-sdk"
    "/snap/google-cloud-sdk/current"
    "/usr/lib64/google-cloud-sdk/"
    "/opt/google-cloud-sdk"
  )

  for gcloud_sdk_location in $search_locations; do
    if [[ -d "${gcloud_sdk_location}" ]]; then
      CLOUDSDK_HOME="${gcloud_sdk_location}"
      break
    fi
  done
fi

if (( ${+CLOUDSDK_HOME} )); then
  if (( ! $+commands[gcloud] )); then
    # Only source this if GCloud isn't already on the path
    if [[ -f "${CLOUDSDK_HOME}/path.zsh.inc" ]]; then
      source "${CLOUDSDK_HOME}/path.zsh.inc"
    fi
  fi
  alias gcloud="export SPACESHIP_GCLOUD_SHOW='true'; $(which gcloud)"
  alias gcl="gcloud config configurations list"
  function gca {
      gcloud config configurations activate $(gcl | grep $1 | awk '{print $1}')
  }
  source "${CLOUDSDK_HOME}/completion.zsh.inc"
  export CLOUDSDK_HOME
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

if [[ $commands[br] ]]; then
    alias br="br --conf $DOTFILES/broot.toml"
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
alias history='fc -il 1'
