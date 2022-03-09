#!/bin/bash -eux

export DOTFILES="$HOME/.dotfiles"
export PATH="$DOTFILES/bin:$PATH"
eval $(parse-yaml $DOTFILES/config.yaml DOTFILES_CONF_)

function setup_binary_env {
    repo=$1
    location="$HOME/.$(echo $repo | cut -d'/' -f 2)"
    if [ ! -d "$location" ]
    then
        git clone --branch master --depth 1 https://github.com/$repo.git "$location"
    else
        (
            cd "$location"
            git pull
        )
    fi
}

function install_fonts {
    FONT_DIR="$HOME/.local/share/fonts"
    (
        if [ ! -d "${FONT_DIR}" ]; then
            mkdir -p "${FONT_DIR}"
        fi
        cd "${FONT_DIR}"
        for font in "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
        do
            font_name="$(echo "${font}" | rev | cut -d'/' -f1 | rev | sed 's|%20| |g')"
            if [ ! -f "$font_name" ]; then
                curl -fL --output "${font_name}" "${font}"
            fi
        done
        fc-cache -vf
        mkfontscale
        mkfontdir
    )
}

function install_debian_standard {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        python3 \
        python3-pip \
        python3-dev \
        python3-setuptools \
        curl
}

function install_debian_extras {
    sudo apt-get install -y \
        ruby \
        ruby-dev \
        rng-tools \
        gnupg \
        neovim \
        zsh \
        terminator \
        xclip \
        xdotool \
        trash-cli \
        libncursesw5 \
        gtk+3.0 \
        webkit2gtk-4.0 \
        libusb-dev \
        x11-apps \
        openvpn \
        libgtop-2.0-11 \
        gir1.2-gtop-2.0 \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common \
        w3m
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    sudo usermod -a -G docker $(whoami)

    if [ "$DOTFILES_CONF_uber" = "true" ]; then
        sudo apt-get install -y \
            pdftk \
            poppler-utils

    fi

    if [ "$DOTFILES_CONF_gnome" = "true" ]; then
        sudo apt-get install -y \
            chrome-gnome-shell \
            gnome-tweak-tool
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/KaizIqbal/Bibata_Cursor/master/Bibata.sh)"
        for ext in $(gnome-extensions list); do
            gnome-extensions enable $ext
        done
    fi

    if [ "$DOTFILES_CONF_google" = "true" ]; then
        snap install --classic google-cloud-sdk
    fi

    if [ "$DOTFILES_CONF_slack" = "true" ]; then
        snap install --classic slack
    fi

    if [ "$DOTFILES_CONF_code" = "true" ]; then
        snap install --classic code
    fi

    if [ "$DOTFILES_CONF_kubectl" = "true" ]; then
        snap install --classic kubectl
        setup_binary_env "yuya-takeyama/helmenv"
    fi

    if [ "$DOTFILES_CONF_spotify" = "true" ]; then
        snap install spotify
    fi

    if [ "$DOTFILES_CONF_digitalocean" = "true" ]; then
        snap install doctl
    fi

    for app in fasd; do
        if ! snap list | grep "${app}"
        then
            snap install --beta "${app}"
        fi
    done

    if [ "$DOTFILES_CONF_gitlab" = "true" ]; then
        snap install --edge glab
        snap connect glab:ssh-keys
        glab alias set get-variable 'glab api /projects/:id/variables/$1 | jq .value' --shell
    fi

    if [ "$DOTFILES_CONF_golang" = "true" ]; then
        setup_binary_env "syndbg/goenv"
    fi

    if [ "$DOTFILES_CONF_terraform" = "true" ]; then
        setup_binary_env "tfutils/tfenv"
        $HOME/.tfenv/bin/tfenv install
    fi

    if [ "$DOTFILES_CONF_github" = "true" ]; then
        # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install -y gh
    fi

    install_fonts
}

function install_osx_extras {
    brew tap homebrew/cask-fonts
    if [ "$DOTFILES_CONF_spotify" = "true" ]; then
        brew install --cask spotify
    fi
    if [ "$DOTFILES_CONF_code" = "true" ]; then
        brew install --cask visual-studio-code
    fi
    if [ "$DOTFILES_CONF_google" = "true" ]; then
        brew install --cask google-cloud-sdk
    fi
    if [ "$DOTFILES_CONF_slack" = "true" ]; then
        brew install --cask slack
    fi
    for p in iterm2 font-hack-nerd-font
    do
        brew install --cask $p
    done
    if [ "$DOTFILES_CONF_digitalocean" = "true" ]; then
        brew install doctl
    fi
    if [ "$DOTFILES_CONF_kubectl" = "true" ]; then
        brew install kubernetes-cli
        brew install helm
        setup_binary_env "yuya-takeyama/helmenv"
    fi
    if [ "$DOTFILES_CONF_golang" = "true" ]; then
        brew install goenv
    fi
    if [ "$DOTFILES_CONF_terraform" = "true" ]; then
        brew install tfenv
    fi
    if [ "$DOTFILES_CONF_github" = "true" ]; then
        brew install gh
    fi
    if [ "$DOTFILES_CONF_gitlab" = "true" ]; then
        brew install glab
        glab alias set get-variable 'glab api /projects/:id/variables/$1 | jq .value' --shell
    fi

    if [ "$DOTFILES_CONF_uber" = "true" ]; then
        brew install poppler
        brew install pdftk
    fi

    for p in gnupg2 pinentry-mac neovim zsh fasd trash-cli libusb docker neovim trash-cli xclip coreutils gnu-sed
    do
        brew install $p
    done
    if ! cat ~/.gnupg/gpg-agent.conf | grep -q /usr/local/bin/pinentry-mac; then
        echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    fi
}

function install_osx_standard {
    if ! brew --version; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    for p in python curl; do
        brew install $p
    done
    (
        cd /tmp
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        python3 get-pip.py
        rm get-pip.py
    )
}

if apt-get --version &> /dev/null; then
    install_debian_standard
elif uname -a | grep -iq darwin; then
    install_osx_standard
fi

if [ ! -d  "venv" ]; then
    python3 -m venv venv
    source venv/bin/activate
    pip3 install --upgrade -r requirements.txt
fi

if apt-get --version &> /dev/null; then
    install_debian_extras
elif uname -a | grep -iq darwin; then
    install_osx_extras
fi

chsh -s $(which zsh)

if [ ! -d "~/.zinit" ]; then
    mkdir ~/.zinit
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

curl -L https://cht.sh/:cht.sh > ~/bin/cht.sh
sudo chmod -x ~/bin/*

if [ "$DOTFILES_CONF_kubectl" = "true" ]; then
    (
        cd "$(mktemp -d)" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" &&
        tar zxvf krew.tar.gz &&
        KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
        "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
        "$KREW" update
    )
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
    for plugin in ctx ns tree; do
        kubectl krew install $plugin
    done

fi

if [ "$DOTFILES_CONF_node" = "true" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi

if [ "$DOTFILES_CONF_grub" = "true" ]; then
    wget -O - https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash
fi

if [ "$DOTFILES_CONF_git" = "true" ]; then
    git config --global include.path "$PWD/global.gitconfig"
    git config --global core.excludesfile "$PWD/global.gitignore"
    if [ "$(whoami)" = "mlodzikos" ] || [ "$(whoami)" = "mikolajmlodzikowski" ]; then
        git config --global user.name "Mikołaj Młodzikowski"
        git config --global user.email "mikolaj.mlodzikowski@gmail.com"
    fi
fi

if [ "$DOTFILES_CONF_code_extensions" = "true" ]; then
    for extension in $(cat installed_vs_extensions); do
        code --install-extension $extension
    done
fi

if [ "$DOTFILES_CONF_cloudflare" = "true" ]; then
    go get -u github.com/cloudflare/cloudflare-go/...
fi