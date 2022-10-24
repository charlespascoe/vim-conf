set foldmethod=expr

fun! FoldIndent()
    let l:lnum = get(v:, 'lnum', line('.'))

    if l:lnum == 1
        return '0'
    endif

    let l:prevline = getline(l:lnum-1)
    let l:line = getline(l:lnum)

    if l:line =~ '^type'
        return '0'
    elseif l:prevline =~ '^type'
        return '>1'

    elseif l:line =~ '^func\s\+\((\|New\)'
        " return '1'
        return '='
    elseif l:prevline =~ '^func\s\+\((\|New\)'
        " return '>2'
        return '='

    elseif l:line =~ '^func'
        return '0'
    elseif l:prevline =~ '^func'
        return '>1'

    " elseif l:line =~ '^}'
    "     return (synIDattr(synID(l:lnum, 1, 0), "name") == 'goStructTypeBraces') ? '=' : 's1'

    elseif l:line =~ '^//' || l:line == ''
        return '-1'
    else
        return '='
    endif
endfun

set foldexpr=FoldIndent()

set foldlevel=100
