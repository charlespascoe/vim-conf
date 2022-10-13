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
command! FormatJson %!python -m json.tool

" This needs to be '<Esc>:' because it expects user input
noremap <leader>R <Esc>:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Move a single line

" Edit macros

nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr>

" Line spread
let g:line_spread_append_last = 1

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
command SyntaxSync syntax sync fromstart

" This autocommand may cause performance issues
autocmd BufEnter,InsertLeave * :syntax sync fromstart

let s:duplicate_count = 1

fun! Duplicate(type = '')
    if a:type == ''
        let s:duplicate_count = v:count1
        set opfunc=Duplicate
        return "\<Esc>g@"
    endif

    if a:type ==# 'line' || a:type ==# 'V' || a:type ==# 'char'
        exec "normal! '[V']y']".s:duplicate_count."p"
    else
        echom a:type
    endif

endfun

nnoremap <expr> gd Duplicate()
nnoremap gdd <Cmd>exec 'normal yy'.v:count1.'p'<CR>

" Invert binary

py3 from invert_binary import invert_binary

fun! s:InvertBinary()
    let l:replacement = py3eval("invert_binary(vim.eval('expand(\"<cword>\")'))")

    if l:replacement != ''
        exec 'normal' 'ciw'.l:replacement
    else
        let l:replacement = py3eval("invert_binary(vim.eval('expand(\"<cWORD>\")'))")

        if l:replacement != ''
            exec 'normal' 'ciW'.l:replacement
        end
    end

    call repeat#set("\<Plug>(InvertBinary)", 1)
endfun

nnoremap <silent> <Plug>(InvertBinary) :<C-u>call <SID>InvertBinary()<CR>

nmap <leader>n <Plug>(InvertBinary)

" Enter Improvements

nmap <Enter> i<Enter><Space><BS><Esc><Right>

" This prevents the above from interfering with quickfix and location lists
au FileType qf nnoremap <buffer> <Enter> <Enter>

" Note that the two double quote substitutions are very subtly different (open
" vs close)
command FixQuotes %s/’/'/ge | %s/“/"/ge | %s/”/"/ge

" Set indent level marker based on shiftwidth (only applies to space-indented
" files)

fun s:SetIndentMarker()
    let lc = &l:listchars

    if lc == ''
        let lc = &listchars
    end

    let lcopts = filter(split(lc, ','), 'v:val !~ "^leadmultispace"')

    let sw = &l:shiftwidth

    if sw == 0
        let sw = &shiftwidth
    end

    call add(lcopts, 'leadmultispace:│'.repeat(' ', sw-1))

    let &l:listchars = join(lcopts, ',')
endfun

au BufReadPost * call <SID>SetIndentMarker()
au OptionSet shiftwidth call <SID>SetIndentMarker()

" Command-line mappings and abbreviations
cabbr <expr> eh 'e '..expand('%:h')..'/'
cnoremap <expr> <Space> (getcmdtype() == ':' && getcmdline() == 'eh') ? "\<C-]>" : "\<Space>"
