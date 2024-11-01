fun s:NewDraft(ext, rtf=0, return=0) abort
    if $DRAFTS == ''
        echoerr "DRAFTS must be set"
        return
    endif

    call system("mkdir -p $DRAFTS")

    cd $DRAFTS

    enew

    " Trigger the filetype autocommands manually without setting the file name
    exec "doautocmd BufNewFile file."..a:ext

    let b:__empty = 1
    setlocal bufhidden=wipe
    setlocal nobuflisted
    setlocal winfixwidth

    au TextChanged,TextChangedI,TextChangedP <buffer> call <SID>OnChange()

    if &filetype == 'bulletnotes' && a:rtf
        au BufUnload <buffer> Export rtf
    elseif &filetype =~ 'bulletnotes\|markdown'
        au BufUnload <buffer> Export
    else
        au BufUnload <buffer> %yank +
    endif

    if a:return
        au BufUnload <buffer> call system("tmux switch-client -l")
    endif

    let b:draft_ext = a:ext
    let b:draft_rtf = a:rtf
    let b:draft_return = a:return
    nmap <Enter> <Cmd>w <bar> call <SID>NewDraft(b:draft_ext, b:draft_rtf, b:draft_return)<CR>

    set titlestring=draft
    startinsert
endfun

fun s:OnChange()
    let empty = line('$') == 1 && getline(1) == ''

    if b:__empty && !empty
        if bufname() == ''
            au WinClosed <buffer> w
        endif

        exec "file" (strftime("%Y-%m-%d_%H:%M:%S", localtime()))..'.'..b:draft_ext
    endif

    let b:__empty = empty
endfun

com! -nargs=? Draft call <SID>NewDraft(<f-args>)
com! -nargs=0 DraftRTF call <SID>NewDraft('bn', 1)
com! -nargs=0 DraftReturn call <SID>NewDraft('bn', 0, 1)
com! -nargs=0 DraftReturnMarkdown call <SID>NewDraft('md', 0, 1)
