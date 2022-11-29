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
