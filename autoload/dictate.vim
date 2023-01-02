let s:socket = '/tmp/dictation.sock'

func dictate#Init()
    if empty(glob(s:socket))
        echohl Error
        echom "Dictation server unavailable"
        echohl None
        return
    endif

    try
        let s:ch = ch_open('unix:'..s:socket, {
        \    'mode': 'nl',
        \    'callback': 'dictate#OnOutput',
        \    'close_cb': 'dictate#OnExit',
        \})
    catch
        echohl Error
        echom "Couldn't connect to dictation server:" v:exception
        echohl None
        return 0
    endtry

    inoremap <C-d> <Cmd>call dictate#Start()<CR>

    command! DictationReloadSubstitutions call dictate#ReloadSubstitutions()

    augroup dictation
        au!
        au FocusGained * call dictate#FocusGained()
        au FocusLost * call dictate#FocusLost()
    augroup END

    return 1
endfun

fun s:send(msg)
    if !exists('s:ch') || (ch_status(s:ch) != "open" && !dictate#Init())
        return
    endif

    call ch_sendraw(s:ch, json_encode(a:msg).."\n")
endfun

fun dictate#FocusGained()
    call s:send(#{type: 'focus'})
endfun

fun dictate#FocusLost()
    call s:send(#{type: 'blur'})
endfun

func dictate#Start()
    call s:send(#{type: "dictation", active: v:true})

    au InsertLeave * ++once call dictate#Stop()
endfun

func dictate#Stop()
    call s:send(#{type: "dictation", active: v:false})
endfun

func dictate#ReloadSubstitutions()
    " call ch_sendraw(s:ch, "reload\n")
endfunc

func dictate#OnOutput(ch, msg)
    if mode() != 'i'
        return
    endif

    let msg = json_decode(a:msg)

    if msg.type != "transcription"
        return
    endif

    let text = msg.text

    " Automatically capitalise the first letter after certain characters
    if search('\v(^|[.!?/#]\_s*|")%#', 'bcn') != 0 || search('^\s\+[-*+?<>]\s\+\%#', 'bcn') != 0
        let text = toupper(text[0]).text[1:]
    endif

    if text =~ '^\c[a-z]' && search('\v\S%#', 'bcn')
        let text = ' '.text
    endif

    if !msg.final
        if !exists('b:_dictate_popup')
            let b:_dictate_popup = popup_atcursor(text, #{pos: 'topleft', line: 'cursor', col: 'cursor'})
        else
            call popup_settext(b:_dictate_popup, text)
        endif
    else
        let @" = text
        call feedkeys("\<C-r>".'"')

        if exists('b:_dictate_popup')
            unlet b:_dictate_popup
        endif
    endif
endfun

func dictate#OnExit(ch)
    echohl Error
    echom "Dictation socket closed"
    echohl None
endfun
