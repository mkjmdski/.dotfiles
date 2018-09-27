#!/bin/zsh

export EDITOR="$( echo $(which vim) || echo $(which vi) )"
export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
export LANG=en_US.UTF-8 # Default language
export PAGER="most"

#### GO TO DIRECTORY BY TYPING IT'S NAME
setopt auto_cd

#### COMPLETION COLORS
eval $(gdircolors $DOTFILES/.dir_colors)
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

#### HISTORY SEARCH
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=cyan,fg=white,bold"

#### GOPASS COMPLETE
if [[ $commands[gopass] ]]; then
    source <(gopass completion zsh | tail -n +2 | sed \$d)
    compdef _gopass gopass
fi

#### LOAD AUTOJUMP
if [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then
    source $HOME/.autojump/etc/profile.d/autojump.sh;
    autoload -U compinit && compinit -u
fi
