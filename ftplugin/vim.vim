" Turn off autodetection; always use default of 4 spaces
let b:sleuth_automatic=0

setlocal expandtab

call QuickSearchMap('f', 'Functions', '^\s*fun\(c\(tion\)\=\)\=')

fun! FoldIndent()
    if v:lnum == 1
        return '0'
    endif

    let l:line = getline(v:lnum)

    " TODO: More
    if l:line =~ '^\s*\%(if\|fun\|for\|while\)'
        return 'a1'

    elseif l:line =~ '^\s*end'
        return 's1'

    else
        return '='
    endif
endfun

setlocal foldenable
setlocal foldexpr=FoldIndent()
setlocal foldmethod=expr

setlocal iskeyword+=:

fun s:ToggleGuiCol()
    py3 import col

    let w = expand('<cWORD>')

    let m = matchlist(w, '^gui\([fb]g\)=\(#\x\{6\}$\)')

    if len(m) > 0
        let @" = 'cterm'..m[1]..'='..py3eval("col.hex_to_ansi256('"..m[2].."')")
        normal griW
        return
    endif

    let m = matchlist(w, '^cterm\([fb]g\)=\(\d\+\)')

    if len(m) > 0
        let @" = 'gui'..m[1]..'='..py3eval("col.ansi256_to_hex(int('"..m[2].."'))")
        normal griW
        return
    endif

    echoerr "Cursor must be on a highlight colour"
endfun

command -buffer ToggleGuiCol call <SID>ToggleGuiCol()

" Search tags by including scope
nnoremap <buffer> <C-]> <Cmd>set iskeyword+=<,> <bar> let name = expand('<cword>') <bar> set iskeyword-=<,> <bar> exec "tag" substitute(name, '<'.'SID'.'>', 's:', '')<CR>

fun s:GetDictationContext()
    let syn = synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name")

    let prompt = ''
    let transforms = ['camelcase']

    if syn == 'Comment'
        let prompt = dictate#GetLeadingComment()
        let transforms = ['comment']
    elseif syn == 'String'
        let prompt = dictate#GetLeadingString()
        " TODO: Check to see if it's actually a double-quoted versus a
        " single-quoted string
        let transforms = ['default', 'dqesc']
    elseif syn == 'Function'
        let prompt = 'The function name is:'
        let transforms = ['camelcase']
    endif

    return #{prompt: prompt, transforms: transforms}
endfun

let b:get_dictation_context = function('s:GetDictationContext')
