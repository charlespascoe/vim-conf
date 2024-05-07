setlocal textwidth=80
setlocal spell
setlocal comments=://

" Add '-' to iskeyword so that we can use 'w' to navigate URL slugs e.g. 'foo-bar'
setlocal iskeyword+=-

fun! FoldLevel(lnum)
    let l:line = getline(a:lnum)

    let l:match = matchlist(l:line, '^\(=\+\) ')
    if len(l:match) > 0
        " return len(l:match[1]) - 1
        return l:match[1] == '=' ? '0' : '1'
    endif

    if len(l:line) > 0
        return '='
    endif

    let l:ln = a:lnum + 1

    while l:ln <= line('$')
        let l:nextline = getline(l:ln)
        if len(l:nextline) == 0 || l:nextline =~ '^[['
            let l:ln += 1
            continue
        endif

        let l:match = matchlist(l:nextline, '^\(=\+\) ')
        if len(l:match) > 0
            return '0'
        endif

        " We found a non-empty line that isn't a heading
        break
    endwhile

    return '='
endfun

setlocal foldmethod=expr
setlocal foldexpr=FoldLevel(v:lnum)

" TODO: Fix this momumental hack
fun! FixFormatOptions(timer)
    " Use textwidth for line formatting
    setlocal formatoptions+=t
endfun

" In the few free minutes I had, I was unable to figure out how to override
" asciidoctor's default formatoptions, so I quickly put this together.
" This needs a proper solution.
call timer_start(200, 'FixFormatOptions')

let b:get_dictation_prompt = function('dictation#GetLeadingParagraph')
