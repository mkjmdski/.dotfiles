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

function vim_update {
    vim +PluginInstall +qall
}

function nvim_update {
    nvim +PlugInstall +qall
}

function log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}

function install_vscode_extensions {
    local extensions_file="$DOTFILES/vscode/installed_vs_extensions"
    local installed_extensions="$(code --list-extensions)"
    local -a ext_to_install
    for extension in $(cat $extensions_file); do
        if ! echo "${installed_extensions}" | grep --quiet "${extension}"; then
            ext_to_install+=("${extension}")
        fi
    done
    if [ ${#ext_to_install[@]} -gt 0 ]; then
        echo "${ext_to_install[@]}"
        read -p " >> Install vscode extensions? [y/N]" -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for extension in $(cat $extensions_file); do
                if ! echo "${installed_extensions}" | grep --quiet "${extension}"; then
                    code --install-extension "${extension}"
                fi
            done
        fi
    fi
}

function update_vscode_extensions {
    code --list-extensions > "$DOTFILES/vscode/install_vscode_extensions"
}