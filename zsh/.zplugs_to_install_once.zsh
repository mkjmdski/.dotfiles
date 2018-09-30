#### THOSE BINARIES REQUIRE SETUP ONLY ONCE
#### YOU CAN FIND RELEASE FUNCTION AND INSTALLERS IN zsh/.init/
## !! IMPORTANT !! ##
## !! DON'T USE `hook-loads` IN HERE !! ##
####
#### HELPERS FOR ZPLUG
function _gopass_release {
    if [ "$(uname)" = "Linux" ]; then
        echo '*linux*amd64*tar.gz'
    else
        echo '*darwin*'
    fi
}
function _fd_release {
    if [ "$(uname)" = "Linux" ]; then
        echo "fd*x86_64*unkown*gnu*"
    else
        echo "*darwin*"
    fi
}
function _noti_release {
    if [ "$(uname)" = "Linux" ]; then
        echo "noti*linux*"
    else
        echo "*noti*darwin*"
    fi
}

function _autojump_install {
    ./install.py
}

#### PARSING OUTPUTS
zplug "stedolan/jq", from:gh-r, as:command
zplug "peco/peco", from:gh-r, as:command

#### INTELIGENT PATH CHANGING
zplug "wting/autojump", as:command, hook-build:"_autojump_install 2> /dev/tty"

#### PASSWORD MANAGING IN GOPASS
zplug "gopasspw/gopass", from:gh-r, use:"$(_gopass_release)", as:command

#### DIFF TOOL FOR GIT
zplug "jeffkaufman/icdiff", use:icdiff.py, rename-to:icdiff, as:command

#### CHEAT SHEAT
zplug "chubin/cheat.sh", use:"share/cht.sh.txt", as:command, rename-to:cht.sh

#### FIND TOOLS
zplug "sharkdp/fd", from:gh-r, as:command

#### NOTIFY AFTER EVENT IS DONE
zplug "variadico/noti", from:gh-r, as:command, use:"$(_noti_release)"

zplug "jarun/googler", use:"googler", as:command