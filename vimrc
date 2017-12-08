set nocompatible

map t :tabnext<CR>
map T :tabprev<CR>

filetype plugin indent on

set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set expandtab     " insert spaces when hitting TABs
set nowrap
autocmd BufWritePre * :%s/\s\+$//e " Removes trailing whitespace
syntax enable

highlight Pmenu ctermfg=15 ctermbg=17
highlight PmenuSel ctermfg=11 ctermbg=21
highlight Search ctermbg=52

set number

" Code Folding
set nofoldenable
set foldmethod=syntax
map <Space> za
