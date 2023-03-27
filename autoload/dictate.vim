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
        call s:updateStatus(msg.status)
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

    let text = ''

    if exists('b:format_dictated_text')
        let text = b:format_dictated_text(a:msg.text)
    endif

    if text == ''
        let text = a:msg.text

        " Automatically capitalise the first letter after certain characters
        if search('\v(^|[.!?/#]\_s*|")%#', 'bcn') != 0 || search('^\s\+[-*+?<>]\s\+\%#', 'bcn') != 0
            let text = toupper(text[0])..text[1:]
        endif

        if text =~ '^\c[a-z]' && search('\v([^ \t"(])%#', 'bcn')
            let text = ' '..text
        endif
    endif

    if !a:msg.final
        if !exists('b:_dictate_popup')
            let b:_dictate_popup = popup_atcursor(text, #{pos: 'topleft', line: 'cursor', col: 'cursor'})
        else
            call popup_settext(b:_dictate_popup, text)
        endif
    else
        let @" = text
        let s:disable_pause = 1
        call feedkeys("\<C-r>"..'"')

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

fun s:updateStatus(status)
    let s:status = a:status

    if s:status == 'dictate' && exists('*b:get_dictation_prompt')
        let prompt = b:get_dictation_prompt()

        " TODO: Check that the prompt is a string

        " This is a simple dictation test
        call s:send(#{type: "prompt", prompt: prompt})
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

function! dictate#GetLeadingComment()
    return py3eval('dictate.get_leading_comment()')
endfunction

function! dictate#GetLeadingString()
    return py3eval('dictate.get_leading_string()')
endfunction

function! dictate#GetLeadingParagraph()
    return py3eval('dictate.get_leading_paragraph()')
endfunction
