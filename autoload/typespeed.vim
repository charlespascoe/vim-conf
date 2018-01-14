function typespeed#InterceptKeyPresses(chars)
    for char in split(a:chars, '\zs')
        execute 'inoremap <buffer> <silent> <expr> '.char.' typespeed#OnKeyPress("'.char.'")'
    endfor
endfunction


let s:delay = 2
let s:timer = -1
let s:keycount = 0
let s:backspaceCount = 0


function typespeed#OnKeyPress(key)
    call typespeed#ResetTextRunTimer()

    let s:keycount = s:keycount + 1

    return a:key
endfunction


function typespeed#OnLeaveInsertMode()
    if s:timer > -1
        call timer_stop(s:timer)
        let s:timer = -1
        call typespeed#OnTextRunComplete(s:timer)
    endif
endfunction


function typespeed#OnBackspace()
    if s:timer > -1
        call timer_stop(s:timer)
        let s:timer = timer_start(s:delay * 1000, function('typespeed#OnTextRunComplete'))
    endif

    let s:backspaceCount = s:backspaceCount + 1
    return "\<BS>"
endfunction


function typespeed#OnTextRunStart()
    let s:keycount = 0
    let s:backspaceCount = 0
    let s:runStart = localtime()
endfunction


function typespeed#ResetTextRunTimer()
    if s:timer > -1
        call timer_stop(s:timer)
    else
        call typespeed#OnTextRunStart()
    endif

    let s:timer = timer_start(s:delay * 1000, function('typespeed#OnTextRunComplete'))
endfunction


function typespeed#OnTextRunComplete(timer)
    if s:runStart == -1
        call typespeed#Append('Warning: -1 start time', '~/.vim/vim-speed.log')
        return
    endif

    let s:lastRunTime = localtime() - s:runStart

    if s:timer > -1
        let s:timer = -1
        let s:lastRunTime = s:lastRunTime - s:delay " Account for delay
    endif

    let s:lastRunTime = s:lastRunTime + 1 " Always round up

    let path = '~/.vim/typespeed'

    if $KEYBOARD != ''
        let path .= '-'.$KEYBOARD
    endif

    let path .= '.txt'

    call typespeed#Append(s:runStart.' '.s:lastRunTime.' '.s:keycount.' '.s:backspaceCount, path)

    let s:runStart = -1
endfunction


function typespeed#Append(message, file)
    new
    setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
    put=a:message
    -d
    silent execute 'w! >>' a:file
    q
endfunction


function typespeed#Init()
    autocmd InsertLeave * call typespeed#OnLeaveInsertMode()

    call typespeed#InterceptKeyPresses('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789<>,.()[]{}_-+=')

    imap <buffer> <silent> <expr> <BS> typespeed#OnBackspace()
    imap <buffer> <silent> <expr> <C-H> typespeed#OnBackspace()
endfunction
