#!/bin/bash

function install_debian {
    # apt
    wget -q -O- https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -
    echo "deb https://dl.bintray.com/gopasspw/gopass trusty main" | sudo tee /etc/apt/sources.list.d/gopass.list
    apt update
    apt install -y \
        silversearcher-ag \
        most \
        jq \
        python3 \
        python3-pip \
        python3-dev \
        python3-setuptools \
        ruby \
        ruby-dev \
        rng-tools \
        gnupg \
        gopass \
        peco \
        neovim \
        zsh \
        terminator \
        autojump

    # dpkg
    wget https://github.com/sharkdp/fd/releases/download/v7.2.0/fd_7.2.0_amd64.deb
    wget https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb
    dpkg -i fd_7.2.0_amd64.deb
    dpkg -i bat_0.9.0_amd64.deb
    rm bat_0.9.0_amd64.deb fd_7.2.0_amd64.deb

    # snap
    for app in code slack spotify; do
        snap install --classic "${app}"
    done
}

function install_arch {
    pacman -S --noconfirm \
        gnupg2 \
        git \
        rng-tools \
        gopass \
        mc meld \
        the_silver_searcher \
        python python-pip \
        most \
        ruby \
        ruby-rdoc \
        neovim \
        zsh \
        jq \
        fd \
        bat \
        terminator \
        autojump \
        tree
}

if apt --version &> /dev/null; then
    install_debian
elif pacman --version &> /dev/null; then
    install_arch
fi

pip3 install \
    thefuck \
    git+https://github.com/jeffkaufman/icdiff.git
gem install \
    colorls

chsh -s /bin/zsh