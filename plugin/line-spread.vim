fun! s:TrimItem(index, text)
    return trim(a:text)
endfun

fun! s:SpreadAcrossLines(charCode, input)
    if a:charCode == 13
        return a:input
    endif

    let splitChar = printf('%c', a:charCode)

    let items = map(split(a:input, splitChar), function("<SID>TrimItem"))
    let lines = join(items, splitChar."\n")

    if get(b:, 'line_spread_append_last', 1)
        let lines .= splitChar
    endif

    return lines
endfun

fun! s:SeparatorSpread(type)
    if a:type ==# 'char'
        let charCode = getchar()
        exec 'normal!' "`[v`]c\<Enter>\<Up>"
        let lines = split(<SID>SpreadAcrossLines(charCode, @"), "\n")
        call append(line('.'), lines)
        exec 'normal!' "\<Down>=".len(lines)."="
    else
        echom "CommaSpread: Unhandled type ".a:type
    endif
endfun

nmap gS <Cmd>set operatorfunc=<SID>SeparatorSpread<CR>g@
