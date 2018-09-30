function _log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}

## INIT
export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory
for file in $DOTFILES/zsh/.init/*.zsh; do
    source "${file}"
done

## LOAD ZPLUG
if [ ! -d ~/.zplug ]; then
    git clone --depth=1 https://github.com/zplug/zplug ~/.zplug;
fi

export ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
source ~/.zplug/init.zsh
zplug load

for file in $DOTFILES/zsh/.postload/*.zsh; do
    source "${file}"
done
