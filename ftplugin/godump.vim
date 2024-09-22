fun! UpdateLine()
    if !exists('t:dump_go_winid') || len(getwininfo(t:dump_go_winid)) == 0
        return
    end

    let l:match = matchlist(getline('.'), '^\s\+\([^:]\+\.go\):\(\d\+\)')

    if len(l:match) > 0 && l:match[1] == fnamemodify(bufname(winbufnr(t:dump_go_winid)), ':t')
        let l:line = l:match[2]
        let l:height = winheight(t:dump_go_winid)
        let l:topline = min([l:line - (l:height/2), 1])
        call win_execute(t:dump_go_winid, 'call winrestview('..string({'lnum': l:line, 'col': 1, 'topline': l:topline})..')')
    end
endfun

setlocal bufhidden=wipe nobuflisted noswapfile nowrap nospell nonumber norelativenumber

au CursorMoved <buffer> call UpdateLine()

au BufEnter <buffer> set cursorline | match none
au BufLeave <buffer> set nocursorline
au BufWipeout <buffer> call win_execute(t:dump_go_winid, 'au! DumpObject | match none | set nocursorline | unlet t:dump_go_dir t:dump_go_winid t:dump_term_winid') | echom "DumpObject Terminating"
