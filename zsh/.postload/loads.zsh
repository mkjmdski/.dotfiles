
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi

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

source $(dirname $(gem which colorls))/tab_complete.sh