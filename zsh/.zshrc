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
