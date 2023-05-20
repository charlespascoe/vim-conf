fun tasks#temp(edit="edit", chgdir=1) abort
    if $TMPDIR == ''
        echoerr "TMPDIR must be set"
        return
    else
        call system('mkdir $TMPDIR/tasks')
    endif

    let prefix = ""

    if a:chgdir
        lcd $TMPDIR/tasks
    else
        let prefix = "$TMPDIR/"
    endif

    exec a:edit prefix..'Task_'..(strftime("%Y-%m-%d_%H:%M:%S", localtime()))..'.md'

    let b:get_dictation_context = function('tasks#context')

    setlocal bufhidden=wipe
    setlocal nobuflisted
    setlocal winfixwidth

    au WinClosed <buffer> w
    au BufUnload <buffer> call tasks#quickadd()
    nmap <Enter> <Cmd>w <bar> call tasks#temp()<CR>

    startinsert
endfun

fun tasks#quickadd()
    let md = trim(py3eval('mdjoin.join()'))

    if md == ''
        return
    endif

    let @+ = md

    let lines = split(md, "\n")
    let title = lines[0]
    let notes = trim(join(lines[1:], "\n"))

    if title == ''
        return
    endif

    let url = 'things:///add?title='..UrlEncode(title)

    if notes != ''
        let url .= '&notes='..UrlEncode(notes)
    endif

    " Use job_start to add the task asynchronously, and do not stop the job when
    " Vim exits
    call job_start(['open', '-g', url], #{stoponexit: ""})
endfun

fun tasks#context()
    let prompt = (line('.') == 1 ? 'The task is: ' : '')..dictate#GetLeadingParagraph()
    return #{prompt: prompt}
endfun

function! UrlEncode(str)
    return map(a:str, {_, chr -> chr =~ '[-_.~a-zA-Z0-9]' ? chr : printf("%%%02x", char2nr(chr))})
endfunction
