#!/bin/bash
export ZSH="$HOME/.oh-my-zsh" #default root of ZSH
apt-get install -y zsh #install zsh core
chsh -s $(which zsh) #set zsh as current default shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" #install oh-my-zsh
rm -rf $ZSH/custom #remove custom directory with example
cd $ZSH/..
git clone https://github.com/mkjmdski/shell-config.git #get repository with my extensions
(
    cd shell-config
    sed -i "/export ZSH=/c\export ZSH=$ZSH" .zshrc #replace ZSH config with current config
    for file in .zshrc .zshenv .oh-my-zsh/custom/; do
    (
        cd ..
        ln -s "$PWD/shell-config/$file" $file
    ) 
    done #create absolute symlinks to every configuration in this repo
    for custom_plugin in $(cat .custom-plugins); do #install all custom plugins listed in the file
    (
        cd $ZSH/custom/plugins
        git clone $custom_plugin
    )
    done
    bash setup-git.sh
)