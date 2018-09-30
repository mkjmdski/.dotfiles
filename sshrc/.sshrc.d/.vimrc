" Use Vim settings, rather than Vi settings
set nocompatible

" Show line numbers
set number

" Who wants an 8 character tab?  Not me!
set shiftwidth=4
set softtabstop=4

" Spaces are better than a tab character
set expandtab

" Replace all tabs with spaces inside the file
retab

" See your crazy vim ninja cmds
set showcmd

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Read file when modified outside Vim
set autoread

" Allow backspacing over everything in INSERT mode
set backspace=indent,eol,start

" Show ruler and command visual aid
set ruler

" Set partial search and result highlighting
set incsearch
set hlsearch

" Ignore case when searching
set ignorecase
set smartcase

" Show matching bracets
set showmatch

" Highlight the cursor line
set cursorline

" Set the colorscheme and window transparency
colorscheme molokai

" Make use of the "status line" to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward throught the list. This is called the "wild menu".
set wmnu

" Turn off beeping in errors
set vb
