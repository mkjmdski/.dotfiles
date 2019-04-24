if [ -d "${HOME}/google-cloud-sdk" ]; then
    . $HOME/google-cloud-sdk/completion.zsh.inc
    . $HOME/google-cloud-sdk/path.zsh.inc
elif [ -d "/opt/google-cloud-sdk" ]; then
    . /opt/google-cloud-sdk/completion.zsh.inc
    . /opt/google-cloud-sdk/path.zsh.inc
fi

#### LOAD AUTOJUMP
if [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then
    source $HOME/.autojump/etc/profile.d/autojump.sh;
fi
if [[ -f /usr/share/autojump/autojump.sh ]]; then
    . /usr/share/autojump/autojump.sh
fi
if [[ -f  /etc/profile.d/autojump.zsh ]]; then
    source /etc/profile.d/autojump.zsh
fi
