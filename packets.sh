#!/bin/bash
function github_release {
    curl -sL https://api.github.com/repos/$1/releases/latest | jq -r '.assets[].browser_download_url' | grep amd64 | grep $2 | grep -v musl | grep -v sha256
}

function install_debian {
    gopass_apt="/etc/apt/sources.list.d/gopass.list"
    if [ ! -d "$gopass_apt" ]
    then
        wget -q -O- https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | apt-key add -
        echo "deb https://dl.bintray.com/gopasspw/gopass trusty main" | tee $gopass_apt
    fi
    apt update
    apt upgrade -y
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
        autojump \
        trash-cli \
        libncursesw5

    # dpkg
    for repo in "sharkdp/fd" "sharkdp/bat" "MitMaro/git-interactive-rebase-tool"
    do
        name="$(echo $repo | cut -d'/' -f 2)"
        curl -L --output "$name.deb" $(github_release $repo 'deb')
        dpkg -i "$name.deb"
        rm "$name.deb"
    done
    # snap
    for app in code slack; do
        if ! snap list | grep "${app}"
        then
            snap install --classic "${app}"
        fi
    done
    for app in spotify; do
        if ! snap list | grep "${app}"
        then
            snap install "${app}"
        fi
    done
}

function install_osx {
    if ! brew --version
    then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    for p in the_silver_searcher jq gnupg2 git gopass pinentry-mac peco bat neovim zsh git-crypt git-lfs fd autojump python trash-cli
    do
        brew install $p
    done
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm get-pip.py
}

function install_fonts {
    (
        if [ ! -d "$FONT_DIR" ]
        then
            mkdir -p $FONT_DIR
        fi
        cd $FONT_DIR
        for font in "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
        do
            font_name="$(echo $font | rev | cut -d'/' -f1 | rev | sed 's|%20| |g')"
            if [ ! -f "$font_name" ]; then
                curl -fLo $font_name $font
            fi
        done
        fc-cache -vf
        mkfontscale
        mkfontdir
    )
}

if [ ! -d "$HOME/.zplug" ]; then
    git clone --depth=1 https://github.com/zplug/zplug ~/.zplug
fi

if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if apt --version; then
    export FONT_DIR="$HOME/Library/Fonts"
    sudo install_debian
    export platform=linux
elif uname -a | grep -iq darwin; then
    export FONT_DIR="$HOME/.local/share/fonts"
    install_osx
    export platform=darwin
fi
install_fonts
curl -L --output ~/bin/yaml2json "$(github_release wakeful/yaml2json $platform)"
curl -L --output "$(github_release 'minamijoyo/tfschema' $platform)" | tar -xz -C ~/bin


if ! colorls -version;
then
    gem install --user colorls
    curl https://raw.githubusercontent.com/athityakumar/colorls/master/zsh/_colorls  > "$PWD/zsh/fpath/_colorls"
else
    gem update --user colorls
fi

export CLOUDSDK_CORE_DISABLE_PROMPTS=1
if ! gcloud version;
then
    curl https://sdk.cloud.google.com | bash
else
    gcloud components update
fi

curl https://cht.sh/:cht.sh > ~/bin/cht.sh
curl -L https://raw.githubusercontent.com/kamranahmedse/git-standup/master/installer.sh | sudo sh
curl -o ~/bin/git-hooks https://raw.githubusercontent.com/icefox/git-hooks/master/git-hooks
gopass completion zsh > "$PWD/zsh/fpath/_gopass"
chmod -x ~/bin/*

if [ -d "~/.tfenv" ]
then
    git clone --branch master --depth 1 https://github.com/tfutils/tfenv.git ~/.tfenv
else
    (
        cd ~/.tfenv
        git pull
    )
fi
