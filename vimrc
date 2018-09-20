set nocompatible

let mapleader=","

nmap t <Esc>:tabnext<CR>
nmap T <Esc>:tabprev<CR>
nmap b <Esc>:bnext<CR>
nmap B <Esc>:bprev<CR>

nnoremap ; :

" Configure backspace behaviour
set backspace=indent,eol,start

" Map C-z to C-n (allows it to be overriden to C-x C-o - Omnicomplete - in
" some files)
inoremap <C-z> <C-n>

" Set complete options
setlocal completeopt=longest,menuone

fun! ShouldAutocomplete()
    return pumvisible() || !(strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$')
endfun

" Map tab to C-z (custom autocomplete) if autocomplete menu is open or there
" is already text on the current line
imap <expr> <Tab> ShouldAutocomplete() ? '<C-z>' : '<Tab>'
imap <expr> <Up> pumvisible() ? '<C-p>' : '<Up>'
imap <expr> <Down> pumvisible() ? '<C-n>' : '<Down>'

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

highlight Constant ctermfg=1
highlight Statement ctermfg=3
highlight Visual cterm=reverse ctermbg=black
highlight SpellBad cterm=reverse ctermfg=9 ctermbg=15
highlight Pmenu ctermfg=15 ctermbg=17
highlight PmenuSel ctermfg=11 ctermbg=21
highlight Search ctermbg=52
highlight CursorLine cterm=none

" Change line number colours to indicate mode
function! InsertModeChanged(mode)
   if a:mode == 'i'
        highlight LineNr ctermfg=45
        highlight CursorLineNr ctermfg=33
    elseif a:mode == 'r'
        highlight LineNr ctermfg=202
        highlight CursorLineNr ctermfg=196
    else
        highlight LineNr ctermfg=244
        highlight CursorLineNr ctermfg=238
    endif
endfunction


autocmd InsertEnter * call InsertModeChanged(v:insertmode)
autocmd InsertLeave * call InsertModeChanged('')
call InsertModeChanged('')

command Q wqa
command W w " I keep accidentally typing W instead of w
cnoreabbrev T tabedit

inoremap <buffer> <C-y>; <Esc>:call AppendSemicolon()<CR>li

fun! AppendSemicolon()
    let cur_col = col('.')
    let cur_line = line('.')
    execute 'normal! A;'
    call cursor(cur_line, cur_col)
endfun

" Airline config
let g:airline#extensions#tabline#enabled = 1

" CtrlP config
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
