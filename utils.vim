fun! FindProjectRoot(dir, indicator)
    if isdirectory(a:dir."/".a:indicator) || filereadable(a:dir."/".a:indicator)
        return a:dir
    el
        if a:dir == "/"
            return ""
        el
            return FindProjectRoot(fnamemodify(a:dir, ":h"), a:indicator)
        end
    end
endf

function! ShowHead()
    let l = line('.')
    Gvsplit HEAD:%
    execute l
    normal zz
endfunction

command! -nargs=1 -complete=help Help tab help <args>

command! ShowHead call ShowHead()

" Syntax highlighting debugging
map <leader>S <Cmd>echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

fun! PrintSyntaxDetails()
    let l:syn_stack = synstack(line("."),col("."))
    for l:syn_id in l:syn_stack
        echom synIDattr(l:syn_id, "name")
    endfor
endfun

map <leader><C-s> <Cmd>call PrintSyntaxDetails()<CR>

" Trim trailing whitespace
command! Trim %s/\s\+$//e

nmap <silent> <leader>T <Cmd>Trim<CR>``

" Jumping centres on cursor
nnoremap <expr> ` printf('`%czz', getchar())
nnoremap ]c <Plug>(GitGutterNextHunk)zz
nnoremap [c <Plug>(GitGutterPrevHunk)zz

" Jump to imports marker

noremap <leader>i `iO

" Add and jump to new line below while in insert mode (<C-Space>)
imap <expr> <C-@> match(getline('.'), '^\s\+$') ? '<C-o>o' : '<Enter>'

" Format JSON
command! FormatJson %!python3 -m json.tool

" This needs to be '<Esc>:' because it expects user input
noremap <leader>R <Esc>:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Edit macros

nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr>

" Quick Search
fun! QuickSearchMap(key, title, pattern)
    exec "nnoremap <silent> <buffer> <leader>s".a:key." :lvimgrep /".a:pattern."/ % \\| call setloclist(0, [], 'a', {'title': '".a:title."'}) \\| lopen<CR>"
endfun

" Make n and N move through location list when open
nnoremap <expr> n get(getloclist(0, {'winid':0}), 'winid', 0) ? '<Cmd>lnext<CR>zz' : 'nzz'
nnoremap <expr> N get(getloclist(0, {'winid':0}), 'winid', 0) ? '<Cmd>lprev<CR>zz' : 'Nzz'

" Normalise search operators (always center)
nnoremap * *zz
nnoremap # #zz

nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" Make Y consistent with C and D
nnoremap Y y$

" Confirm Spell Good

fun! ConfirmSpellGood()
    let l:word = expand('<cword>')
    let l:conf = input("Make '".l:word."' a good word? [y/N] ")
    return l:conf == 'y'
endfun

nnoremap <expr> <silent> zg ConfirmSpellGood() ? 'zg' : ''

" Attempts to fix syntax highlighting issues
" command SyntaxSync syntax sync fromstart

" This autocommand may cause performance issues
autocmd BufEnter,InsertLeave * :syntax sync fromstart

" Enter Improvements

nmap <Enter> i<Enter><Space><BS><Esc><Right>

" This prevents the above from interfering with quickfix and location lists
au FileType qf nnoremap <buffer> <Enter> <Enter>

" Note that the two double quote substitutions are very subtly different (open
" vs close)
command FixQuotes %s/’/'/ge | %s/“/"/ge | %s/”/"/ge

" Command-line mappings and abbreviations
cabbr <expr> eh 'e '..expand('%:h')..'/'
cnoremap <expr> <Space> (getcmdtype() == ':' && getcmdline() == 'eh') ? "\<C-]>" : "\<Space>"
