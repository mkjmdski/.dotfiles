# auto menu complete
setopt auto_menu

# auto change directory
setopt auto_cd

#### HISTORY SEARCH
autoload history-search-end
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=cyan,fg=white,bold"
HIST_STAMPS="dd.mm.yyyy" ## OH-MY-ZSH
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_space # ignore when commands starts with space

# use brace
setopt brace_ccl

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`

# compacked complete list display
setopt list_packed

# multi redirect (e.x. echo "hello" > hoge1.txt > hoge2.txt)
setopt multios

setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
