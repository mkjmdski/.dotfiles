#!/bin/zsh
set -e
for file in $(git rev-parse --show-toplevel)/lib/*.sh; do
    source "${file}"
done


function main {
    vundle_dir="$HOME/.vim/bundle/Vundle.vim"
    if [ ! -d "${vundle_dir}" ]; then
        _log_info "Cloning vundle"
        git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "${vundle_dir}"
    fi
    link_config .vimrc
    _log_info "Do you want to install vim plugins now? [y/N]"
    if read -q; then
        echo
        vim +PluginInstall +qall
    else
        echo
        _log_info "You can do it later by running: vim +PluginInstall +qall"
    fi
}

_log_info "Configuring vim"
main
_log_info "Success"