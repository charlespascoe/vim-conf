set nocompatible
filetype plugin indent on

let mapleader=","

nnoremap ; :

set wildignore+=*.class

" Configure backspace behaviour
set backspace=indent,eol,start

set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set expandtab     " insert spaces when hitting TABs
set nowrap
set number
set cursorline
set showmatch
set incsearch

command! Trim %s/\s\+$//e

source ~/.vim-conf/utils.vim
source ~/.vim-conf/buffer-management.vim
source ~/.vim-conf/autocomplete.vim
source ~/.vim-conf/colours.vim
source ~/.vim-conf/plugin-config.vim
source ~/.vim-conf/find.vim
