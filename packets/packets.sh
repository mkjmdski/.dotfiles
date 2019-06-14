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
        git-crypt \
        git-lfs \
        chrome-gnome-shell \
        autojump

    # dpkg
    wget https://github.com/sharkdp/fd/releases/download/v7.2.0/fd_7.2.0_amd64.deb
    wget https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb
    dpkg -i fd_7.2.0_amd64.deb
    dpkg -i bat_0.9.0_amd64.deb
    rm bat_0.9.0_amd64.deb fd_7.2.0_amd64.deb

    # snap
    for app in code slack; do
        snap install --classic "${app}"
    done
    for app in spotify caprine terraform; do
        snap install "${app}"
    done
}

function install_arch {
    pacman -S --noconfirm \
        gnupg \
        git \
        rng-tools \
        gopass \
        the_silver_searcher \
        python \
        python-pip \
        most \
        ruby \
        ruby-rdoc \
        neovim \
        zsh \
        jq \
        fd \
        bat \
        terminator \
        terraform \
        autojump \
        base-devel \
        git-crypt \
        git-lfs \

}

function install_osx {
  if ! brew --version
  then 
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew install \
    the_silver_searcher \
    jq \
    gnupg2 \
    git \
    gopass \ 
    pinentry-mac \
    peco \
    bat \
    neovim \
    zsh \
    git-crypt \
    git-lfs \
    fd \
    autojump \
    python
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm get-pip.py
}


if apt --version &> /dev/null; then
    install_debian
elif pacman --version &> /dev/null; then
    install_arch
elif uname -a | grep -iq darwin; then
    install_osx
fi
