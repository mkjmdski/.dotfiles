#### THOSE BINARIES REQUIRE SETUP ONLY ONCE
#### YOU CAN FIND RELEASE FUNCTION AND INSTALLERS IN zsh/.init/
## !! IMPORTANT !! ##
## !! DON'T USE `hook-loads` IN HERE !! ##
####
#### HELPERS FOR ZPLUG
function _exa_release {
    if [ "$(uname)" = "Darwin" ]; then
        echo '*macos*'
    else
        echo '*linux*'
    fi
}
function _gopass_release {
    if [ "$(uname)" = "Linux" ]; then
        echo '*linux*amd64*tar.gz'
    else
        echo '*darwin*'
    fi
}
function _ccat_release {
    if [ "$(uname)" = "Darwin" ]; then
        echo '*darwin*tar.gz'
    else
        echo '*linux*amd64*tar.gz'
    fi
}
function _fd_release {
    if [ "$(uname)" = "Linux" ]; then
        echo "fd*x86_64*unkown*gnu*"
    else
        echo "*darwin*"
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

#### VIM LIKE FILE MANAGER
zplug "ranger/ranger", use:ranger.py, rename-to:ranger, as:command

#### DIFF TOOL FOR GIT
zplug "jeffkaufman/icdiff", use:icdiff.py, rename-to:icdiff, as:command

#### CAT WITH SYNTAX HIGHLIGHTING
zplug "jingweno/ccat", from:gh-r, use:"$(_ccat_release)", as:command

#### CHEAT SHEAT
zplug "chubin/cheat.sh", use:"share/cht.sh.txt", as:command, rename-to:cht.sh

#### LS TOOLS
zplug "ogham/exa", from:gh-r, as:command, use:"$(_exa_release)"

#### FIND TOOLS
zplug "sharkdp/fd", from:gh-r, as:command, use:"$(_fd_release)"