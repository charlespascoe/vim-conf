vim9script

def ReSub(pat: string, sub: string): func(string): string
    return (s: string): string => substitute(s, '^' .. pat .. '$', sub, '')
enddef

def AddCaseVariants(subs: list<any>, a: string, b: string)
    add(subs, [a, b])
    if len(a) > 1 && len(b) > 1
        add(subs, [toupper(a[0]) .. a[1 : ], toupper(b[0]) .. b[1 : ]])
    endif
    add(subs, [toupper(a), toupper(b)])
enddef

var invert_binary_subs: list<any> = [
    ['==', '!='],
    ['-=', '+='],
    ['===', '!=='],
    ['>', '<='],
    ['<', '>='],
    ['||', '&&'],
    ['+', '-'],
    ['1', '0'],
]

AddCaseVariants(invert_binary_subs, 'true', 'false')
AddCaseVariants(invert_binary_subs, 'yes', 'no')
AddCaseVariants(invert_binary_subs, 'y', 'n')
AddCaseVariants(invert_binary_subs, 'on', 'off')
AddCaseVariants(invert_binary_subs, 'required', 'optional')
AddCaseVariants(invert_binary_subs, 'positive', 'negative')
AddCaseVariants(invert_binary_subs, 'and', 'or')
AddCaseVariants(invert_binary_subs, 'min', 'max')
AddCaseVariants(invert_binary_subs, 'include', 'exclude')
AddCaseVariants(invert_binary_subs, 'start', 'end')
AddCaseVariants(invert_binary_subs, 'major', 'minor')
AddCaseVariants(invert_binary_subs, 'top', 'bottom')
AddCaseVariants(invert_binary_subs, 'up', 'down')
AddCaseVariants(invert_binary_subs, 'left', 'right')
AddCaseVariants(invert_binary_subs, 'first', 'last')
AddCaseVariants(invert_binary_subs, 'upper', 'lower')

# Put regex substitutions at the end
add(invert_binary_subs, ReSub('enabl\(ing\|e[sd]\?\)', 'disabl\1'))
add(invert_binary_subs, ReSub('disabl\(ing\|e[sd]\?\)', 'enabl\1'))
add(invert_binary_subs, ReSub('Enabl\(ing\|e[sd]\?\)', 'Disabl\1'))
add(invert_binary_subs, ReSub('Disabl\(ing\|e[sd]\?\)', 'Enabl\1'))

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
