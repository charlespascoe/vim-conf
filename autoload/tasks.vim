fun tasks#temp(chgdir=1) abort
    if $TMPDIR == ''
        echoerr "TMPDIR must be set"
        return
    else
        call system('mkdir $TMPDIR/tasks')
    endif

    let prefix = ""

    if a:chgdir
        cd $TMPDIR/tasks
    else
        let prefix = "$TMPDIR/"
    endif

    exec "edit" prefix..(strftime("%Y-%m-%d_%H:%M:%S", localtime()))..'.md'

    let b:get_dictation_context = function('tasks#context')

    au BufUnload <buffer> call tasks#quickadd()

    startinsert
endfun

fun tasks#quickadd()
    let md = trim(py3eval('mdjoin.join()'))

    if md == ''
        return
    endif

    let lines = split(md, "\n")
    let title = lines[0]
    let notes = trim(join(lines[1:], "\n"))

    let url = 'things:///add?title='..UrlEncode(title)

    if notes != ''
        let url .= '&notes='..UrlEncode(notes)
    endif

    let @+ = notes

    call system('open -g '..shellescape(url))
endfun

fun tasks#context()
    let prompt = (line('.') == 1 ? 'The task is: ' : '')..dictate#GetLeadingParagraph()
    return #{prompt: prompt}
endfun

function! UrlEncode(str)
    return map(a:str, {_, chr -> chr =~ '[-_.~a-zA-Z0-9]' ? chr : printf("%%%02x", char2nr(chr))})
endfunction
