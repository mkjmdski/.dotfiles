#!/bin/zsh

#### GO TO DIRECTORY BY TYPING IT'S NAME
setopt auto_cd

#### COMPLETION COLORS
eval $(gdircolors $DOTFILES/.dir_colors)
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
