execute pathogen#infect()

set nocompatible
filetype plugin indent on

if &diff
    syntax off
endif

let mapleader=" "

packadd! matchit

let b:match_words = ''

" Match Git conflict boundaries
au BufReadPost * let b:match_words .= '^<\{7}:^=\{7}:^>\{7},'

" Set cursor style
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" Keycode and mapping timeouts
set timeout timeoutlen=1000 ttimeout ttimeoutlen=0

" Set global formatting options, primarily for comments
set formatoptions=crqjn
set textwidth=80
set formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*\\\|^\\s*-\\s*

" Allow the cursor to go past the last character
set ve+=onemore

" Reload files when they change outside of Vim
set autoread

" Enable lazy redraw (waits until mappings/macros have finished before
" redrawing, speeds up macros and prevents flashing)
set lazyredraw

set wildignore+=*.class

" Configure backspace behaviour
set backspace=indent,eol,start

" Default tab settings
set tabstop=4     " a hard TAB displays as 4 columns
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE"
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
set nowrapscan    " prevents wrapping around to top of file when searching

" Highlight the 81st column (for character limit)
" (&ma is true if the current buffer is modifiable)
autocmd BufNewFile,BufRead * exec "setlocal colorcolumn=".(&ma ? "81" : "0")

" Set spell correction language
set spelllang=en_gb
set nospell " Off by default, turned on by relevant file types
set spellfile=~/.vim/spell/en.utf-8.add

" See spell-sug-file for how the word suggestions are loaded

" Convenience map for picking best alternative
nmap <leader>k 1z=
nmap <expr> <leader>gs &l:spell ? '<Cmd>setlocal nospell<CR>' : '<Cmd>setlocal spell<CR>'

" Custom vertical split char
set fillchars+=vert:│

" Custom indent marker
set listchars=tab:│\  list

" Enable mouse control (useful for scrolling and resizing)
set mouse=a
set ttymouse=xterm2

" Disable octal increment (annoying when dealing with telephone numbers)
set nrformats-=octal

" Disable middle click paste
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

" Disable 'Q' from leaving visual mode
map Q <Nop>

nmap K <Nop>

" Set options to improve syntax highlighing performance
set re=2

" Set window split options
set splitright " For vertical splits, the cursor will be on the right pane
set splitbelow " For horizontal splits, the cursor will be on the bottom pane

" Disable folding (interferes with vim-go)
set nofoldenable

" Set shell for shell-based commands
set shell=/bin/zsh

" Initialise Dictation
call dictate#Init()

" External files
source ~/.vim-conf/utils.vim
source ~/.vim-conf/buffer-management.vim
source ~/.vim-conf/autocomplete.vim
source ~/.vim-conf/colours.vim
source ~/.vim-conf/plugin-config.vim
source ~/.vim-conf/find.vim
source ~/.vim-conf/bulletnotes.vim
source ~/.vim-conf/templates.vim
