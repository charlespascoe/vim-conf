func dictate#Init()
    if empty(glob('/tmp/dictation'))
        echohl Error
        echom "Dictation server unavailable"
        echohl None
        return
    endif

    let s:ch = ch_open('unix:/tmp/dictation', {
    \    'mode': 'nl',
    \    'callback': 'dictate#OnOutput',
    \    'close_cb': 'dictate#OnExit',
    \})

    inoremap <C-d> <Cmd>call dictate#Start()<CR>

    command! DictationReloadSubstitutions call dictate#ReloadSubstitutions()
endfun

func dictate#Start()
    call ch_sendraw(s:ch, "start-dictation\n")
endfun

func dictate#ReloadSubstitutions()
    call ch_sendraw(s:ch, "reload\n")
endfunc

func dictate#OnOutput(job, msg)
    if mode() == 'i'
        let msg = a:msg

        " Automatically capitalise the first letter after certain characters
        if search('\v(^|[.!?/#]\_s*|")%#', 'bcn') != 0 || search('^\s\+[-*+?<>]\s\+\%#', 'bcn') != 0
            let msg = toupper(msg[0]).msg[1:]
        endif

        let @" = substitute(msg, '\\n', '\n', 'g')

        call feedkeys("\<C-r>".'"')
    endif
endfun

func dictate#OnExit(job)
    echoerr "Dictation socket closed"
endfun
