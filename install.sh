#!/bin/bash
set -e
### DEFINE INSTALATION PLATFROM
function get_distro {
    echo "$(cat /etc/*-release | head -n 1 | cut -d= -f 2 | cut -d" " -f 1)"
}
function get_platform {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)
            distro="$(get_distro)"
            case "${distro}" in
                Ubuntu|CentOS) echo "${distro}"
                ;;
                *) echo "UNKOWN LNIUX DISTRIBUTION ${distro}" && exit -1
            esac
        ;;
        Darwin*) echo Darwin
        ;;
        CYGWIN*) echo "Cygwin is not supported, try to analyze sourcode to install dependencies" && exit -1
        ;;
        MINGW*) echo "Mingw is not supported, try to analyze sourcode to install dependencies" && exit -1
        ;;
        *) echo "UNKOWN OS: ${unameOut}" && exit -1
    esac
}

### ENDEF

function install_powerline_font { (
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
) }

function install_zsh {
    [ "$(whoami)" = root ] && prefix="" || prefix="sudo"
    case "$1" in
        Ubuntu*)
            $prefix apt-get install -y \
                git \
                fonts-powerline \
                ttf-ancient-fonts \
                tmux \
                vim \
                zsh
        ;;
        CentOS*)
            $prefix yum install -y \
                git \
                which \
                tmux \
                vim \
                zsh
            install_powerline_font
        ;;
        Darwin*)
            if echo "$(which brew)" | grep --quiet brew; then
                brew cask install iterm2
                for pack in git tmux zsh; do
                    if [ ! $commands[$pack] ]; then
                        brew install $pack
                    fi
                done
                install_powerline_font
            else
                echo "You have to install brew before..." && exit -1
            fi
        ;;
    esac
    chsh -s $(which zsh) #set zsh as current default shell
}

function install_oh_my_zsh {
    #install oh-my-zsh
    sh -ct "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null &
    sh_pid=$!
    while ! ps -a | grep --quiet zsh; do
        echo "" > /dev/null
    done
    kill $sh_pid > /dev/null
}

function link_config_files {
    git clone https://github.com/mkjmdski/shell-config.git #get repository with shell-config
    for symlink in .zshrc .zshenv .oh-my-zsh/custom; do
        rm -rf $symlink
        ln -s "$PWD/shell-config/$symlink" $symlink
    done #create absolute symlinks to every configuration in this repo
}

function install_plugins {
    declare -a plugins=(
        https://github.com/zsh-users/zsh-autosuggestions.git
        https://github.com/zsh-users/zsh-syntax-highlighting.git
        https://github.com/leonhartX/docker-machine-zsh-completion.git
    )
    for custom_plugin in "${plugins[@]}"; do
        git clone $custom_plugin $ZSH/custom/plugins
    done
    declare -A raw_plugins=(
        [lpass]=https://raw.githubusercontent.com/lastpass/lastpass-cli/master/contrib/lpass_zsh_completion
    )
    for raw_plugin in "${!raw_plugins[@]}"; do
        local plugin_location="$ZSH/custom/plugins/${raw_plugin}"
        mkdir -p $plugin_location
        curl -L ${raw_plugins[$raw_plugin]} > "${plugin_location}/_${raw_plugin}"
    done
}

platform="$(get_platform)"
install_zsh ${platform}

export ZSH="$HOME/.oh-my-zsh" #default root of ZSH
install_oh_my_zsh

cd $HOME
link_config_files

install_plugins