# ZSH

## Requirements

* `gawk` - for ubuntu
* `Python v2.6+ except v3.2` - for autojump

## Configuration

This ZSH configuration is based on [zplug](https://github.com/zplug/zplug) and [oh-my-zsh library](https://github.com/robbyrussell/oh-my-zsh/library). It's aimed mostly for development-orientated DevOps engineers to support many languages, tools and fast navigation around system, but it shall be fairly easy to fork this repository and adjust plugins for other needs.

## Files

* `.zshrc` - main file to load the rest, exports system variables, extends path
* `.zplugs.zsh` - configuration of github integrated binaries and themes.
* `aliases.zsh` - aliases which override default os programs with installed binaries (include ls)
* `configuration.zsh` - contains all snippets which configure ZSH or its libraries
* `functions.zsh` - functions for more complex shell operations which are often repeated
* `updates.zsh` - contains functions which are helpers to zplug, updates brew and gems list in array

## Binaries

All of the binaries are collected in `.zplugs.zsh`, `Brewfile` and gems array in `updates.zsh`. They need to be loaded once so they have separated functions for that included in file called `updates.zsh`.

### ZPlugs

Run `update_zplugs` to update those binaries (or add them to the path if you lost them by accident from `$ZPLUG_HOME`)

* [`jq`](https://github.com/stedolan/jq) - parsing json tool
* [`cloc`](https://github.com/AlDanial/cloc) - counts code lines inside the project, usefull during refactors
* [`peco`](https://github.com/peco/peco) - interactive grep for user, usefull when reading large outputs
* [`autojump`](https://github.com/wting/autojump) - allows marking directories and jumping to them around filesystem
* [`exa`](https://github.com/ogham/exa) - improved `ls` with extra colours for readability
* [`gopass`](https://github.com/gopasspw/gopass) - [pass](https://github.com/peff/pass) implementation in go. Supports storing passwords on git backend with encryption. Access to secrets is based on GPG keyrings. Perfect tools for teams or configuration shared accross computers.
* [`ranger`](https://github.com/ranger/ranger) - file manager with vim commands
* [`icdiff`](https://github.com/jeffkaufman/icdiff) - diff tool used by my git
* [`ccat`](https://github.com/jingweno/ccat) - cats files but with syntax highlighting
* [`cheat.sh`](https://github.com/chubbin/cheat.sh) - type cht.sh and your doubts to find useful code snippets.
* [`fd`](https://github.com/sharkdp/fd) - smart search for files (works like find)

### Brew binaries

[Brew](https://brew.sh) is installed together with zsh and for linux computers [linuxbrew](https://linuxbrew.sh/) port is used. Run `update_brew` to install programs from dotfiles Brewfile repo.

* [`fuck`](https://github.com/nvbn/thefuck) - corrects your last typo
* `most` - colors your manpages
* [`the silver searcher`](https://github.com/ggreer/the_silver_searcher) - works like grep, but you don't have to be pro to use it
* `highlight` - allows ranger to highlight files while browsing
* `coreutils` - necessary to get autocompletes colorful

### Ruby gems

Run `update_gems` to install/update gems specified below. Gems are installed to user directory (not global).

* [`colorls`](https://github.com/athityakumar/colorls) - colors your ls, adds tree and nerdfonts

## Plugins

Plugins are loaded on each shell spawn and extend its functionality. All of them are maintained by ZPlug:

* [`extract`](https://github.com/robbyrussell/oh-my-zsh/plugins/extract) - allows using `x` to extract any archive
* [`autosuggestions`](zsh-users/zsh-autosuggestions) - shows suggestions based on you have typed before in the shell
* [`syntax highlighting`](zsh-users/zsh-syntax-highlighting) - highlights syntax of zsh commands, useful in creating inline loops
* [`history substring search`](zsh-users/zsh-history-substring-search) - you can browse history excluding resultats which do not match what you typed currently in the shell

## Themes

Before loading zplug in `.zshrc` add variable called `ZSH_THEME` if you want to switch from my default [spaceship prompt](https://github.com/denysdovhan/spaceship-prompt). Add theme configuation to hook load.

## $PATH

`.zshrc` is the place where you should be loading and extending your path. I already did that for binaries installed by:

* go get binaries
* yarn global binaries
* user ruby gems
* linuxbrew binaries
* `$HOME/bin` and `$HOME/.local/bin`