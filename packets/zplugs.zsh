#!/bin/zsh
function _gopass_completion {
    gopass completion zsh > "${DOTFILES}/zsh/fpath/_gopass"
}
function _autojump_install {
    ./install.py
}
function _zplugs_binaries_install {
    #### PARSING OUTPUTS
    zplug "peco/peco", from:gh-r, as:command
    #### INTELIGENT PATH CHANGING
    zplug "wting/autojump", as:command, hook-build:"_autojump_install 2> /dev/tty"
    #### PASSWORD MANAGING IN GOPASS
    zplug "gopasspw/gopass", from:gh-r, as:command, hook-build:"_gopass_completion"
    #### CHEAT SHEAT
    zplug "chubin/cheat.sh", use:"share/cht.sh.txt", as:command, rename-to:cht.sh
    #### FIND TOOLS
    zplug "sharkdp/fd", from:gh-r, as:command
    #### CAT WITH COLORS
    zplug "sharkdp/bat", from:gh-r, as:command
}
function zplugs_install {
    _zplugs_binaries_install
    _log_info "Checking zplugs..."
    if ! zplug check --verbose; then
        _log_info "Install zplugs? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
}
zplugs_install