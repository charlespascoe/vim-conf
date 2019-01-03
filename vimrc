set nocompatible
filetype plugin indent on

let mapleader="\\"

set wildignore+=*.class

" Configure backspace behaviour
set backspace=indent,eol,start

" Default tab settings
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set expandtab     " insert spaces when hitting TABs

" Text behaviour
set nowrap
set nostartofline " when switching between buffers (and certain commands), preserve cursor column position

" Line numbering
set number
set relativenumber

" Search configuration
set incsearch

" Disable arrow keys in normal mode (force hkjl)
nmap <Up> <Nop>
nmap <Down> <Nop>
nmap <Left> <Nop>
nmap <Right> <Nop>

" Disable Page Up/Down
map <PageUp> <Nop>
map <PageDown> <Nop>

" External files
source ~/.vim-conf/utils.vim
source ~/.vim-conf/buffer-management.vim
source ~/.vim-conf/autocomplete.vim
source ~/.vim-conf/colours.vim
source ~/.vim-conf/plugin-config.vim
source ~/.vim-conf/find.vim
