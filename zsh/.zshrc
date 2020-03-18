export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory

fpath=($fpath $DOTFILES/zsh/fpath)

for file in $DOTFILES/zsh/.init/*.zsh; do
    source "${file}"
done

export ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
source ~/.zplug/init.zsh
zplug load

for file in $DOTFILES/zsh/.postload/*.zsh; do
    source "${file}"
done
fpath=($DOTFILES/zsh-completions/src $fpath)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C ~/bin/tfschema tfschema
complete -o nospace -C "${HOME}/.tfenv/versions/$(cat /home/mlodzikos/.tfenv/version)/terraform" terraform
