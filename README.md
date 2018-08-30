# Dotfiles

## Short install

`bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkjmdski/.dotfiles/master/install.sh)"`

## Long install

clone the repository:

`git clone --depth=1 https://github.com/mkjmdski/.dotfiles.git $HOME/.dotfiles`

and run `install.sh` from modules directories you wish to install

## Article

I have also published article about this configuration in version 1.6 [check it out](https://blog.apptension.com/2018/08/30/shell-configuration-hack-your-zsh/)!

## About

Dotfiles repositories are great practice among developers, because we can share the way how we maintain creating stable cross-platform setups. This dotfile repository contains few modules where each one has got it's own README explaining what is kept inside VCS and why. Here is the short summary of them:

* git - global gitignore and git config integrated with external tools (icdiff, pycharm). Also some useful aliases
* tmux - minimal tmux configuration for people who don't have access to terminal emulators which allow splitting spanes in nice way.
* vim - minimal vim configuration to create this tool more friendly for beginners
* vscode - snippets, configuration and auto-generated extension list kept in repository
* zsh - zsh integrated with zplug and oh-my-zsh with many external binaries to speed up daily work of DevOps
* brew - brewfile with a few programs used by me

## Additional files

* .hooks - git hooks used to generate configuration files of this repository
* lib - shared shell code which helps in autoinstallation of configurations
