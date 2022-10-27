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
