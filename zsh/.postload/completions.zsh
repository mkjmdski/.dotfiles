# Get completion above command line
setopt list_types
setopt complete_in_word
unlimit

pids4kill() {
    local -a ps

    if [[ $oldcontext = *:sudo:* ]]
    then
        local u=$opt_args[-u]
        if [[ -n $u ]]
        then
            ps=(ps -u $u)
        else
            ps=(ps -A)
        fi
    else
        ps=(ps -u $USER)
    fi
    $ps -o pid,%cpu,tty,cputime,cmd
}

man_glob () {
    local a
    read -cA a
    if [[ $a[2] = [0-9]* ]] then  # BSD section number
        reply=( $^manpath/man$a[2]/$1*$2(N:t:r) )
    elif [[ $a[2] = -s ]] then    # SysV section number
        reply=( $^manpath/man$a[3]/$1*$2(N:t:r) )
    else
        reply=( $^manpath/man*/$1*$2(N:t:r) )
    fi
}
compctl -K man_glob man
compctl -k hostnames ping telnet ftp nslookup ssh traceroute mtr scp ncftp

# Complete commmands after .
compctl -c .

zmodload -i zsh/complist
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

# extend fpath
fpath=($fpath $DOTFILES/zsh/fpath)

### OPTIONS
# use fd instead of find to populate files
export FZF_DEFAULT_COMMAND='fd --hidden --type f --type l --exclude ".git"'

# customize colors to blend in with my own highlight.zsh theme
export FZF_DEFAULT_OPTS='--no-bold --color=fg:7,fg+:3,bg:-1,bg+:-1,hl:6,hl+:6,prompt:8,pointer:3,marker:2'

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';


ZSHCAHCEDIR=/tmp/$USER-zsh-cache
zstyle ':completion:*' use-cache on
zstyle ':completion::complete:*' cache-path $ZSHCAHCEDIR/$HOST # Expand partial paths
zstyle ':completion:predict:*' completer _complete # Completion caching

zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort access
zstyle ':completion:*' list-suffixes true


zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' squeeze-slashes 'yes' # Include non-hidden directories in globbed file completions
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # Separate matches into groups
zstyle ':completion:*:matches' group 'yes' # Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b" # Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b' # Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

## Completion configuration
autoload -U compinit
compinit -u

if [[ $commands[terraform] ]]; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C $(which terraform) terraform
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi