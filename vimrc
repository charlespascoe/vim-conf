set nocompatible
set hidden

let mapleader=","

nmap t <Esc>:tabnext<CR>
nmap T <Esc>:tabprev<CR>
nmap b <Esc>:bnext<CR>
nmap B <Esc>:bprev<CR>

nnoremap ; :

" Configure backspace behaviour
set backspace=indent,eol,start

" Ctrl-a saves all
inoremap <C-a> <Esc>:wa<CR>
nnoremap <C-a> <Esc>:wa<CR>

filetype plugin indent on

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

autocmd BufWritePre * :%s/\s\+$//e " Removes trailing whitespace
syntax enable

command Q wqa

source ~/.vim-conf/autocomplete.vim
source ~/.vim-conf/colours.vim
source ~/.vim-conf/plugin-config.vim
