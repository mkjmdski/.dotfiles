#!/bin/bash
set -e
### DEFINE INSTALATION PLATFROM
function get_distro {
    echo "$(cat /etc/*-release | head -n 1 | cut -d= -f 2 | cut -d" " -f 1)" #why the fuck this works even if -d" " stop quoting?
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

function install_zsh {
    [ "$(whoami)" = root ] && prefix="" || prefix="sudo"
    case "$1" in
        Ubuntu*) 
            $prefix apt-get install -y \
                git \
                vim \
                zsh
        ;;
        CentOS*) 
            $prefix yum install -y \
                git \
                which \
                vim \
                zsh
            $prefix yum clean all
        ;;
        Darwin*)
            if echo "$(which brew)" | grep --quiet brew; then
                brew install zsh git
            else
                echo "You have to install brew before..." && exit -1
            fi
        ;;
    esac
    chsh -s $(which zsh) #set zsh as current default shell
}

platform="$(get_platform)"
install_zsh ${platform}

export ZSH="$HOME/.oh-my-zsh" #default root of ZSH
#install oh-my-zsh
sh -ct "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null &
sh_pid=$!
while ! ps -a | grep --quiet zsh; do
    echo "" > /dev/null
done
kill $sh_pid > /dev/null

cd $ZSH/.. #enter directory above ssh
git clone https://github.com/mkjmdski/shell-config.git #get repository with shell-config
(
    cd shell-config
    curl -L git.io/antigen > .oh-my-zsh/custom/antigen.zsh #install antigen
    sed -i "/export ZSH=/c\export ZSH=$ZSH" .zshrc #replace ZSH config with current config
    for symlink in .zshrc .zshenv .oh-my-zsh/custom; do
    (
        cd ..
        rm -rf $symlink
        ln -s "$PWD/shell-config/$symlink" $symlink
    ) 
    done #create absolute symlinks to every configuration in this repo
    for custom_plugin in $(cat .custom-plugins); do #install all custom plugins listed in the file
    (
        cd $ZSH/custom/plugins
        git clone $custom_plugin
    )
    done
    for dir in provisioning/*; do
        (
            cd $dir
            bash run.sh
        )
    done
)