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

command! -nargs=1 -complete=help Help Split help <args>

command! ShowHead call ShowHead()

fun s:MoveBuf(to) abort
    let l:altbuf = bufnr('#')
    let l:curfile = expand('%')

    exec 'saveas' fnameescape(a:to)
    " 'saveas' command creates an unlisted buffer with the old name, which it sets
    " as the alternate buffer. We want to completely remove it with :bw
    exec 'bw' bufnr('#')

    " Delete the old file
    call delete(l:curfile)

    " Restore the original alternate buffer
    let @# = l:altbuf
endfun

if !exists(':Move')
    command -nargs=+ -complete=file Move call <SID>MoveBuf(<f-args>)
endif

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
nnoremap <expr> ' printf("'%czz", getchar())
nnoremap ]c <Plug>(GitGutterNextHunk)zz
nnoremap [c <Plug>(GitGutterPrevHunk)zz

" Move a single line

nmap <silent> <C-j> ]e
nmap <silent> <C-k> [e

" Jump to imports marker

noremap <leader>i `iO

" Undo history navigation

nmap - g-<Cmd>echo "Change "..changenr()<CR>
nmap + g+<Cmd>echo "Change "..changenr()<CR>

" Format JSON
command! FormatJson %!python3 -m json.tool

" This needs to be '<Esc>:' because it expects user input
noremap <leader>R <Esc>:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Macros

fun s:RepeatMacroUntilDone()
    let l:reg = v:register

    if l:reg !~ '[a-z]'
        echoerr "You need to supply a register"
        return
    endif

    let l:repeat_reg = 'x'

    if l:reg == l:repeat_reg
        let l:repeat_reg = 'y'
    endif

    let l:prev_reg = getreg(l:repeat_reg)

    call setreg(l:repeat_reg, '@'.l:reg.'@'.l:repeat_reg)

    exec 'silent!' 'normal' '@'.l:repeat_reg

    call setreg(l:repeat_reg, l:prev_reg)
endfun


nnoremap <leader>me :<c-u><c-r><c-r>='let @'. v:register .' = '. macroeditor#replace_with_quotes(getreg(v:register))<cr>
nnoremap <leader>mr <Cmd>call <SID>RepeatMacroUntilDone()<CR>

" Quick Search
fun! QuickSearchMap(key, title, pattern)
    exec "nnoremap <silent> <buffer> <leader>s".a:key." :vert lvimgrep /".a:pattern."/ % \\| call setloclist(0, [], 'a', {'title': '".a:title."'}) \\| lopen<CR>"
endfun

" Make n and N move through location list when open
nnoremap <expr> n get(getloclist(0, {'winid':0}), 'winid', 0) ? <SID>NextItem() : '<Cmd>setlocal hlsearch<CR>'..v:count1..'nzzzv'
nnoremap <expr> N get(getloclist(0, {'winid':0}), 'winid', 0) ? '<Cmd>lprev<CR>zzzv' : '<Cmd>setlocal hlsearch<CR>'..v:count1..'Nzzzv'

" TODO: Handle selecting a specific one first (check the current index)
func s:NextItem()
    let d = getloclist(0, {'qfbufnr':0,'id':0})
    let l:bufid = get(d, 'qfbufnr', 0)
    let l:id = get(d, 'id', 0)

    if l:bufid && getbufvar(l:bufid, 'done_first', 0) != l:id
        call setbufvar(l:bufid, 'done_first', l:id)
        return "\<Cmd>lfirst\<CR>zzzv"
    end

    " Cycling through the list shouldn't change jump list (<C-o> will take you
    " back to the original location where the search was started)
    return "\<Cmd>keepjumps lnext\<CR>zzzv"
endfunc

" Disable search hl after editing
au TextChanged,InsertEnter * set nohlsearch

" Normalise search operators (always center and open folds)
nnoremap * *zzzv
nnoremap # #zzzv

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
" autocmd BufEnter,InsertLeave * :syntax sync fromstart

" Enter Improvements

" fun! NormalEnter()
"     " For readonly buffers or the command line window, then just use a normal
"     " enter
"     return !&ma || bufexists('[Command Line]')
" endfun

" nmap <expr> <Enter> NormalEnter() ? "\<Enter>" : "i\<Enter>\<Space>\<BS>\<Esc>\<Right>"

" Smart Split

command -nargs=* -complete=command Split exec ((winwidth(0)*0.5) > winheight(0) ? 'vert' : '') <q-args>

" Scratch file

fun! Scratch()
    vert split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
endfun

command -bar Scratch call Scratch()

" Note that the two double quotes are very subtly different (open vs close)
command -bar FixQuotes %s/’/'/ge | %s/[“”]/"/ge

command Scriptnames redir @" | silent scriptnames | redir END | Scratch | exec 'normal p'
command SyntimeReport syntime off | redir @" | silent syntime report | redir END | Scratch | exec 'normal p'
command SyntimeStart syntax off | silent syntime on | syntax on
command Syntax redir @" | exec "silent syntax" | redir END | Scratch | exec 'normal p'

fun s:ToggleConceal()
    let &l:conceallevel = &l:conceallevel == 0 ? 2 : 0
endfun

nmap yoC <Cmd>call <SID>ToggleConceal()<CR>

" Jumps if there's one tag match, otherwise opens 'tselect' list
nnoremap <C-]> g<C-]>

" Paste commented; had to use nnoremap to prevent ` mapping from breaking this,
" which in turn means we have to use '<Plug>Commentary' instead of 'gc'
nnoremap <leader>p p`[v`]<Plug>Commentary
