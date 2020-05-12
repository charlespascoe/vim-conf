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

" Auto-Paste Mode

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction


function! ShowHead()
    let l = line('.')
    Gvsplit HEAD:%
    execute l
    normal zz
endfunction

command! -nargs=1 -complete=help Help tab help <args>

command! ShowHead call ShowHead()

command! FormatJson %!python -m json.tool

" Syntax highlighting debugging
map <leader>S <Esc>:echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Trim trailing whitespace
command! Trim %s/\s\+$//e

" Jump back to mark centres on cursor
nnoremap <expr> ` printf('`%czz', getchar())

" Jump to imports marker

noremap <leader>i `iO

" Format JSON
command! FormatJson %!python -m json.tool

noremap <leader>R <Esc>:s/<C-r><C-w>//g<Left><Left>

" Move a single line

nnoremap <silent> <leader>j  :<c-u>execute 'move +'. v:count1<cr>
nnoremap <silent> <leader>k  :<c-u>execute 'move -1-'. v:count1<cr>

" Edit macros

nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr>

" Line spread
let g:line_spread_append_last = 0

fun! TrimItem(index, text)
    return trim(a:text)
endfun

fun! SpreadAcrossLines(charCode, input)
    if a:charCode == 13
        return a:input
    endif

    let splitChar = printf('%c', a:charCode)

    let items = map(split(a:input, splitChar), function("TrimItem"))
    let lines = join(items, splitChar."\n")

    if g:line_spread_append_last
        let lines .= splitChar
    endif

    return lines
endfun

fun! SeparatorSpread(type)
    if a:type ==# 'char'
        let charCode = getchar()
        exec 'normal!' "`[v`]c\<Enter>\<Up>"
        let lines = split(SpreadAcrossLines(charCode, @"), "\n")
        call append(line('.'), lines)
        exec 'normal!' "\<Down>=".len(lines)."="
    else
        echom "CommaSpread: Unhandled type ".a:type
    endif
endfun

nnoremap gS :set operatorfunc=SeparatorSpread<CR>g@

" Quick Search

fun! QuickSearchMap(key, pattern)
    " TODO: Properly escape inputs
    exec "nnoremap <buffer> <leader>s".a:key." /".a:pattern."<CR>zz"
    exec "nnoremap <buffer> <leader>S".a:key." ?".a:pattern."<CR>zz"
endfun

" Normalise search operators (always center)

nnoremap n nzz
nnoremap N Nzz

" Make Y consistent with C and D
nnoremap Y y$

" Confirm Spell Good

fun! ConfirmSpellGood()
    let l:word = expand('<cword>')
    let l:conf = input("Make '".l:word."' a good word? [y/N] ")
    return l:conf == 'y'
endfun

nnoremap <expr> <silent> zg ConfirmSpellGood() ? 'zg' : ''
