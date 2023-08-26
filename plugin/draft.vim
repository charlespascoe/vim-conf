fun s:NewDraft(ext, rtf=0) abort
    if $DRAFTS == ''
        echoerr "DRAFTS must be set"
        return
    endif

    call system("mkdir -p $DRAFTS")

    cd $DRAFTS

    enew

    " Trigger the filetype autocommands manually without setting the file name
    exec "doautocmd BufNewFile file."..a:ext

    setlocal bufhidden=wipe
    setlocal nobuflisted
    setlocal winfixwidth

    au InsertEnter <buffer> call <SID>OnInsert()

    if &filetype == 'bulletnotes' && a:rtf
        au BufUnload <buffer> Export rtf
    elseif &filetype =~ 'bulletnotes\|markdown'
        au BufUnload <buffer> Export
    else
        au BufUnload <buffer> %yank +
    endif

    let b:draft_ext = a:ext
    let b:draft_rtf = a:rtf
    nmap <Enter> <Cmd>w <bar> call <SID>NewDraft(b:draft_ext, b:draft_rtf)<CR>

    set titlestring=draft
endfun

fun s:OnInsert()
    if line('$') == 1 && getline(1) == ''
        if bufname() == ''
            au WinClosed <buffer> w
        endif

        exec "file" (strftime("%Y-%m-%d_%H:%M:%S", localtime()))..'.'..b:draft_ext
    endif
endfun

com! -nargs=? Draft call <SID>NewDraft(<f-args>)
com! -nargs=0 DraftRTF call <SID>NewDraft('bn', 1)
