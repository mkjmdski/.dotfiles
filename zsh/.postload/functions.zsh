#!/bin/zsh

function cd-gitroot {
    local root
    root=$(git rev-parse --show-toplevel)
    eval $root
}

function gopass-clipboard {
    local secret
    secret=$(gopass show $1 | head -n 1)
    clipcopy <<< $secret
}

function take {
  mkdir -p $@ && cd ${@:$#}
}

function zsh_stats {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

function log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}

function update_vscode_extensions {
    code --list-extensions > "$DOTFILES/vscode/installed_vs_extensions"
}

function setup_venv {
    virtualenv --python=$(which python3) venv
    if ! cat .gitignore | grep -q venv; then
        echo "venv" >> .gitignore
    fi
    source venv/bin/activate
    if [ -f requirements.txt ]; then
        pip3 install -r requirements.txt
    fi
}

function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
