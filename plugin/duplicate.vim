let s:duplicate_count = 1

fun! s:Duplicate(type = '')
    if a:type == ''
        let s:duplicate_count = v:count1
        set opfunc=<SID>Duplicate
        " <Esc> is needed so that v:count doesn't get passed to the motion or
        " text object
        return "\<Esc>g@"
    endif

    if a:type ==# 'line' || a:type ==# 'V' || a:type ==# 'char'
        exec "normal! '[V']y']".s:duplicate_count."p"
    else
        echom a:type
    endif

endfun

nmap <expr> gd <SID>Duplicate()
nmap gdd <Cmd>exec 'normal yy'.v:count1.'p'<CR>
