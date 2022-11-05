fun s:range(start, end)
    if type(a:start) != type(a:end)
        throw "start and end must be the same type"
    endif

    if type(a:start) == v:t_string
        return map(range(char2nr(a:start), char2nr(a:end)), {_, item -> nr2char(item)})
    endif

    let result = []

    let i = a:start

    while i <= a:end
        call add(result, i)
        let i += 1
    endwhile

    return result
endfun

fun s:combine(prefix, items)
    return map(copy(a:items), {_, item -> a:prefix .. item})
endfun

let s:special_keycodes = [
    \ 'Nul',
    \ 'BS',
    \ 'Tab',
    \ 'NL',
    \ 'CR',
    \ 'Return',
    \ 'Enter',
    \ 'Esc',
    \ 'Bar',
    \ 'Del',
    \ 'CSI',
    \ 'xCSI',
    \ 'EOL',
    \ 'Up',
    \ 'Down',
    \ 'Left',
    \ 'Right',
    \ 'Help',
    \ 'Undo',
    \ 'Insert',
    \ 'Home',
    \ 'End',
    \ 'PageUp',
    \ 'PageDown',
    \ 'kHome',
    \ 'kEnd',
    \ 'kPageUp',
    \ 'kPageDown',
    \ 'kPlus',
    \ 'kMinus',
    \ 'kMultiply',
    \ 'kDivide',
    \ 'kEnter',
    \ 'kPoint',
    \]

" An odd key sequence that occasionally shows up
" https://vi.stackexchange.com/questions/35206/inserting-the-content-of-a-register-where-a-macro-is-recorded-results-in-control#answer-35207
let s:key_nop = "\x80\xfda"

call extend(s:special_keycodes, s:combine('k', s:range(0, 9)))
call extend(s:special_keycodes, s:combine('F', s:range(1, 12)))

let s:modifiable_chars = ['Bslash', 'Space']

let s:alpha_chars = s:range('a', 'z')

" TODO: Combinations of modifiers
let s:modifiers = ["C", "S", "M", "D"]

let s:map = {}

fun s:replace(str, keyseq)
    return substitute(a:str, '\V'..escape(eval('"\<'.a:keyseq.'>"'), '/\'), '\\<'.a:keyseq.'>', 'g')
endfun

fun macroeditor#replace(str)
    let str = a:str

    let str = substitute(str, s:key_nop, '', 'g')
    let str = escape(str, '\')

    for modifier in s:modifiers
        for key in s:special_keycodes
            let str = s:replace(str, modifier.'-'.key)
        endfor

        for key in s:modifiable_chars
            let str = s:replace(str, modifier.'-'.key)
        endfor

        if modifier != 'S'
            for key in s:alpha_chars
                let str = s:replace(str, modifier.'-'.key)
            endfor
        endif
    endfor

    for key in s:special_keycodes
        let str = s:replace(str, key)
    endfor

    return str
endfun

fun macroeditor#replace_with_quotes(str)
    return '"'.escape(macroeditor#replace(a:str), '"').'"'
endfun

" TODO: Maybe use TextChanged and TextYankPost events while a macro is recording
" to make note of when each operation occurs to provide a list of each command?
