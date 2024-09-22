source ~/.vim-conf/bundle.vim

if isdirectory($HOME..'/.vim-local')
    set rtp+=$HOME/.vim-local
endif

set encoding=utf-8

packadd cfilter

set nocompatible
filetype plugin indent on

if &diff
    syntax off
endif

let mapleader=" "

" Set cursor style
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" Title

fun s:SetTitle()
    if $MAN
        if &ft != 'man'
            return
        endif

        let l:match = matchstr(getline(1), '^\c[a-z]\+')

        if l:match != ''
            let &titlestring = tolower(l:match)
            return
        endif
    endif

    let l:path = bufname()
    " The -1 argument to getcwd() returns the global working directory
    let l:cwd = getcwd(-1)

    if l:path == '' || (isdirectory('.git') && s:startswith(fnamemodify(l:path, ':p'), l:cwd))
        let l:path = l:cwd
    endif

    let l:path = fnamemodify(l:path, ':~')

    if s:startswith(l:path, '~/go/src')
        let &titlestring = substitute(l:path, '^\~/go/src', 'go', '')
    elseif s:startswith(l:path, '~/repos')
        let &titlestring = substitute(l:path, '^\~/repos', 'repos', '')
    elseif s:startswith(l:path, '~/.vim-conf')
        let &titlestring = substitute(l:path, '^\~/\.vim-conf', 'vim-conf', '')
    else
        let &titlestring = pathshorten(l:path)
    endif
endfun

fun s:startswith(str, prefix)
    if len(a:str) < len(a:prefix)
        return 0
    endif

    return a:str[:len(a:prefix)-1] == a:prefix
endfun

set title
call s:SetTitle()
au DirChanged,BufEnter,FileType * call <SID>SetTitle()

" Terminal support for more underline support (4:1m is normal underline)

let &t_Ce = "\e[4:0m" " Extended underline end
let &t_Us = "\e[4:2m" " Double unerline
let &t_Cs = "\e[4:3m" " Undercurl
let &t_ds = "\e[4:4m" " Dotted underline (not sure if Alacritty/tmux support this)
let &t_Ds = "\e[4:5m" " Dashed underline

" Cursor hold timeout (e.g. for autocommands and swap file)
set updatetime=2000

" Keycode and mapping timeouts
set timeout timeoutlen=1000 ttimeout ttimeoutlen=0

" Set global formatting options, primarily for comments
set formatoptions=crqj
set textwidth=80
set formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*\\\|^\\s*-\\s*

" Allow the cursor to go past the last character
set ve+=onemore

" Persistent undo and Backups
set undolevels=100
set undodir=~/.undo
set noundofile " Ensure off by default, enable for specific files


au BufRead *.bak set filetype=bak
let g:backup_dir = expand('~/.backup/')..strftime('%Y-%m')..'/'
call system('mkdir -p '..shellescape(g:backup_dir))

au FileType asciidoctor,bash,go,help,html,javascript,json,make,markdown,python,robot,sh,swift,text,tmux,typescript,vim,yaml,zsh call RegisterBackup()

fun! RegisterBackup()
    let l:path = expand('%:p')
    if !s:startswith(l:path, '/private/var/folders') && !s:startswith(l:path, '/Volumes/') && getfsize(l:path) < 500000 " 500KB
        setlocal undofile
        au BufWritePost <buffer> call system('cp '..shellescape(expand('%:p'))..' '..shellescape(g:backup_dir..substitute(expand('%:p'), '/', '%', 'g')..'.'..strftime('%Y-%m-%d_%H%M')..'.bak'))
    endif
endfun

" Reload files when they change outside of Vim
set autoread

" Enable lazy redraw (waits until mappings/macros have finished before
" redrawing, speeds up macros and prevents flashing)
set lazyredraw

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
set nostartofline    " when switching between buffers (and certain commands), preserve cursor column position
set sidescroll=1     " moves sideways by one character when the cursor reachs the edge of the window
set sidescrolloff=10 " ensures at least 10 characters are visible ahead of the cursor on long lines
set scrolljump=10
set listchars=extends:…

" Enable mouse control (useful for scrolling and resizing)
set mouse=a
set ttymouse=sgr

" See plugin/mousefix.vim for more mouse behaviour tweaks

set linebreak showbreak=\ \ ↪\  breakindent

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
autocmd BufNewFile,BufReadPost * exec "setlocal colorcolumn=".((&ma && &textwidth > 0) ? &textwidth+1 : "0")
autocmd OptionSet textwidth exec "setlocal colorcolumn=".((&ma && &textwidth > 0) ? &textwidth+1 : "0")

" Set spell correction language
set spelllang=en_gb
set nospell " Off by default, turned on by relevant file types
" The second is a local spell file for host-specific spellings
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim-local/spell/en.utf-8.add
set spellsuggest=best,file:~/.vim/spell/suggestions

" See spell-sug-file for how the word suggestions are loaded

" Convenience map for picking best alternative
nmap <leader>c 1z=

" Custom vertical split char
set fillchars+=vert:│

" Set number formatting options for increment/decrement (not octal - it's
" annoying when dealing with telephone numbers)
set nrformats=alpha,hex,bin,unsigned

" Disable middle click paste
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

" Disable Ex mode (I barely use this)
map Q <Nop>

" Set window split and resize options
set splitright " For vertical splits, the cursor will be on the right pane
set splitbelow " For horizontal splits, the cursor will be on the bottom pane
set eadirection=hor " Only automatically resize horizontally, leave height the same

" Set shell for shell-based commands
set shell=/bin/zsh

" Enable viewing man pages in Vim
runtime ftplugin/man.vim
set keywordprg=:Man
let g:ft_man_open_mode = 'vert'

" Open file where it was last edited
" (see :help restore-cursor)
" TODO: Check interaction with vim-obsession
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

" automatically creates parent directories.

function s:mkdirs(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir = fnamemodify(a:file, ':h')
        " if !isdirectory(dir) && input('Create directory '.dir.'? [y/N] ') =~? '^y'
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

autocmd BufWritePre * call s:mkdirs(expand('<afile>'), +expand('<abuf>'))

autocmd VimEnter * normal! zz

" Initialise Dictation
if !empty(glob('/tmp/dictation.sock'))
    au VimEnter * call dictation#Init()
endif

let s:bulletnotes_backup = v:true

if exists('$BN_PROJ') && $BN_PROJ == '1'
    let s:bulletnotes_backup = v:false
    call bulletnotes#InitProject()
elseif isdirectory('.bnproj')
    let b:bulletnotes_autosync = v:false
    call bulletnotes#InitProject()
endif

" TODO: Is there a better way to do this?
if s:bulletnotes_backup
    au FileType bulletnotes call RegisterBackup()
endif

" Support for Option-key mappings
exec "set <A-c>=\ec"

" External files
source ~/.vim-conf/utils.vim
source ~/.vim-conf/autocomplete.vim
source ~/.vim-conf/colours.vim
source ~/.vim-conf/plugin-config.vim
