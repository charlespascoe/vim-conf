fun! CustomComplete(findstart, base)
    let line = getline('.')
    let pos = col('.') - 7

    while pos >= 0 && strpart(line, pos, 6) != "from '"
        let pos -= 1
    endwhile

    if pos < 0
        return tsuquyomi#complete(a:findstart, a:base)
    endif

    let pos += 6

    if a:findstart
        return pos
    else
        for module in split(system('~/.vim/after/ftplugin/findts.sh "' . substitute(a:base, '"', '', 'g') . '"'), '\n')
            call complete_add({'word': module,'menu':'module'})
        endfor

        call tsuquyomi#complete(a:findstart, a:base)
        return []
    endif
endfun

setlocal omnifunc=CustomComplete
