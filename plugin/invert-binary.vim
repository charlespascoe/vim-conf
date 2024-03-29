vim9script

def ReSub(pat: string, sub: string): func(string): string
    return (s: string): string => substitute(s, '^' .. pat .. '$', sub, '')
enddef

var invert_binary_subs = [
    ['true', 'false'],
    ['True', 'False'],
    ['TRUE', 'FALSE'],
    ['y', 'n'],
    ['Y', 'N'],
    ['yes', 'no'],
    ['Yes', 'No'],
    ['YES', 'NO'],
    ['Required', 'Optional'],
    ['required', 'optional'],
    ['positive', 'negative'],
    ['Positive', 'Negative'],
    ['==', '!='],
    ['-=', '+='],
    ['===', '!=='],
    ['>', '<='],
    ['<', '>='],
    ['||', '&&'],
    ['and', 'or'],
    ['AND', 'OR'],
    ['min', 'max'],
    ['Min', 'Max'],
    ['MIN', 'MAX'],
    ['+', '-'],
    ['1', '0'],
    ['start', 'end'],
    ['Start', 'End'],
    ['START', 'END'],
    ReSub('enabl\(ing\|e[sd]\?\)', 'disabl\1'),
    ReSub('disabl\(ing\|e[sd]\?\)', 'enabl\1'),
    ReSub('Enabl\(ing\|e[sd]\?\)', 'Disabl\1'),
    ReSub('Disabl\(ing\|e[sd]\?\)', 'Enabl\1'),
]

def Invert(s: string): string
    for item in get(b:, 'invert_binary_subs', []) + invert_binary_subs
        if type(item) == v:t_func
            var Replace: func(string): string = item
            var result = Replace(s)

            if result != s
                return result
            endif

            continue
        endif

        var [a, b] = item

        if s == a
            return b
        elseif s == b
            return a
        endif
    endfor

    return ''
enddef

def InvertBinary()
    var replacement = Invert(expand('<cWORD>'))

    if replacement != ''
        exec 'normal!' 'ciW' .. replacement
    else
        replacement = Invert(expand('<cword>'))

        if replacement != ''
            exec 'normal!' 'ciw' .. replacement
        else
            InvertBinaryLiteral()
        endif
    endif

    call repeat#set("\<Plug>(InvertBinary)", 1)
enddef

def InvertBinaryLiteral()
    var word = expand('<cword>')

    if word !~ '^0b[01]\+$'
        return
    endif

    var line = getline('.')

    var i = col('.') - 1
    var chr = line[i]

    if chr =~ '[01]' && strpart(line, i) !~ '^0b'
        chr = chr == '0' ? '1' : '0'
        exec 'normal!' 'r' .. chr
    endif
enddef

nmap <Plug>(InvertBinary) <ScriptCmd>call InvertBinary()<CR>

nmap s <Plug>(InvertBinary)
