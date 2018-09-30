function _log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}

## INIT
export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory
for file in $DOTFILES/zsh/.init/*.zsh; do
    source "${file}"
done

## CONFIGURE INSTALLS
# INSTALL=true
# ZPLUG_INSTALL=true
# BREW_INSTALL=true
# GEMS_INSTALL=true
# PYTHON_INSTALL=true


## LOAD ZPLUG
if [ ! -d ~/.zplug ]; then
    git clone --depth=1 https://github.com/zplug/zplug ~/.zplug;
fi

export ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
source ~/.zplug/init.zsh
zplug load

if [ "$ZPLUG_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    source "$DOTFILES/zsh/.zplugs_to_install_once.zsh"
    zplugs_install
fi

## LOAD BREW
if [ "$BREW_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    brew_install
fi

## LOAD GEMS
if [ "$GEMS_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    gems_install
fi

if [ "$PYTHON_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    pip_install
fi

if [ "$YARN_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    yarn_install
fi

for file in $DOTFILES/zsh/.postload/*.zsh; do
    source "${file}"
done