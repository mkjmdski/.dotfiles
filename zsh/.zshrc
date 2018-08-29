function _log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}

## INIT
export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory
for file in $DOTFILES/zsh/.init/*.zsh; do
    source "${file}"
done

## CONFIGURE LOADS
# ZPLUG_UPDATE=true
# BREW_UPDATE=true
# GEMS_UPDATE=true

## LOAD ZPLUG
if [ ! -d ~/.zplug ]; then
    git clone --depth=1 https://github.com/zplug/zplug ~/.zplug;
fi
export ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
source ~/.zplug/init.zsh
zplug load
if [ "$ZPLUG_UPDATE" = true ] ; then
    zplugs_install
#     zplug update
fi

## LOAD BREW
if [ "$BREW_UPDATE" = true ] ; then
    brews_install
    # brew update
fi

## LOAD GEMS
if [ "$GEMS_UPDATE" = true ] ; then
    gems_install
    # gem update --user-install
fi

for file in $DOTFILES/zsh/.postload/*.zsh; do
    source "${file}"
done