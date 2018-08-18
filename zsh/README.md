# ZSH

## Requirements

* `glances` - `pip3` binary in $PATH
* `taskwarrior` - `gcc`, `make`, `cmake`

## Configuration

This ZSH configuration is based on [zplug](https://github.com/zplug/zplug) and [oh-my-zsh library](https://github.com/robbyrussell/oh-my-zsh/library). It's aimed mostly for development-orientated DevOps engineers to support many languages, tools and fast navigation around system, but it shall be fairly easy to fork this repository and adjust plugins for other needs.

## Plugins

All of the plugins and external tools are collected in `.zplugs.zsh`:

* [jq](https://github.com/stedolan/jq) - parsing json tool
* [cloc](https://github.com/AlDanial/cloc) - counts code lines inside the project, usefull during refactors
* [peco](https://github.com/peco/peco) - interactive grep for user, usefull when reading large outputs
* [cd-gitroot](https://github.com/mollifier/cd-gitroot) - navigates to root of the git repository
* [extract](https://github.com/robbyrussell/oh-my-zsh/plugins/extract) - allows using `x` to extract any archive
* [jump](https://github.com/robbyrussell/oh-my-zsh/plugins/jump) - allows marking directories and jumping to them around filesystem
* [taskwarrior](https://github.com/GothenburgBitFactory/taskwarrior) - task manager with timetracking functions. Awesome tool when working for various projects at the same time. It's compiled from source thus the first setup with this plugin activated can take some time!
* [exa](https://github.com/ogham/exa) - improved `ls` with extra colours for readability
* [gopass](https://github.com/gopasspw/gopass) - [pass](https://github.com/peff/pass) implementation in go. Supports storing passwords on git backend with encryption. Access to secrets is based on GPG keyrings. Perfect tools for teams or configuration shared accross computers.
* [glances](https://nicolargo.github.io/glances/) - is a modern `top` tool with many features based on python. Due to that it's **the** only plugin which is installed from pip instead of zplug. It's installation line is kept inside `.zshrc`

## Themes

Before loading zplug in `.zshrc` add variable called `ZSH_THEME` if you want to include basic theme which doesn't require extra configuration. If you want to load something more complex you should use `ZSH_CUSTOM_THEME` variable and later you have to write specific configuration inside `.zplugs.zsh` as I did for:

* [spaceship prompt](https://github.com/denysdovhan/spaceship-prompt) - probably the best minimalistic theme for zsh
* [powerlevel9k](https://github.com/bhilburn/powerlevel9k) - probably the best non-minimalistic theme for zsh

Some of themes need [powerline fonts](https://github.com/powerline/fonts) to work correctly. Install them following the link or run `./install.sh --install-powerline-fonts`

## Autocompletions and typing commands

Probably the best part of using ZSH are autocompletions and utilities for increasing command typing time. I included three very important features for that:

1. [colored man pages](https://github.com/robbyrussell/oh-my-zsh/plugins/colored-man-pages) - that plugin from oh-my-zhs helps in viewing man pages. You can find your informations way easier.
2. [autosuggetsions](https://github.com/zsh-users/zsh-autosuggestions) - this tool remembers commands typed eariler simillar to one which is currently typed. It allows you to enter faster frequently used commands.
3. [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - this tool highlights zsh syntax typed during your session. With this you can easily notice your misstypes.

Remember that autocompletions slow down startup of your shell, due that my autocompletions are checking if necessary binary exists in the system before loading:

* docker
* docker-compose
* terraform

## $PATH

`.zshrc` is the place where you should be loading and extending your path. I already did that for binaries installed by:

* go
* yarn
* and those included inside `$HOME/bin` and `$HOME/.local/bin`