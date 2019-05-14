set nocompatible
filetype plugin indent on

let mapleader="\\"

set wildignore+=*.class

" Configure backspace behaviour
set backspace=indent,eol,start

" Default tab settings
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set expandtab     " insert spaces when hitting TABs

" Text behaviour
set nowrap
set nostartofline " when switching between buffers (and certain commands), preserve cursor column position

" Reads config from first few lines of file
set modeline

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
