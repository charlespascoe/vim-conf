let s:in_insert_mode = v:false

func dictate#Init()
    if empty(glob('/tmp/dictation'))
        echom "Dictation server unavailable"
        return
    endif

    let s:job = job_start('socat - UNIX-CONNECT:/tmp/dictation', {
    \    'out_io': 'pipe',
    \    'err_io': 'pipe',
    \    'in_io': 'pipe',
    \    'mode': 'nl',
    \    'callback': 'dictate#OnOutput',
    \    'err_cb': 'dictate#OnError',
    \    'exit_cb': 'dictate#OnExit',
    \    'stoponexit': 'term'
    \})

    inoremap <C-d> <C-o>:call dictate#Start()<CR>

    autocmd InsertEnter * call dictate#EnterInsertMode()
    autocmd InsertLeave * call dictate#LeaveInsertMode()

    command! DictationReloadSubstitutions call dictate#ReloadSubstitutions()
endfun

func dictate#Start()
    let ch = job_getchannel(s:job)

    call ch_sendraw(ch, "start-dictation\n")
endfun

func dictate#ReloadSubstitutions()
    let ch = job_getchannel(s:job)

    call ch_sendraw(ch, "reload\n")
endfunc

func dictate#OnOutput(job, msg)
    if s:in_insert_mode
        let msg = a:msg

        " Automatically capitalise the first letter after certain characters
        if search('\v(^|[.!?/#]\_s*|")%#', 'bcn') != 0 || search('^\s\+[-*+?<>]\s\+\%#', 'bcn') != 0
            let msg = toupper(msg[0]).msg[1:]
        endif

        let @" = substitute(msg, '\\n', '\n', 'g')

        call feedkeys("\<C-r>".'"')
    endif
endfun

func dictate#OnError(job, msg)
    echom "Msg: ".a:msg
endfun

func dictate#OnExit(job, code)
    echom "Code: ".a:code
endfun

func dictate#EnterInsertMode()
    let s:in_insert_mode = v:true
endfunc

func dictate#LeaveInsertMode()
    let s:in_insert_mode = v:false
endfunc
