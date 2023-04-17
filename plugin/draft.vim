fun s:NewDraft(ext, rtf=0) abort
    if $TMPDIR == ''
        echoerr "TMPDIR must be set"
        return
    endif

    call system("mkdir $TMPDIR/drafts")

    cd $TMPDIR/drafts

    exec "edit" (strftime("%Y-%m-%d_%H:%M:%S", localtime()))..'.'..a:ext

    if &filetype == 'bulletnotes' && a:rtf
        au BufUnload <buffer> Export rtf
    elseif &filetype =~ 'bulletnotes\|markdown'
        au BufUnload <buffer> Export
    else
        au BufUnload <buffer> %yank +
    endif

    set titlestring=draft

    startinsert
endfun

com! -nargs=? Draft call <SID>NewDraft(<f-args>)
com! -nargs=0 DraftRTF call <SID>NewDraft('bn', 1)
