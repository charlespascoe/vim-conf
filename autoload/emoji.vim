let s:items = {
    \'smile': '🙂',
    \'grin': '😁',
    \'thumbsup': '👍',
    \'joy': '😂',
    \'grimace': '😬',
\}

fun emoji#RegisterAbbr()
    for key in keys(s:items)
        exec 'iabbr :' .. key .. ': ' .. s:items[key]
    endfor
endfun

fun emoji#RegisterSyntax()
    for key in keys(s:items)
        exec 'syntax match emoji /:' .. key .. ':/ conceal cchar=' .. s:items[key]
    endfor
endfun

fun s:StartsWith(prefix, str)
    if len(a:str) < len(a:prefix)
        return 0
    endif

    return a:prefix ==# strpart(a:str, 0, len(a:prefix))
endfun

fun emoji#Complete(findstart, base)
    if a:findstart
        let lstr = strpart(getline('.'), 0, col('.') - 1)

        let matchstr = matchstr(lstr, '[^[:alnum:]]\zs:[a-z]*$')

        if matchstr == ''
            return -3
        endif

        return len(lstr) - len(matchstr)
    endif

    if len(a:base) == 0
        return []
    endif

    let names = keys(s:items)
    call map(names, {idx, name -> ':'..name..':'})
    call filter(names, {idx, name -> <SID>StartsWith(a:base, name)})
    call sort(names)
    return names
endfun
