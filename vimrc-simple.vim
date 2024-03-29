set nocompatible
filetype plugin indent on
let mapleader=" "
set hidden
set number
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set autoindent
set expandtab
set nowrap
set nowrapscan
set nohlsearch
set incsearch
set splitright
set nostartofline
inoremap <C-s> <Esc>:keepjumps wa<CR>
nnoremap <C-s> <Esc>:keepjumps wa<CR>
nmap <silent> <leader><space> <Cmd>b#<CR>zz
