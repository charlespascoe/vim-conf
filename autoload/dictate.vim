let s:socket = '/tmp/dictation.sock'
let s:status = ""

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

    echo "Connected to dictation server"

    inoremap <C-d> <Cmd>call dictate#Start()<CR>

    command! DictationReloadSubstitutions call dictate#ReloadSubstitutions()

    augroup dictation
        au!
        au FocusGained * call dictate#FocusGained()
        au FocusLost * call dictate#FocusLost()
        au CursorMovedI * call <SID>onInput()
    augroup END

    py3 import dictate

    return 1
endfun

fun s:send(msg)
    if !exists("s:ch") || (ch_status(s:ch) != "open" && !dictate#Init())
        return
    endif

    call ch_sendraw(s:ch, json_encode(a:msg).."\n")
endfun

fun dictate#FocusGained()
    call s:send(#{type: "focus"})
endfun

fun dictate#FocusLost()
    call s:send(#{type: "blur"})
endfun

func dictate#Start()
    call s:send(#{type: "dictation", active: v:true})

    au InsertLeave * ++once call dictate#Stop()
endfun

fun dictate#Pause(dur)
    call s:send(#{type: "pause", dur: a:dur})
endfun

func dictate#Stop()
    call s:send(#{type: "dictation", active: v:false})
endfun

func dictate#ReloadSubstitutions()
    call s:send(#{type: "reload-substitutions"})
endfunc

fun dictate#GetStatusText()
    return s:status
endfun

func dictate#OnOutput(ch, msg)
    let msg = json_decode(a:msg)

    if msg.type == "transcription"
        call s:handleTrascriptionMessage(msg)
    elseif msg.type == "status"
        call s:updateStatus(msg.status, msg.activeClient)
    else
        echom a:msg
    endif
endfun

let s:disable_pause = 0

fun s:onInput()
    if s:disable_pause
        let s:disable_pause = 0
        return
    endif

    call dictate#Pause(300)
endfun

fun s:handleTrascriptionMessage(msg)
    let md = mode()

    if md != 'i' && md != 's' && md != 'v'
        return
    endif

    if md == 'v'
        " Replace the text and enter insert mode
        call feedkeys('c')
    endif

    let text = a:msg.text

    if !a:msg.final
        if !exists('b:_dictate_popup')
            let b:_dictate_popup = popup_atcursor(text, #{pos: 'topleft', line: 'cursor', col: 'cursor'})
        else
            call popup_settext(b:_dictate_popup, text)
        endif
    else
        let g:_dictate_insert = text
        let s:disable_pause = 1
        silent call feedkeys("\<C-r>=g:_dictate_insert\<CR>")

        if exists('b:_dictate_popup')
            call popup_close(b:_dictate_popup)
            unlet b:_dictate_popup
        endif
    endif
endfun

let s:cols = #{
    \ idle: g:dracula#palette.comment[0],
    \ listen: '#DD69AB',
    \ dictate: '#FF5555',
    \ error: '#FF5555',
    \ paused: '#037E98',
\}

fun s:updateStatus(status, active_client)
    let s:status = a:status

    if s:status == 'dictate' && a:active_client && exists('*b:get_dictation_context')
        let context = b:get_dictation_context()

        " TODO: Check that the context is a dictionary
        let context["type"] = "context"

        call s:send(context)
    elseif s:status == 'dictate' && exists('*b:get_dictation_prompt')
        call s:send(#{type: 'context', prompt: b:get_dictation_prompt()})
    endif

    let l:col = get(s:cols, s:status, g:dracula#palette.comment[0])
    for [name, colours] in items(g:airline#themes#{g:airline_theme}#palette)
        if name == 'inactive'
            continue
        endif

        if has_key(colours, 'airline_y')
            let colours.airline_y[1] = l:col
        endif
    endfor

    let w:airline_lastmode = ''
    " AirlineRefresh
    " This tricks Airline into updating the colours from the theme
    call airline#check_mode(winnr())
    " This causes Airline to refresh the status line
    call airline#update_statusline()
endfun

func dictate#OnExit(ch)
    echohl Error
    echom "Dictation socket closed"
    echohl None
    call s:updateStatus("error")
endfun

func! dictate#GetLeadingComment()
    return py3eval('dictate.get_leading_comment()')
endfunc

func! dictate#GetLeadingString()
    return py3eval('dictate.get_leading_string()')
endfunc

func! dictate#GetLeadingParagraph()
    return py3eval('dictate.get_leading_paragraph()')
endfunc
